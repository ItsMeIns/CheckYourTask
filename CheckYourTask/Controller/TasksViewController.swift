//
//  TasksViewController.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import UIKit
import FSCalendar
import CoreData

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - properties -
    let taskView = TaskView()
    var selectedDate: Date = Date()
    var tableView: UITableView!
    var completedTasks: Int = 0
    var tableViewTopConstraint: NSLayoutConstraint!
    var calendarHeightConstraint: NSLayoutConstraint!
    
    
    // - FSCalendar properties -
    let calendar = FSCalendar()
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        return formatter
    }()
    
    //MARK: - content -
    
    var tasks: [DataTask] = []
    var taskDates: [Date] = []
    
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        
        taskView.taskViewController = self
        
        callSettings()
        callAddTask()
        taskView.setupConstraints()
        tableViewSettings()
        addCalendar()
        calendarConstraints()
        
    }
    
    //MARK: - intents -
    
    //- progress bar -
    func updateProgress() {
        if taskDates.count > 0 {
            let percentage = (completedTasks / taskDates.count) * 100
            taskView.percentagesMadeLayer.text = "\(percentage)%"
            taskView.addProgressView.setProgress(Float(completedTasks) / Float(taskDates.count), animated: true)
        } else {
            taskView.percentagesMadeLayer.text = "0%"
            taskView.addProgressView.setProgress(0, animated: true)
        }
    }
    
    // - avatar + settings -
    func callSettings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSettings))
        taskView.avatarSettings.addGestureRecognizer(tapGesture)
    }
    @objc func showSettings() {
        print("image button pressed")
    }
    
    // - add button + setting -
    func callAddTask() {
        taskView.addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
    }
    @objc func addTask() {
        print("add button pressed")
        
        let addTaskVC = AddTaskViewController()
        
        let navigationController = UINavigationController(rootViewController: addTaskVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    // - add FSCalendar -
    func addCalendar() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.scope = .week
        calendar.delegate = self
        calendar.dataSource = self
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest: NSFetchRequest<DataTask> = DataTask.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            
            
            self.tasks = tasks
            tableView.reloadData()
            calendar.reloadData()
        } catch {
            print("Помилка під час витягування задач з Core Data: \(error)")
        }
        
        
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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    // - constraint calendar -
    func calendarConstraints() {
        view.addSubview(calendar)
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        calendar.addConstraint(calendarHeightConstraint)
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 8)
        tableViewTopConstraint.isActive = true
    }
    
    // - tableViewSettings -
    func tableViewSettings() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - TableView Delegate, DataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasksForSelectedDate = tasks.filter { $0.date.map { Calendar.current.isDate($0, inSameDayAs: selectedDate) } ?? false }
        return tasksForSelectedDate.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        
        let tasksForSelectedDate = tasks.filter { $0.date.map { Calendar.current.isDate($0, inSameDayAs: selectedDate) } ?? false }
        
        if indexPath.row < tasksForSelectedDate.count {
            let task = tasksForSelectedDate[indexPath.row]
            cell.configure(with: task)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksForSelectedDate = tasks.filter {
            $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate)
        }
        
        if indexPath.row < tasksForSelectedDate.count {
            let task = tasksForSelectedDate[indexPath.row]
            task.isComplite = true
            completedTasks += 1
        }
        
        tableView.reloadData()
        updateProgress()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - Calendar Delegate, DataSource -
extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        selectedDate = date
        tableView.reloadData()
        updateProgress()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let matchingDates = taskDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }
        return matchingDates.count
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}



