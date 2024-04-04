//
//  AuthRepository.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

enum AuthError: Error {
    case invalidCredentials
    case networkError(String)
}

protocol AuthRepository {
    func login(email: String, password: String) -> Single<Result<UserModel, AuthError>>
}

class AuthRepositoryImpl: AuthRepository {
    private let provider: MoyaProvider<AuthService>
    
    init(provider: MoyaProvider<AuthService>) {
        self.provider = provider
    }
    
    func login(email: String, password: String) -> Single<Result<UserModel, AuthError>> {
        return Single.create { [weak self] single in
            let cancellable = self?.provider.request(.login(email: email, password: password)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        let json = JSON(response.data)
                        guard var userModel = UserModel(fromJSON: json) else {
                            single(.success(.failure(AuthError.networkError(json["error_message"].string ?? "Can't create UserModel"))))
                            return
                        }
                        if let headers = response.response?.allHeaderFields,
                           let xAcc = headers["X-Acc"] as? String {
                            userModel.xAcc = xAcc
                        }
                        single(.success(.success(userModel)))
                    } else {
                        single(.success(.failure(AuthError.invalidCredentials)))
                    }
                case .failure(let error):
                    single(.success(.failure(AuthError.networkError(error.localizedDescription))))
                }
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
}
