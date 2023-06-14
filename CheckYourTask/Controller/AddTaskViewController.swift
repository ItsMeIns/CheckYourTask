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
        
        setupConstraints()
        updateUI()
        callSettings()
        
        
    }
    
    //MARK: - intents -
    private func callSettings() {
        //натискання кнопки назад
        addTaskView.cancelButton.addTarget(AddTaskViewController(), action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        //перемикач edit/create
        if isEditMode {
            title = "Edit Task"
            addTaskView.createButton.setTitle("Edit", for: .normal)
            addTaskView.createButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        } else {
            title = "Create Task"
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
        if let editedTask = task {
            editedTask.taskName = addTaskView.taskNameTextField.text
            editedTask.taskDescription = addTaskView.descriptionTextView.text
            editedTask.date = addTaskView.datePicker.date
            editedTask.time = addTaskView.timePicker.date
            editedTask.reminder = addTaskView.alertSwitch.isOn
            editedTask.isComplete = false
            
            do {
                try context.save()
                if let tasksViewController = presentingViewController as? TasksViewController {
                    tasksViewController.tableView.reloadData()
                    tasksViewController.calendar.reloadData()
                    tasksViewController.updateProgress()
                }
                dismiss(animated: true, completion: nil)
            } catch {
                print("Error saving task: \(error)")
            }
        }
        
        //notification
        let calendar = Calendar.current
        let selectedDate = addTaskView.datePicker.date
        let selectedTime = addTaskView.timePicker.date
        let notificationId = UUID().uuidString
        task?.notificationId = notificationId
        
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let title = "CheckYourTask"
                let message = self.addTaskView.taskNameTextField.text!
                if (settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                    dateComp.year = calendar.component(.year, from: selectedDate)
                    dateComp.month = calendar.component(.month, from: selectedDate)
                    dateComp.day = calendar.component(.day, from: selectedDate)
                    dateComp.hour = calendar.component(.hour, from: selectedTime)
                    dateComp.minute = calendar.component(.minute, from: selectedTime)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: selectedDate), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "Enable Notification?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if (UIApplication.shared.canOpenURL(settingsURL)) {
                            UIApplication.shared.open(settingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    //натискання кнопки створити
    @objc func createButtonPressed() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "DataTask", in: context) else {
            return
        }
        
        let task = DataTask(entity: entityDescription, insertInto: context)
        task.taskName = addTaskView.taskNameTextField.text
        task.taskDescription = addTaskView.descriptionTextView.text
        task.date = addTaskView.datePicker.date
        task.time = addTaskView.timePicker.date
        task.reminder = addTaskView.alertSwitch.isOn
        task.isComplete = false
        
        do {
            try context.save()
            if let tasksViewController = presentingViewController as? TasksViewController {
                tasksViewController.tasks.append(task)
                tasksViewController.taskDates.append(task)
                tasksViewController.tableView.reloadData()
                tasksViewController.calendar.reloadData()
                tasksViewController.updateProgress()
            }
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error saving task: \(error)")
        }
        
        //notification
        let calendar = Calendar.current
        let selectedDate = addTaskView.datePicker.date
        let selectedTime = addTaskView.timePicker.date
        let notificationId = UUID().uuidString
        task.notificationId = notificationId
        
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let title = "CheckYourTask"
                let message = self.addTaskView.taskNameTextField.text!
                if (settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                    dateComp.year = calendar.component(.year, from: selectedDate)
                    dateComp.month = calendar.component(.month, from: selectedDate)
                    dateComp.day = calendar.component(.day, from: selectedDate)
                    dateComp.hour = calendar.component(.hour, from: selectedTime)
                    dateComp.minute = calendar.component(.minute, from: selectedTime)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: selectedDate), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "Enable Notification?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if (UIApplication.shared.canOpenURL(settingsURL)) {
                            UIApplication.shared.open(settingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: addTaskView.timePicker.date)
    }
    
    //MARK: - constraint -
    func setupConstraints() {
        //name textfield
        view.addSubview(addTaskView.taskNameTextField)
        addTaskView.taskNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addTaskView.taskNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80
        ).isActive = true
        addTaskView.taskNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addTaskView.taskNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        //date label
        view.addSubview(addTaskView.dateLabel)
        addTaskView.dateLabel.topAnchor.constraint(equalTo: addTaskView.taskNameTextField.bottomAnchor, constant: 25).isActive = true
        addTaskView.dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //date picker
        view.addSubview(addTaskView.datePicker)
        addTaskView.datePicker.topAnchor.constraint(equalTo: addTaskView.taskNameTextField.bottomAnchor, constant: 20).isActive = true
        addTaskView.datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addTaskView.datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //time label
        view.addSubview(addTaskView.timeLabel)
        addTaskView.timeLabel.topAnchor.constraint(equalTo: addTaskView.dateLabel.bottomAnchor, constant: 25).isActive = true
        addTaskView.timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //time picker
        view.addSubview(addTaskView.timePicker)
        addTaskView.timePicker.topAnchor.constraint(equalTo: addTaskView.datePicker.bottomAnchor, constant: 8).isActive = true
        addTaskView.timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addTaskView.timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //description text view
        view.addSubview(addTaskView.descriptionTextView)
        addTaskView.descriptionTextView.topAnchor.constraint(equalTo: addTaskView.timePicker.bottomAnchor, constant: 20).isActive = true
        addTaskView.descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addTaskView.descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addTaskView.descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
        
        //alert label
        view.addSubview(addTaskView.alertLabel)
        addTaskView.alertLabel.topAnchor.constraint(equalTo: addTaskView.descriptionTextView.bottomAnchor, constant: 25).isActive = true
        addTaskView.alertLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //alert picker
        view.addSubview(addTaskView.alertSwitch)
        addTaskView.alertSwitch.topAnchor.constraint(equalTo: addTaskView.descriptionTextView.bottomAnchor, constant: 20).isActive = true
        addTaskView.alertSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //cancel button
        view.addSubview(addTaskView.cancelButton)
        addTaskView.cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addTaskView.cancelButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        addTaskView.cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addTaskView.cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        
        //create button
        view.addSubview(addTaskView.createButton)
        addTaskView.createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addTaskView.createButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        addTaskView.createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addTaskView.createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
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

