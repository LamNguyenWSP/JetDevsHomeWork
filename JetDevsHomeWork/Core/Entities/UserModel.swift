//
//  UserModel.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import Foundation
import SwiftyJSON

struct UserModel: Codable {
    let id: Int
    let name: String
    let profileURL: URL
    let createdAt: Date
    var xAcc: String? = nil
    
    // DateFormatter for parsing ISO8601 date string
    private let iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "user_name"
        case profileURL = "user_profile_url"
        case createdAt = "created_at"
        case xAcc = "x_acc"
    }
    
    init?(fromJSON json: JSON) {
        guard let data = json["data"].dictionary,
              let userData = data["user"]?.dictionary,
              let userId = userData["user_id"]?.int,
              let userName = userData["user_name"]?.string,
              let userProfileURLString = userData["user_profile_url"]?.string,
              let userProfileURL = URL(string: userProfileURLString),
              let createdAtString = userData["created_at"]?.string,
              let createdAt = iso8601DateFormatter.date(from: createdAtString) else {
            return nil
        }
        self.id = userId
        self.name = userName
        self.profileURL = userProfileURL
        self.createdAt = createdAt
    }
}
