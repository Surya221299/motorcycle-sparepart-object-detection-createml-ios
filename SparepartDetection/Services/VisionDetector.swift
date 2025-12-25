//
//  VisionDetector.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import Vision
import CoreML
import AVFoundation

final class VisionDetector {

    private let vnModel: VNCoreMLModel

    init() {
        let config = MLModelConfiguration()
        config.computeUnits = .all

        guard let mlModel = try? SparepartDetectorLatest(configuration: config).model else {
            fatalError("⚠️ Failed to load SparepartDetectorLatest.mlmodel")
        }

        guard let vnModel = try? VNCoreMLModel(for: mlModel) else {
            fatalError("⚠️ Failed to create VNCoreMLModel")
        }

        self.vnModel = vnModel
    }

    func detect(pixelBuffer: CVPixelBuffer,
                orientation: CGImagePropertyOrientation,
                completion: @escaping ([DetectionResult]) -> Void) {

        // ✅ BUAT REQUEST BARU
        let request = VNCoreMLRequest(model: vnModel) { request, error in

            guard error == nil else {
                completion([])
                return
            }

            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                completion([])
                return
            }

            let mapped: [DetectionResult] = results.compactMap { obs in
                guard let top = obs.labels.first else { return nil }

                let dynamicThreshold: Float =
                    obs.boundingBox.width < 0.15 ? 0.10 : 0.20

                guard top.confidence >= dynamicThreshold else { return nil }

                return DetectionResult(
                    normalizedRect: obs.boundingBox,
                    label: top.identifier,
                    confidence: top.confidence
                )
            }

            completion(mapped)
        }

        request.imageCropAndScaleOption = .scaleFit

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: orientation,
            options: [:]
        )

        do {
            try handler.perform([request])
        } catch {
            completion([])
        }
    }
}


