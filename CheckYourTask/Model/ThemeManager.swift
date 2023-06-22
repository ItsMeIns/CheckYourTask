//
//  ThemeManager.swift
//  CheckYourTask
//
//  Created by macbook on 20.06.2023.
//

import Foundation
import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    private init() {}

    var selectedTheme: ThemeData? {
        didSet {

            NotificationCenter.default.post(name: NSNotification.Name("ThemeChangedNotification"), object: nil)
        }
    }

    var defaultTheme: ThemeData? {
        didSet {
            if selectedTheme == nil {
                selectedTheme = defaultTheme
            }
        }
    }
    
    func saveSelectedThemeIndex(_ index: Int) {
            UserDefaults.standard.set(index, forKey: "SelectedThemeIndex")
        }
    
    }
