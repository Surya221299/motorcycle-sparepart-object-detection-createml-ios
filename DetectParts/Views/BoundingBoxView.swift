//
//  BoundingBoxView.swift
//  SparepartDetection
//
//  Created by Surya on 25/12/25.
//

import UIKit

final class BoundingBoxView: UIView {

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear

        layer.borderColor = UIColor.systemGreen.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 6
        layer.masksToBounds = false

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        label.backgroundColor = .systemGreen
        label.textAlignment = .center
        label.sizeToFit()

        label.frame.size.width += 12
        label.frame.size.height = 20
        label.layer.cornerRadius = 4
        label.clipsToBounds = true

        label.frame.origin = CGPoint(x: 0, y: -22)
        addSubview(label)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
