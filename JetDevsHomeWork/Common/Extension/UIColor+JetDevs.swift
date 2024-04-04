//
//  UIColor+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Lâm Nguyễn on 04/04/2024.
//

import UIKit

extension UIColor {
    
    // MARK: - Initialize
    
    convenience init(hex: String) {
        let red, green, blue, alpha: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 || hexColor.count == 8 {
                let scanner = Scanner(string: "0x" + hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    red = (hexColor.count == 8) ? (CGFloat((hexNumber & 0xFF000000) >> 24) / 0xFF)
                    : (CGFloat((hexNumber & 0xFF0000) >> 16) / 0xFF)
                    green = (hexColor.count == 8) ? (CGFloat((hexNumber & 0x00FF0000) >> 16) / 0xFF)
                    : (CGFloat((hexNumber & 0x00FF00) >> 8) / 0xFF)
                    blue = (hexColor.count == 8) ? (CGFloat((hexNumber & 0x0000FF00) >> 8) / 0xFF)
                    : (CGFloat(hexNumber & 0x0000FF) / 0xFF)
                    alpha = (hexColor.count == 8) ? CGFloat(hexNumber & 0x000000FF) / 0xFF : CGFloat(1.0)
                    
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        
        self.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.0)
    }
    
    // MARK: - Instance methods
    
    func modified(percentage percent: CGFloat) -> UIColor? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        // Returns the color comprised by percentage r g b values of the original color.
        let color = UIColor(displayP3Red: min(red + percent / 100.0, 1.0), green: min(green + percent / 100.0, 1.0), blue: min(blue + percent / 100.0, 1.0), alpha: 1.0)
        
        return color
    }
    
    // MARK: - Class methods
    
    static var main: UIColor {
        get {
            return UIColor(hex: "#28518D")
        }
    }
    
    static var disabled: UIColor {
        get {
            return UIColor(hex: "#BDBDBD")
        }
    }
    
    static var text: UIColor {
        get {
            return UIColor(hex: "#333333")
        }
    }
    
    // MARK: - Color with alpha
    
    static func color(_ color: UIColor, alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
}

