//
//  UIColorEX.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 08.04.2025.
//

import Foundation
import UIKit

extension UIColor {
    // Static properties for easy access to themed colors
    static var appBackground: UIColor {
        return ThemeManager.shared.color(for: "PrimaryAppBackground")
    }
    
    static var appText: UIColor {
        return ThemeManager.shared.color(for: "Font Color")
    }
    
    static var primaryCellColor: UIColor {
        return ThemeManager.shared.color(for: "Cell Color")
    }
    
    static var appAccent: UIColor {
        return ThemeManager.shared.color(for: "accentColor")
    }
}
