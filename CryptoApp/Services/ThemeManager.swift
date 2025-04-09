//
//  ThemeManager.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 04.04.2025.
//

import Foundation
import UIKit

enum Theme: String {
    case dark,light
    
    var userInterfaceStyle:UIUserInterfaceStyle {
        switch self {
        case .dark: return .dark
        case .light: return .light
        }
    }
}

class ThemeManager {
    
    static let shared = ThemeManager();private init() {}
    
    private let selectedThemeKey = "selectedAppTheme"
    
    var onThemeChanged: (() -> Void)?
    
    var currentTheme:Theme {
        get {
            if let storedTheme = UserDefaults.standard.string(forKey: selectedThemeKey),let theme = Theme(rawValue: storedTheme) {
                return theme
            }
            return .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: selectedThemeKey)
            onThemeChanged?()
            applyTheme(newValue)
        }
    }
    
    func applyTheme(_ theme: Theme) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.overrideUserInterfaceStyle = theme.userInterfaceStyle
                }
            }
        }
    }
    
    func color(for colorName:String) -> UIColor {
        return UIColor { [weak self] _ in
            let currentStyle = self?.currentTheme.userInterfaceStyle ?? .dark
            
            let traitCollection = UITraitCollection(userInterfaceStyle: currentStyle)
            
            return UIColor(named: colorName,in: nil,compatibleWith: traitCollection) ?? .black
        }
    }
    
    func toggleTheme() {
        currentTheme = (currentTheme == .light) ? .dark : .light
    }
    
    func setupInitialTheme() {
        applyTheme(currentTheme)
    }
}
