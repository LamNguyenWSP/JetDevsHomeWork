//
//  UIViewController+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromXib(nibName: String) -> Self {
        let viewController = Self(nibName: nibName, bundle: nil)
        return viewController
    }
}
