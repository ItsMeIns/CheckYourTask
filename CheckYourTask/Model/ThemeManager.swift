//
//  ThemeManager.swift
//  CheckYourTask
//
//  Created by macbook on 20.06.2023.
//

import Foundation

class ThemeManager {
    static let shared = ThemeManager()
    private init() {}
    
    var selectedTheme: ThemeData? {
        didSet {
            
            NotificationCenter.default.post(name: NSNotification.Name("ThemeChangedNotification"), object: nil)
        }
    }
}
