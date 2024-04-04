//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class LoginViewModel {
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()
    let isLoginEnabled: Observable<Bool>
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String?>()
    let userModel = PublishRelay<UserModel?>()
    
    private let authRepository: AuthRepository
    private let userService: UserService
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepository, userService: UserService) {
        self.authRepository = authRepository
        self.userService = userService
        
        let emailValid = email.asObservable()
            .map { !$0.isEmpty && $0.isValidEmail() }
            .distinctUntilChanged()
        
        let passwordValid = password.asObservable()
            .map { !$0.isEmpty }
            .distinctUntilChanged()
        
        isLoginEnabled = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
        
        loginButtonTapped.subscribe(onNext: {
            self.login()
        }).disposed(by: disposeBag)
    }
    
    private func login() {
        isLoading.accept(true)
        authRepository.login(email: email.value, password: password.value)
            .subscribe { [weak self] event in
                self?.isLoading.accept(false)
                switch event {
                case .success(let result):
                    switch result {
                    case .success(let user):
                        self?.userService.updateUser(user)
                        self?.userModel.accept(user)
                    case .failure(let error):
                        switch error {
                        case .invalidCredentials:
                            self?.errorMessage.accept("Invalid credentials")
                        case .networkError(let message):
                            self?.errorMessage.accept(message)
                        }
                    }
                case .error(let error):
                    self?.errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    
    static func initDependencies() -> LoginViewModel {
        let provider = MoyaProvider<AuthService>()
        let authRepository = AuthRepositoryImpl(provider: provider)
        let viewModel = LoginViewModel(authRepository: authRepository, userService: UserServiceImpl.shared)
        return viewModel
    }
}
