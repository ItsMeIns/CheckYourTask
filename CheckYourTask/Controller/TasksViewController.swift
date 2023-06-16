//
//  TasksViewController.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import UIKit
import FSCalendar
import CoreData
import UserNotifications


class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    //MARK: - properties -
    let taskView = TaskView()
    var selectedDate = Date()
    var tableView: UITableView!
    var completedTasks: Int = 0
    var tableViewTopConstraint: NSLayoutConstraint!
    var calendarHeightConstraint: NSLayoutConstraint!
    var calendarBackgroundViewHeightConstraint: NSLayoutConstraint!
    var calendarScope: FSCalendarScope = .month
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    var taskDates: [DataTask] = []
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        taskView.taskViewController = self
        notificationCenter.delegate = self
        callSettings()
        callAddTask()
        taskView.setupConstraints()
        tableViewSettings()
        addCalendar()
        calendarConstraints()
        fetchTaskDatesFromCoreData()
        updateProgress()
        updateTasksForSelectedDate()
        saveSelectedDateUD()
        
        
        
        //кудись сховати
        if let calendarBackgroundViewHeight = UserDefaults.standard.value(forKey: "calendarBackgroundViewHeight") as? CGFloat {
                calendarBackgroundViewHeightConstraint.constant = calendarBackgroundViewHeight
            }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedDate = UserDefaults.standard.object(forKey: "selectedDate") as? Date {
            calendar.select(selectedDate)
        }
    }
    
    //MARK: - intents -
    
    //save the current date
    func saveSelectedDateUD() {
        selectedDate = Date()
        calendar.select(selectedDate)
        if let savedDate = UserDefaults.standard.object(forKey: "selectedDate") as? Date {
            if calendar.selectedDate != savedDate {
                calendar(calendar, didSelect: savedDate, at: .current)
            }
        }
    }
    
    //- fetch data -
    private func fetchTaskDatesFromCoreData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<DataTask> = DataTask.fetchRequest()
            do {
                taskDates = try context.fetch(fetchRequest)
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    //delete task
    func deleteTask(at indexPath: IndexPath) {
        let tasksForSelectedDate = tasks.filter { $0.date.map { Calendar.current.isDate($0, inSameDayAs: selectedDate) } ?? false }
        if indexPath.row < tasksForSelectedDate.count {
            let task = tasksForSelectedDate[indexPath.row]
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(task)
                if let notificationId = task.notificationId {
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
                }
                appDelegate.saveContext()
            }
            fetchTaskDatesFromCoreData()
            updateTasksForSelectedDate()
            tableView.reloadData()
            calendar.reloadData()
            updateProgress()
        }
    }
    
    //- progress bar -
    func updateProgress() {
        let tasksForSelectedDate = tasks.filter {
            $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate)
        }
        completedTasks = tasksForSelectedDate.filter { $0.isComplete }.count
        if tasksForSelectedDate.count > 0 {
            let percentage = Int((Float(completedTasks) / Float(tasksForSelectedDate.count)) * 100)
            taskView.percentagesMadeLayer.text = "\(percentage)%"
            taskView.addProgressView.setProgress(Float(completedTasks) / Float(tasksForSelectedDate.count), animated: true)
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
        addTaskVC.selectedDate = calendar.selectedDate
        let navigationController = UINavigationController(rootViewController: addTaskVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    // - add FSCalendar -
    func addCalendar() {
        taskView.contentView.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.firstWeekday = 2
        calendar.appearance.headerDateFormat = "LLLL yyyy"
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 15)
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.todayColor = .darkGray
        calendar.appearance.selectionColor = .black
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.scope = calendarScope
        
        
        if let savedScopeValue = UserDefaults.standard.value(forKey: "calendarScope") as? Int,
           let savedScope = FSCalendarScope(rawValue: UInt(savedScopeValue)) {
            calendar.scope = savedScope
        } else {
            calendar.scope = .month
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<DataTask> = DataTask.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            self.tasks = tasks
            
        } catch {
            print("Помилка під час витягування задач з Core Data: \(error)")
        }
        
        updateTasksForSelectedDate()
        tableView.reloadData()
        calendar.reloadData()
        
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
                calendarBackgroundViewHeightConstraint.constant = 130
                UserDefaults.standard.set(calendar.scope.rawValue, forKey: "calendarScope")
                UserDefaults.standard.set(calendarBackgroundViewHeightConstraint.constant, forKey: "calendarBackgroundViewHeight")
                
            }
        } else if gesture.direction == .down {
            if calendar.scope != .month {
                calendar.setScope(.month, animated: true)
                calendarBackgroundViewHeightConstraint.constant = 300
                UserDefaults.standard.set(calendar.scope.rawValue, forKey: "calendarScope")
                UserDefaults.standard.set(calendarBackgroundViewHeightConstraint.constant, forKey: "calendarBackgroundViewHeight")
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
        calendarBackgroundViewHeightConstraint = taskView.contentView.heightAnchor.constraint(equalToConstant: 300)
        calendarBackgroundViewHeightConstraint.isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calendar.topAnchor.constraint(equalTo: taskView.contentView.topAnchor, constant: 5).isActive = true
        calendar.leftAnchor.constraint(equalTo: taskView.contentView.leftAnchor, constant: 5).isActive = true
        calendar.rightAnchor.constraint(equalTo: taskView.contentView.rightAnchor, constant: -5).isActive = true
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: taskView.contentView.bottomAnchor, constant: 5)
        tableViewTopConstraint.isActive = true
    }
    
    // - tableViewSettings -
    func tableViewSettings() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "Color1")
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
        cell.tasksViewController = self
        
       
        
        let tasksForSelectedDate = tasks.filter { $0.date.map { Calendar.current.isDate($0, inSameDayAs: selectedDate) } ?? false }
        if indexPath.row < tasksForSelectedDate.count {
            let task = tasksForSelectedDate[indexPath.row]
            cell.configure(with: task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Видалити") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            
            self.deleteTask(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksForSelectedDate = tasks.filter {
            $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate)
        }
        
        if indexPath.row < tasksForSelectedDate.count {
            let task = tasksForSelectedDate[indexPath.row]
            let detailVC = DetailedViewController()
            detailVC.task = task
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            present(navigationController, animated: true, completion: nil)
            print("натиснуто \(String(describing: task.taskName))")
        }
        tableView.reloadData()
        updateProgress()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    

}

//MARK: - Calendar Delegate, DataSource -
extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        selectedDate = date
        UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
        updateTasksForSelectedDate()
        tableView.reloadData()
        updateProgress()
    }
    
    func updateTasksForSelectedDate() {
        tasks = taskDates.filter { task in
            guard let taskDate = task.date else {
                return false
            }
            return Calendar.current.isDate(taskDate, inSameDayAs: selectedDate)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let matchingDates = taskDates.filter { task in
            guard let taskDate = task.date else {
                return false
            }
            return Calendar.current.isDate(taskDate, inSameDayAs: date)
        }
        return matchingDates.count
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let calendar = Calendar.current
            let currentDate = calendar.date(byAdding: .year, value: 50, to: Date())
            let maximumDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate!)!
            return maximumDate
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}



