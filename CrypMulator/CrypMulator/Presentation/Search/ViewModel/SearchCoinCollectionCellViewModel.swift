//
//  SearchCoinCollectionCellViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/11/25.
//

import RealmSwift
import RxCocoa
import RxSwift

final class SearchCoinCollectionCellViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    var coinData: CoinSearchData
    private let realm = try! Realm()
    private let favoriteRepository = OldFavoriteCoinRepository()
    private var favoriteCoin = OldFavoriteCoin()

    enum SettingAction {
        case itemAdded
        case itemDeleted
    }

    struct Input {
        let favoriteButtonTapped: ControlEvent<Void>
    }

    struct Output {
        let favoriteButtonResult: PublishRelay<SettingAction>
    }

    init(coinData: CoinSearchData) {
        self.coinData = coinData
        favoriteCoin = OldFavoriteCoin(
            id: coinData.id,
            symbol: coinData.symbol,
            image: coinData.thumb)
    }

    func transform(input: Input) -> Output {
        let favoriteButtonResult = PublishRelay<SettingAction>()

        input.favoriteButtonTapped
            .bind(with: self) { owner, _ in
                if !owner.favoriteRepository.isItemInRealm(id: owner.favoriteCoin.id) {
                    owner.favoriteRepository.createItem(favoriteCoin: owner.favoriteCoin)
                    favoriteButtonResult.accept(.itemAdded)
                } else {
                    owner.favoriteRepository.deleteItem(favoriteCoin: owner.favoriteCoin)
                    favoriteButtonResult.accept(.itemDeleted)
                }
            }
            .disposed(by: disposeBag)

        return Output(
            favoriteButtonResult: favoriteButtonResult)
    }

}
