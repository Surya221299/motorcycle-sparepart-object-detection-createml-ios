//
//  DetectionResult.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import Foundation
import CoreGraphics

struct DetectionResult {
    let normalizedRect: CGRect     // rect dari Vision (0...1)
    let label: String
    let confidence: Float
}
