//
//  TickerViewController.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class TickerViewController: BaseViewController {
    private let tableView = UITableView()
    private let viewModel = TickerViewModel()
    private var disposeBag = DisposeBag()
    private let headerView = TickerHeaderView()

    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(headerView)
    }

    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        headerView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }

    override func configureView() {
        tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: TickerTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
    }

    override func configureNavigation() {
        let titleLabel = UILabel()
        titleLabel.text = "거래소"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getDataByTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.disposeTimer()
    }

    override func bind() {
        let input = TickerViewModel.Input(
            priceTapped: headerView.priceButton.rx.tapGesture(),
            changedPriceTapped: headerView.changedPriceButton.rx.tapGesture(),
            accTapped: headerView.accButton.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)

        output.data
            .bind(to:tableView.rx.items(
                cellIdentifier: TickerTableViewCell.identifier,
                cellType: TickerTableViewCell.self)) { index, element, cell in
                    cell.name.text = element.market
                    cell.price.text = element.trade_price_description
                    cell.changeRate.text = element.signed_change_rate_description
                    cell.changePrice.text = element.signed_change_price_description
                    cell.tradePrice.text = element.acc_trade_price_24h_description
                    cell.updateColor(number: element.signed_change_rate)
                }
                .disposed(by: disposeBag)

        output.buttonStatus
            .subscribe(with: self) { owner, status in
                owner.headerView.priceButton.buttonStatus(status: status.price)
                owner.headerView.changedPriceButton.buttonStatus(status: status.changedPrice)
                owner.headerView.accButton.buttonStatus(status: status.acc)
            }
            .disposed(by: disposeBag)

        output.error
            .bind(with: self) { owner, error in
                owner.viewModel.disposeTimer()
                let vc = AlertViewController()
                vc.alertView.messageLabel.text = error.description
                vc.delegate = owner
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - delegate
extension TickerViewController: AlertViewDismissDelegate {
    func alertViewDismiss() {
        viewModel.getDataByTimer()
    }
}
