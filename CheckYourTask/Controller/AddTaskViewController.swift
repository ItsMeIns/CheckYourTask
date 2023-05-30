//
//  AddTaskViewController.swift
//  CheckYourTask
//
//  Created by macbook on 28.05.2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
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
        return createButton
    }()
    
    
    func setupConstraints() {
        //name textfield
        view.addSubview(taskNameTextField)
        taskNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        taskNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80
        ).isActive = true
        taskNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        taskNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
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
    
