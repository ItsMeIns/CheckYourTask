//
//  AddTaskViewController.swift
//  CheckYourTask
//
//  Created by macbook on 28.05.2023.
//

import UIKit


protocol addTaskDelegate:AnyObject {
    func createTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
    weak var delegate: addTaskDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        
        setupConstraints()
        
        
    }
    
    
    //MARK: - name text field -
    let taskNameTextField: UITextField = {
        let taskName = UITextField()
        taskName.backgroundColor = .white
        taskName.placeholder = "Task name"
        taskName.layer.cornerRadius = 5
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        taskName.leftView = leftView
        taskName.leftViewMode = .always
        taskName.translatesAutoresizingMaskIntoConstraints = false
        return taskName
    }()
    
    //MARK: - date label -
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - date picker -
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    //MARK: - time label -
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - time picker -
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()
    
    //MARK: - description text view -
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - alert label -
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Alert"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - alert switch -
    let alertSwitch: UISwitch = {
        let alertSwitch = UISwitch()
        alertSwitch.isOn = false
        alertSwitch.translatesAutoresizingMaskIntoConstraints = false
        return alertSwitch
    }()
    
    
    //MARK: - cancel button -
    let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.backgroundColor = UIColor(named: "ColorCancel")
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
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
    
    //MARK: - create button -
    let createButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.layer.cornerRadius = 15
        createButton.clipsToBounds = true
        createButton.layer.borderWidth = 2
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.backgroundColor = UIColor(named: "ColorCreate")
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return createButton
    }()
    
    @objc func createButtonPressed() {
       
        guard let name = taskNameTextField.text,
                  let description = descriptionTextView.text else {
                return
            }
        let date = datePicker.date
        let time = timePicker.date
        let alertEnabled = alertSwitch.isOn
        
        
        let newTask = Task(name: name, description: description, date: date, time: time, reminder: alertEnabled, isComplete: false)
        delegate?.createTask(newTask)
        
        dismiss(animated: true, completion: nil)
        
       
    }
    
    func setupConstraints() {
        //name textfield
        view.addSubview(taskNameTextField)
        taskNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        taskNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80
        ).isActive = true
        taskNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        taskNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        //date label
        view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 25).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //date picker
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 20).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //time label
        view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //time picker
        view.addSubview(timePicker)
        timePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //description text view
        view.addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
        
        //alert label
        view.addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 25).isActive = true
        alertLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        //alert picker
        view.addSubview(alertSwitch)
        alertSwitch.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        alertSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        //cancel button
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        
        //create button
        view.addSubview(createButton)
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
    }
}

