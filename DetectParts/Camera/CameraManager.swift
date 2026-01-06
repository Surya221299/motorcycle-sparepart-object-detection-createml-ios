//
//  CameraManager.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import AVFoundation

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didOutput pixelBuffer: CVPixelBuffer)
    func cameraManagerDidFailPermission(_ manager: CameraManager)
}

final class CameraManager: NSObject {

    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()

    weak var delegate: CameraManagerDelegate?

    private let queue = DispatchQueue(label: "camera_frame_queue")

    func start() {
        checkPermissionAndStart()
    }

    func stop() {
        session.stopRunning()
    }

    private func checkPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupAndRun()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.setupAndRun() : self.delegate?.cameraManagerDidFailPermission(self)
                }
            }
        default:
            delegate?.cameraManagerDidFailPermission(self)
        }
    }

    private func setupAndRun() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video,
                                                  position: .back) else {
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .high

        // Clear old inputs/outputs (optional safety)
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        // Input
        if let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
        }

        // Output
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        delegate?.cameraManager(self, didOutput: pixelBuffer)
    }
}
