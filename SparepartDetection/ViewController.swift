//
//  ViewController.swift
//  SparepartDetection
//
//  Created by Surya on 26/11/25.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Camera
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let videoOutput = AVCaptureVideoDataOutput()
    
    // MARK: - Vision / CoreML
    private var vnModel: VNCoreMLModel!
    private var detectionRequest: VNCoreMLRequest!
    
    // ✅ UIView overlay container (ANTI BLENDING, FULL SOLID)
    private let boxContainerView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupModel()
        checkPermissionAndStart()
    }
    
    // MARK: - Load ML Model
    private func setupModel() {
        let config = MLModelConfiguration()
        config.computeUnits = .all
        
        guard let mlModel = try? SparepartDetectorLatest(configuration: config).model else {
            fatalError("⚠️ Failed to load SparepartDetect.mlmodel")
        }
        
        vnModel = try? VNCoreMLModel(for: mlModel)
        
        detectionRequest = VNCoreMLRequest(model: vnModel, completionHandler: handleDetection)
        //detectionRequest.imageCropAndScaleOption = .scaleFill
        detectionRequest.imageCropAndScaleOption = .scaleFit

    }
    
    // MARK: - Permission
    private func checkPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.startCamera() : self.showAlert()
                }
            }
        default:
            showAlert()
        }
    }
    
    // MARK: - Start Camera
    private func startCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back) else {
            print("No camera")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        // Input
        if let input = try? AVCaptureDeviceInput(device: device),
           captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Output
        videoOutput.setSampleBufferDelegate(self,
                                            queue: DispatchQueue(label: "camera_frame_queue"))
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        captureSession.commitConfiguration()
        
        // Preview Layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // ✅ SOLID UIView Overlay (DI ATAS VIDEO)
        boxContainerView.frame = view.bounds
        boxContainerView.backgroundColor = .clear
        boxContainerView.isUserInteractionEnabled = false
        view.addSubview(boxContainerView)
        
        // Start camera async
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Needed",
            message: "Enable camera access in Settings to use live detection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Convert Vision Box → Screen Box
    private func convertRect(_ boundingBox: CGRect) -> CGRect {
        return previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
    }
    
    // MARK: - Draw SOLID Bounding Box + Label (UIView)
    private func drawBoundingBox(_ rect: CGRect, label: String) {
        
        // ✅ BOX VIEW (100% SOLID BORDER)
        let boxView = UIView(frame: rect)
        boxView.layer.borderColor = UIColor.systemYellow.cgColor
        boxView.layer.borderWidth = 3
        boxView.layer.cornerRadius = 6
        boxView.backgroundColor = .clear
        boxView.alpha = 1.0
        
        // ✅ LABEL VIEW (100% SOLID)
        let labelView = UILabel()
        labelView.text = label
        labelView.font = .systemFont(ofSize: 13, weight: .semibold)
        labelView.textColor = .black
        labelView.backgroundColor = .systemYellow   // ✅ FULL SOLID
        labelView.textAlignment = .center
        labelView.sizeToFit()
        
        labelView.frame.size.width += 12
        labelView.frame.size.height = 20
        labelView.layer.cornerRadius = 4
        labelView.clipsToBounds = true
        
        // ✅ POSISI DI ATAS BOUNDING BOX
        labelView.frame.origin = CGPoint(x: 0, y: -22)
        
        boxView.addSubview(labelView)
        boxContainerView.addSubview(boxView)
    }
}

// MARK: - Frame Processing
extension ViewController {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: .up,
                                            options: [:])
        
        try? handler.perform([detectionRequest])
    }
}

// MARK: - Vision Handler
extension ViewController {
    
    private func handleDetection(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            print("⚠️ No results")
            return
        }
        
        DispatchQueue.main.async {
            
            // ✅ Hapus box lama (tanpa flicker)
            self.boxContainerView.subviews.forEach { $0.removeFromSuperview() }
            
            if results.isEmpty {
                print("⚠️ Model detected 0 objects")
            }
            
            for object in results {
                guard let label = object.labels.first else { continue }
                
                // ✅ Anti flicker confidence threshold
                let dynamicThreshold: Float = object.boundingBox.width < 0.15 ? 0.10 : 0.20
                if label.confidence < dynamicThreshold { continue }

                
                let rect = self.convertRect(object.boundingBox)
                let text = "\(label.identifier) \(Int(label.confidence * 100))%"
                
                self.drawBoundingBox(rect, label: text)
            }
        }
    }
}
