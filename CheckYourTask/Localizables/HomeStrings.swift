//
//  HomeStrings.swift
//  CheckYourTask
//
//  Created by macbook on 02.07.2023.
//

import Foundation

enum HomeStrings: String {
    
    //AddTaskView
    case taskNameTextField
    case dateLabel
    case timeLabel
    case alertLabel
    case createButton
    //DetailedView
    case editButton
    case cancelButton
    //SettingsView
    case chooseThemeLabel
    case saveButton
    
    var translation: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
