//
//  DetectionResult.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import Foundation
import CoreGraphics

struct DetectionResult {
    let normalizedRect: CGRect
    let label: String
    let confidence: Float
}
