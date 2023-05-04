//
//  Task.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import Foundation

class Task {
    var name: String
    var date: Date
    var time: Date?
    var reminder: Bool
    var isComplete: Bool
    
    init(name: String, date: Date, time: Date? = nil, reminder: Bool, isComplete: Bool) {
        self.name = name
        self.date = date
        self.time = time
        self.reminder = reminder
        self.isComplete = isComplete
    }
    
    func complete() {
        isComplete = !isComplete
    }
}
