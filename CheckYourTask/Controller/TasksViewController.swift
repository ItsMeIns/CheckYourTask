//
//  TasksViewController.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import UIKit
import FSCalendar

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let taskView = TaskView()
    
   //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        taskView.taskViewController = self
        
        callSettings()
        callAddTask()
        
        taskView.setupConstraints()
        
        tableViewSettings()
        addCalendar()
        
    }
    
    
    //MARK: - avatar + settings -
    func callSettings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSettings))
        taskView.avatarSettings.addGestureRecognizer(tapGesture)
    }
    @objc func showSettings() {
        print("image button pressed")
    }
    
    //MARK: - add button + setting -
    func callAddTask() {
        taskView.addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    @objc func addTask() {
        print("add button pressed")
    }
    
    //MARK: - FSCalendar properties -
    var calendar: FSCalendar!
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        return formatter
    }()
    
    //MARK: - add FSCalendar -
    func addCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 165, width: view.frame.width, height: 400))
        calendar.scope = .week
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerDateFormat = "LLLL yyyy"
        calendar.appearance.weekdayTextColor = .darkGray
        calendar.appearance.todayColor = .systemBlue
        calendar.appearance.selectionColor = .black
        view.addSubview(calendar)
        
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeUpGesture.direction = .up
        calendar.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGesture.direction = .down
        calendar.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            if calendar.scope != .week {
                calendar.setScope(.week, animated: true)
            }
        } else if gesture.direction == .down {
            if calendar.scope != .month {
                calendar.setScope(.month, animated: true)
            }
        }
    }
    
    
    //MARK: - TableView properties -
    var tasks: [String] = ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5", "Task 6", "Task 7",]
    var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    //MARK: - tableVIewSettings -
    func tableViewSettings() {
        tableView = UITableView(frame: CGRect(x: 0, y: 480, width: view.frame.width, height: view.frame.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("did select date \(self.dateFormatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //
        return 1
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}



