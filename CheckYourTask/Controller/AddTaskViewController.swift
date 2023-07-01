//
//  AddTaskViewController.swift
//  CheckYourTask
//
//  Created by macbook on 28.05.2023.
//

import UIKit
import CoreData
import UserNotifications



class AddTaskViewController: UIViewController, UITextFieldDelegate {
    //MARK: - properties -
    let addTaskView = AddTaskView()
    var tasksVC: TasksViewController!
    var selectedDate: Date?
    var task: DataTask?
    let notificationCenter = UNUserNotificationCenter.current()
    var isEditMode = false
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Color1")
        navigationItem.hidesBackButton = true
        addTaskView.addTaskViewController = self
        addTaskView.taskNameTextField.delegate = self
        addTaskView.setupConstraints()
        updateUI()
        callSettings()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: NSNotification.Name("ThemeChangedNotification"), object: nil)
        updateInterfaceWithTheme()
    }
    
    //MARK: - intents -
    @objc private func themeChanged() {
        updateInterfaceWithTheme()
    }
    
    private func updateInterfaceWithTheme() {
        guard let theme = ThemeManager.shared.selectedTheme else {
            return
        }
        view.backgroundColor = theme.color45
        addTaskView.cancelButton.backgroundColor = theme.color25
        addTaskView.createButton.backgroundColor = theme.color25
        
        addTaskView.conteinerView.backgroundColor = theme.color25
        
        if theme.title == "themeCocoa" || theme.title == "themePink" {
            addTaskView.dateLabel.textColor = .black
            addTaskView.timeLabel.textColor = .black
            addTaskView.alertLabel.textColor = .black
            addTaskView.cancelButton.setTitleColor(UIColor.black, for: .normal)
            addTaskView.createButton.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            addTaskView.dateLabel.textColor = .white
            addTaskView.timeLabel.textColor = .white
            addTaskView.alertLabel.textColor = .white
            addTaskView.cancelButton.setTitleColor(UIColor.white, for: .normal)
            addTaskView.createButton.setTitleColor(UIColor.white, for: .normal)
            
        }
        
    }
    
    private func callSettings() {
        //натискання кнопки назад
        addTaskView.cancelButton.addTarget(AddTaskViewController(), action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        //перемикач edit/create
        if isEditMode {
            addTaskView.createButton.setTitle("Edit", for: .normal)
            addTaskView.createButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        } else {
            addTaskView.createButton.setTitle("Create", for: .normal)
            addTaskView.createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
            
        }
        
        //нагадування
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if (!permissionGranted) {
                print("permission denied")
            }
        }
        
        //прибрати клавіатуру по тапу
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        //запам‘ятовує обрану дату, та обирає одразу її у datePicker
        if let selectedDate = selectedDate {
            addTaskView.datePicker.date = selectedDate
            UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
        }
    }
    
    //ховає клавіатуру
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //натискання кнопки назад
    @objc func cancelButtonTapped() {
        let backToTaskVC = TasksViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(backToTaskVC, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    //натискання кнопки редагувати
    @objc func editButtonPressed() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let editedTask = task,
           let taskName = addTaskView.taskNameTextField.text,
           let taskDescription = addTaskView.descriptionTextView.text {
            
            editedTask.taskName = taskName
            editedTask.taskDescription = taskDescription
            editedTask.date = addTaskView.datePicker.date
            editedTask.time = addTaskView.timePicker.date
            editedTask.reminder = addTaskView.alertSwitch.isOn
            editedTask.isComplete = false
            
            do {
                try context.save()
                
                if let tasksViewController = tasksVC {
                    tasksViewController.tableView.reloadData()
                    tasksViewController.calendar.reloadData()
                    tasksViewController.updateProgress()
                }
                
            } catch {
                print("Error saving task: \(error)")
            }
            
            if !addTaskView.alertSwitch.isOn {
                removeNotification(for: editedTask)
            } else {
                scheduleNotification(for: editedTask)
            }
            
            
            navigateToTasksViewController()
        }
    }
    
    //натискання кнопки створити
    
    @objc func createButtonPressed() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "DataTask", in: context),
              let taskName = addTaskView.taskNameTextField.text,
              let taskDescription = addTaskView.descriptionTextView.text else {
            return
        }
        
        let task = DataTask(entity: entityDescription, insertInto: context)
        task.taskName = taskName
        task.taskDescription = taskDescription
        task.date = addTaskView.datePicker.date
        task.time = addTaskView.timePicker.date
        task.reminder = addTaskView.alertSwitch.isOn
        task.isComplete = false
        
        do {
            try context.save()
            
            if let tasksViewController = tasksVC {
                tasksViewController.tasks.append(task)
                tasksViewController.taskDates.append(task)
                tasksViewController.tableView.reloadData()
                tasksViewController.calendar.reloadData()
                tasksViewController.updateProgress()
            }
            
        } catch {
            print("Error saving task: \(error)")
        }
        
        scheduleNotification(for: task)
        navigateToTasksViewController()
    }
    
    func scheduleNotification(for task: DataTask) {
        let calendar = Calendar.current
        let selectedDate = addTaskView.datePicker.date
        let selectedTime = addTaskView.timePicker.date
        let notificationId = UUID().uuidString
        print("id!! (notificationId)")
        task.notificationId = notificationId
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            DispatchQueue.main.async {
                let title = "CheckYourTask"
                let message = self?.addTaskView.taskNameTextField.text ?? ""
                
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    var dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                    dateComp.year = calendar.component(.year, from: selectedDate)
                    dateComp.month = calendar.component(.month, from: selectedDate)
                    dateComp.day = calendar.component(.day, from: selectedDate)
                    dateComp.hour = calendar.component(.hour, from: selectedTime)
                    dateComp.minute = calendar.component(.minute, from: selectedTime)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                    
                    self?.notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func navigateToTasksViewController() {
        let backToTaskVC = TasksViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(backToTaskVC, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func removeNotification(for task: DataTask) {
        if let notificationId = task.notificationId {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: addTaskView.timePicker.date)
    }
    
    func updateUI() {
        guard let task = task else { return }
        addTaskView.taskNameTextField.text = task.taskName
        addTaskView.datePicker.date = task.date!
        addTaskView.timePicker.date = task.time!
        addTaskView.descriptionTextView.text = task.taskDescription
        addTaskView.alertSwitch.isOn = task.reminder
    }
}

