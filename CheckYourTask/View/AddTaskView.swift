//
//  AddTaskView.swift
//  CheckYourTask
//
//  Created by macbook on 14.06.2023.
//


import UIKit

class AddTaskView {
    var addTaskViewController: AddTaskViewController!
    
    // - name text field -
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
    
    // - date label -
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - date picker -
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    // - time label -
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - time picker -
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_GB")
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        return timePicker
    }()
    
    // - description text view -
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // - alert label -
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Alert"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - alert switch -
    let alertSwitch: UISwitch = {
        let alertSwitch = UISwitch()
        alertSwitch.isOn = false
        alertSwitch.translatesAutoresizingMaskIntoConstraints = false
        return alertSwitch
    }()
    
    // - cancel button -
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
        return cancelButton
    }()
    
    // - create button -
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
        return createButton
    }()
    
    //MARK: - constraint -
    func setupConstraints() {
        //name textfield
        addTaskViewController.view.addSubview(taskNameTextField)
        taskNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        taskNameTextField.topAnchor.constraint(equalTo: addTaskViewController.view.topAnchor, constant: 80
        ).isActive = true
        taskNameTextField.leftAnchor.constraint(equalTo: addTaskViewController.view.leftAnchor, constant: 20).isActive = true
        taskNameTextField.rightAnchor.constraint(equalTo: addTaskViewController.view.rightAnchor, constant: -20).isActive = true
        
        //date label
        addTaskViewController.view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 25).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        
        //date picker
        addTaskViewController.view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 20).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: addTaskViewController.view.trailingAnchor, constant: -20).isActive = true
        
        //time label
        addTaskViewController.view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        
        //time picker
        addTaskViewController.view.addSubview(timePicker)
        timePicker.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: addTaskViewController.view.trailingAnchor, constant: -20).isActive = true
        
        //description text view
        addTaskViewController.view.addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: addTaskViewController.view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: addTaskViewController.view.bottomAnchor, constant: -400).isActive = true
        
        //alert label
        addTaskViewController.view.addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 25).isActive = true
        alertLabel.leadingAnchor.constraint(equalTo: addTaskViewController.view.leadingAnchor, constant: 20).isActive = true
        
        //alert picker
        addTaskViewController.view.addSubview(alertSwitch)
        alertSwitch.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
        alertSwitch.trailingAnchor.constraint(equalTo: addTaskViewController.view.trailingAnchor, constant: -20).isActive = true
        
        //cancel button
        addTaskViewController.view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: addTaskViewController.view.bottomAnchor, constant: -50).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: addTaskViewController.view.leftAnchor, constant: 50).isActive = true
        
        //create button
        addTaskViewController.view.addSubview(createButton)
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        createButton.bottomAnchor.constraint(equalTo: addTaskViewController.view.bottomAnchor, constant: -50).isActive = true
        createButton.rightAnchor.constraint(equalTo: addTaskViewController.view.rightAnchor, constant: -50).isActive = true
    }
}
