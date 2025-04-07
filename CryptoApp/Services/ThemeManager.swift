//
//  ThemeManager.swift
//  CryptoApp
//
//  Created by Rynat Shakirov on 04.04.2025.
//

import Foundation
import UIKit

class ThemeManager {
    
    static let shared = ThemeManager();private init() {}
    
    enum Theme: String {
        case dark,light
        
        var userInterfaceStyle:UIUserInterfaceStyle {
            switch self {
            case .dark: return .dark
            case .light: return .light
            }
        }
    }
    
    private let selectedThemeKey = "selectedAppTheme"
    
    var currentTheme:Theme {
        get {
            if let storedTheme = UserDefaults.standard.string(forKey: selectedThemeKey),let theme = Theme(rawValue: storedTheme) {
                return theme
            }
            return .dark
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedThemeKey)
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
    func setupInitialTheme() {
        applyTheme(currentTheme)
    }
}
