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
        view.backgroundColor = UIColor(named: "Color1")
        
        
        taskView.taskViewController = self
        
        callSettings()
        callAddTask()
        taskView.setupConstraints()
        tableViewSettings()
        addCalendar()
        calendarConstraints()
        
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
        
        let alertController = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        //констрейнт висоти алерта
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 350)
        alertController.view.addConstraint(height)
        
        //Поле додавання тексту
        alertController.addTextField { textField in
            textField.placeholder = "Task name"
        }
        
        //лейбл дати
        let dateLabel = UILabel()
        dateLabel.text = "Date"
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        alertController.view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 115).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20).isActive = true

        //вибір дати
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        alertController.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 110).isActive = true
        datePicker.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -15).isActive = true
           
        //лейбл часу
        let timeLabel = UILabel()
        timeLabel.text = "Time"
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        alertController.view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 155).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20).isActive = true
        
        //вибір часу
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
        alertController.view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 150).isActive = true
        timePicker.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -15).isActive = true
        
        //лейбл нагадування
        let alertLabel = UILabel()
        alertLabel.text = "Alert"
        alertLabel.font = UIFont.systemFont(ofSize: 20)
        alertController.view.addSubview(alertLabel)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 195).isActive = true
        alertLabel.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 20).isActive = true
        
        //перемикач нагадування
        let alertSwitch = UISwitch()
        alertController.view.addSubview(alertSwitch)
        alertSwitch.translatesAutoresizingMaskIntoConstraints = false
        alertSwitch.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 190).isActive = true
        alertSwitch.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -15).isActive = true
        

        //кнопка ок що буде зберігати всю логіку
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let taskName = alertController.textFields?.first?.text, !taskName.isEmpty {
                let selectedDate = datePicker.date
                let selectedTime = timePicker.date
                let isReminderEnabled = alertSwitch.isOn
                
                let newTask = Task(name: taskName, date: selectedDate, time: selectedTime, reminder: isReminderEnabled, isComplete: false)
                self.tasks.append(newTask)
                self.taskDates.append(newTask.date)
                
                print("New task added: \(newTask.name)")
                print("Total tasks count: \(self.tasks.count)")
                
                let calendar = Calendar.current
                if calendar.isDate(selectedDate, inSameDayAs: selectedDate) {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                }
            }
        }
        //відмінити дію
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - FSCalendar properties -
    let calendar = FSCalendar()
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMMM-yyyy"
        return formatter
    }()
    
    //MARK: - add FSCalendar -
    
    func addCalendar() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - constraint calendar -
    var calendarHeightConstraint: NSLayoutConstraint!
    
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
    
    //MARK: - TableView properties -
    var tasks: [Task] = []
    var taskDates: [Date] = []
    var selectedDate: Date = Date()
    var tableView: UITableView!
    var tableViewTopConstraint: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tasksForSelectedDate = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        return tasksForSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        
        let tasksForSelectedDate = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        let task = tasksForSelectedDate[indexPath.row]
       
        cell.configure(with: task)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksForSelectedDate = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            let task = tasksForSelectedDate[indexPath.row]
        task.complete()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - tableViewSettings -
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
}

//MARK: - Calendar Delegate -
extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        selectedDate = date
        tableView.reloadData()
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



