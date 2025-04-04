//
//  CircleImagView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit

final class CircleImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        contentMode = .scaleAspectFit
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

}
