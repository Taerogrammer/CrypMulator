//
//  DetailSegmentedControl.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import UIKit
import SnapKit

final class CustomSegmentedControl: BaseView {

    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    private let selectorView = UIView()
    private var selectorLeadingConstraint: NSLayoutConstraint?

    var items: [String] = [] {
        didSet {
            configureButtons()
            setupSelectorConstraints()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            updateSelectorPosition(animated: true)
            updateButtonAppearance()
        }
    }

    var selectionChanged: ((Int) -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelectorPosition(animated: false)
    }

    override func configureHierarchy() {
        addSubviews([stackView, selectorView])
    }

    override func configureLayout() {

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        selectorView.backgroundColor = SystemColor.black
        selectorView.layer.cornerRadius = 2
        clipsToBounds = true
    }

    private func configureButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, title) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(SystemColor.gray, for: .normal)
            button.titleLabel?.font = SystemFont.Body.boldPrimary
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        updateButtonAppearance()
    }

    private func setupSelectorConstraints() {
        guard items.count > 0 else { return }

        selectorView.snp.removeConstraints()
        selectorLeadingConstraint = selectorView.leadingAnchor.constraint(equalTo: leadingAnchor)

        selectorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalToSuperview().multipliedBy(1.0 / CGFloat(items.count))
        }

        selectorLeadingConstraint?.isActive = true
    }

    private func updateSelectorPosition(animated: Bool) {
        guard items.count > 0 else { return }

        let buttonWidth = frame.width / CGFloat(items.count)
        selectorLeadingConstraint?.constant = buttonWidth * CGFloat(selectedIndex)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }

        selectionChanged?(selectedIndex)
    }

    private func updateButtonAppearance() {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(index == selectedIndex ? .black : .gray, for: .normal)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
}
