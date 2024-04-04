//
//  UserService.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 05/04/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserService {
    func updateUser(_ user: UserModel?)
    func observeCurrentUser() -> Observable<UserModel?>
    func getUser() -> UserModel?
}

class UserServiceImpl: UserService {
    static let shared = UserServiceImpl()
    
    private let userDefaults = UserDefaults.standard
    private let currentUserRelay = BehaviorRelay<UserModel?>(value: nil)
    
    init() {
        if let user = getUser() {
            currentUserRelay.accept(user)
        }
    }
    
    // MARK: -
    
    func updateUser(_ user: UserModel?) {
        if let user = user {
            saveUser(user)
        } else {
            removeUser()
        }
        currentUserRelay.accept(user)
    }
    
    func observeCurrentUser() -> Observable<UserModel?> {
        return currentUserRelay.asObservable()
    }
    
    func saveUser(_ user: UserModel) {
        do {
            let encodedData = try JSONEncoder().encode(user)
            userDefaults.set(encodedData, forKey: "com.jetdevs.JetDevsHomeWork.currentUser")
        } catch {
            print("Error encoding user: \(error)")
        }
    }
    
    func getUser() -> UserModel? {
        guard let encodedData = userDefaults.data(forKey: "com.jetdevs.JetDevsHomeWork.currentUser") else {
            return nil
        }
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: encodedData)
            return user
        } catch {
            print("Error decoding user: \(error)")
            return nil
        }
    }
    
    func removeUser() {
        userDefaults.removeObject(forKey: "com.jetdevs.JetDevsHomeWork.currentUser")
    }
}
