//
//  TotalAssetView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import SnapKit

final class CurrentAssetView: BaseView {

    /// Title Section
    private let titleLabel = UILabel()
    private let totalAssetTitleLabel = UILabel()
    private let totalAssetAmountLabel = UILabel()
    let chargeButton = ActionButton(
        title: StringLiteral.Button.charge,
        titleColor: SystemColor.blue,
        backgroundColor: SystemColor.whiteBlue,
        font: SystemFont.Button.secondary
    )

    /// Asset Stack
    private let assetStackView = UIStackView()

    /// Real Asset Section (Left)
    private let realAssetStackView = UIStackView()
    private let realCurrencyLabel = UILabel()
    private let realCurrencyAmountLabel = UILabel()

    /// Coin Asset Section (Right)
    private let coinAssetStackView = UIStackView()
    private let coinCurrencyLabel = UILabel()
    private let coinCurrencyAmountLabel = UILabel()

    private let coinProfitStackView = UIStackView()
    private let coinProfitLabel = UILabel()
    private let coinProfitAmountLabel = UILabel()

    private let coinProfitRatioStackView = UIStackView()
    private let coinProfitRatioLabel = UILabel()
    private let coinProfitRatioAmountLabel = UILabel()

    override func configureHierarchy() {
        addSubviews([
            titleLabel,
            totalAssetTitleLabel,
            totalAssetAmountLabel,
            chargeButton,
            assetStackView
        ])

        assetStackView.addArrangedSubviews([
            realAssetStackView,
            coinAssetStackView
        ])

        realAssetStackView.addArrangedSubviews([
            realCurrencyLabel,
            realCurrencyAmountLabel
        ])

        coinAssetStackView.addArrangedSubviews([
            coinCurrencyLabel,
            coinCurrencyAmountLabel,
            coinProfitStackView,
            coinProfitRatioStackView
        ])

        coinProfitStackView.addArrangedSubviews([
            coinProfitLabel,
            coinProfitAmountLabel
        ])

        coinProfitRatioStackView.addArrangedSubviews([
            coinProfitRatioLabel,
            coinProfitRatioAmountLabel
        ])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }

        totalAssetTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }

        totalAssetAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalAssetTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
        }

        chargeButton.snp.makeConstraints { make in
            make.centerY.equalTo(totalAssetAmountLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }

        assetStackView.snp.makeConstraints { make in
            make.top.equalTo(chargeButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        /// Title
        titleLabel.text = StringLiteral.Portfolio.assetOverview
        titleLabel.font = SystemFont.Title.large

        totalAssetTitleLabel.text = StringLiteral.Portfolio.totalAsset
        totalAssetTitleLabel.font = SystemFont.Title.small

        totalAssetAmountLabel.text = "38,185 " + StringLiteral.Currency.won
        totalAssetAmountLabel.font = SystemFont.Title.large

        /// StackView configs
        assetStackView.axis = .horizontal
        assetStackView.distribution = .fillEqually
        assetStackView.alignment = .top

        realAssetStackView.axis = .vertical
        realAssetStackView.spacing = 12
        realAssetStackView.alignment = .fill

        coinAssetStackView.axis = .vertical
        coinAssetStackView.spacing = 12
        coinAssetStackView.alignment = .fill

        coinProfitStackView.axis = .horizontal
        coinProfitStackView.spacing = 8
        coinProfitStackView.alignment = .center

        coinProfitRatioStackView.axis = .horizontal
        coinProfitRatioStackView.spacing = 8
        coinProfitRatioStackView.alignment = .center

        /// Real asset
        realCurrencyLabel.text = StringLiteral.Currency.krw
        realCurrencyLabel.font = SystemFont.Body.boldPrimary

        realCurrencyAmountLabel.text = "1,123,123 " + StringLiteral.Currency.krw
        realCurrencyAmountLabel.font = SystemFont.Title.small

        /// Coin asset
        coinCurrencyLabel.text = StringLiteral.Portfolio.coinAsset
        coinCurrencyLabel.font = SystemFont.Body.boldPrimary

        coinCurrencyAmountLabel.text = "1,123,123,123 " + StringLiteral.Currency.krw
        coinCurrencyAmountLabel.font = SystemFont.Title.small

        coinProfitLabel.text = StringLiteral.Portfolio.profitLoss
        coinProfitLabel.font = SystemFont.Body.boldContent
        coinProfitLabel.textColor = SystemColor.gray

        coinProfitAmountLabel.text = "+4,234,234 " + StringLiteral.Currency.krw
        coinProfitAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitAmountLabel.textColor = .red
        coinProfitAmountLabel.textAlignment = .right

        coinProfitRatioLabel.text = StringLiteral.Portfolio.yieldRate
        coinProfitRatioLabel.font = SystemFont.Body.boldContent
        coinProfitRatioLabel.textColor = SystemColor.gray

        coinProfitRatioAmountLabel.text = "+ 55%"
        coinProfitRatioAmountLabel.font = SystemFont.Body.boldPrimary
        coinProfitRatioAmountLabel.textColor = .red
        coinProfitRatioAmountLabel.textAlignment = .right
    }
}
