//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 05/04/2024.
//

import Foundation
import RxSwift
import RxCocoa

class AccountViewModel {
    let userModel = BehaviorRelay<UserModel?>(value: nil)
    
    private let userService: UserService
    private let disposeBag = DisposeBag()
    
    init(userService: UserService) {
        self.userService = userService
        
        userService.observeCurrentUser()
            .bind(to: userModel)
            .disposed(by: disposeBag)
    }
}

extension AccountViewModel {
    
    static func initDependencies() -> AccountViewModel {
        let viewModel = AccountViewModel(userService: UserServiceImpl.shared)
        return viewModel
    }
}
