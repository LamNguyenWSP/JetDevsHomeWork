//
//  AuthService.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import Foundation
import Moya

enum AuthService {
    case login(email: String, password: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: "https://jetdevs.wiremockapi.cloud")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data() // You can provide sample data for testing if needed
    }
}

