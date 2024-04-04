//
//  Date+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 05/04/2024.
//

import Foundation

extension Date {
    
    var daysSince: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: Date())
        return (components.day ?? 0)
    }
}
