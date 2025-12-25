//
//  CameraViewController.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import UIKit
import AVFoundation
import ImageIO

final class CameraViewController: UIViewController {

    private let cameraManager = CameraManager()
    private let detector = VisionDetector()

    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let boxContainerView = UIView()

    // throttle sederhana biar Vision gak kebanyakan (optional tapi bagus)
    private var isProcessingFrame = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        cameraManager.delegate = self
        setupPreview()
        setupOverlay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.start()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        boxContainerView.frame = view.bounds
    }

    private func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    private func setupOverlay() {
        boxContainerView.frame = view.bounds
        boxContainerView.backgroundColor = .clear
        boxContainerView.isUserInteractionEnabled = false
        view.addSubview(boxContainerView)
    }

    private func showAlertPermission() {
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

    private func clearBoxes() {
        boxContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func convertRect(_ boundingBox: CGRect) -> CGRect {
        return previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
    }


    private func render(_ detections: [DetectionResult]) {
        clearBoxes()
        for d in detections {
            let rect = convertRect(d.normalizedRect)
            let text = "\(d.label) \(Int(d.confidence * 100))%"
            let box = BoundingBoxView(frame: rect, text: text)
            boxContainerView.addSubview(box)
        }
    }

    private func currentOrientation() -> CGImagePropertyOrientation {
        // Untuk back camera portrait biasanya .right
        // Kamu sebelumnya pakai .up; ini sering bikin box geser di beberapa device.
        // Jika hasilmu sudah pas dengan .up, bisa kembalikan.
        return .up
    }
}

extension CameraViewController: CameraManagerDelegate {

    func cameraManagerDidFailPermission(_ manager: CameraManager) {
        showAlertPermission()
    }

    func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CVPixelBuffer) {

        // Optional throttle: proses 1 frame dalam satu waktu
        if isProcessingFrame { return }
        isProcessingFrame = true

        detector.detect(pixelBuffer: pixelBuffer, orientation: currentOrientation()) { [weak self] detections in
            DispatchQueue.main.async {
                self?.render(detections)
                self?.isProcessingFrame = false
            }
        }
    }
}
