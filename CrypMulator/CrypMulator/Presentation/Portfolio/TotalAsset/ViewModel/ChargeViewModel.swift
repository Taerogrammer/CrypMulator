//
//  ChargeViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import RxCocoa
import RxSwift

final class ChargeViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    enum Action {
        case dismiss
    }

    struct Input {
        let chargeTapped: Signal<Void>
        let amountSelected: Signal<Int>
    }

    struct Output {
        let amountText: Driver<String>
        let action: Signal<Action>
    }

    private let selectedAmount = BehaviorRelay<Int>(value: 0)
    private let actionRelay = PublishRelay<Action>()

    func transform(input: Input) -> Output {

        input.amountSelected
            .emit(with: self) { owner, amount in
                let newAmount = owner.selectedAmount.value + amount
                owner.selectedAmount.accept(newAmount)
            }
            .disposed(by: disposeBag)

        input.chargeTapped
            .emit(with: self) { owner, _ in
                owner.actionRelay.accept(.dismiss)
            }
            .disposed(by: disposeBag)

        let amountText = selectedAmount
            .map { FormatUtility.formatAmount($0) }
            .debug()
            .asDriver(onErrorJustReturn: "0")

        return Output(
            amountText: amountText,
            action: actionRelay.asSignal()
        )
    }

}
