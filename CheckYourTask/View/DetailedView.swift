//
//  DeteiledView.swift
//  CheckYourTask
//
//  Created by macbook on 15.06.2023.
//

import UIKit

class DetailedView {
    var detailedViewController: DetailedViewController!
    
    // task name view
    let viewTaskName: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - task name -
    let taskName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - task description  view -
    let viewTaskDescription: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - task description -
    let taskDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.isEditable = false
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    // - edit button -
    let editButton: UIButton = {
        let editButton = UIButton(type: .system)
        editButton.layer.cornerRadius = 15
        editButton.clipsToBounds = true
        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.backgroundColor = UIColor(named: "ColorCreate")
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        return editButton
    }()
    
    
    //MARK: - constraint -
    func setupConstraints() {
        //task name view
        detailedViewController.view.addSubview(viewTaskName)
        viewTaskName.leadingAnchor.constraint(equalTo: detailedViewController.view.leadingAnchor, constant: 16).isActive = true
        viewTaskName.trailingAnchor.constraint(equalTo: detailedViewController.view.trailingAnchor, constant: -16).isActive = true
        viewTaskName.topAnchor.constraint(equalTo: detailedViewController.view.topAnchor, constant:  100).isActive = true
        let heightConstraint = viewTaskName.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        let fittingHeight = viewTaskName.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        heightConstraint.constant = fittingHeight
        
        //task name
        viewTaskName.addSubview(taskName)
        taskName.leadingAnchor.constraint(equalTo: viewTaskName.leadingAnchor, constant: 8).isActive = true
        taskName.trailingAnchor.constraint(equalTo: viewTaskName.trailingAnchor, constant: -8).isActive = true
        taskName.topAnchor.constraint(equalTo: viewTaskName.topAnchor, constant: 16).isActive = true
        taskName.bottomAnchor.constraint(equalTo: viewTaskName.bottomAnchor, constant: -16).isActive = true
        
        //task description  view
        detailedViewController.view.addSubview(viewTaskDescription)
        viewTaskDescription.leadingAnchor.constraint(equalTo: detailedViewController.view.leadingAnchor, constant: 16).isActive = true
        viewTaskDescription.trailingAnchor.constraint(equalTo: detailedViewController.view.trailingAnchor, constant: -16).isActive = true
        viewTaskDescription.topAnchor.constraint(equalTo: viewTaskName.bottomAnchor, constant:  24).isActive = true
        viewTaskDescription.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        //task description
        viewTaskDescription.addSubview(taskDescription)
        taskDescription.topAnchor.constraint(equalTo: viewTaskDescription.topAnchor, constant: 8).isActive = true
        taskDescription.bottomAnchor.constraint(equalTo: viewTaskDescription.bottomAnchor, constant: -8).isActive = true
        taskDescription.leadingAnchor.constraint(equalTo: viewTaskDescription.leadingAnchor, constant: 8).isActive = true
        taskDescription.trailingAnchor.constraint(equalTo: viewTaskDescription.trailingAnchor, constant: -8).isActive = true
        
        //cancel button
        detailedViewController.view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: detailedViewController.view.bottomAnchor, constant: -50).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: detailedViewController.view.leftAnchor, constant: 50).isActive = true
        
        //edit button
        detailedViewController.view.addSubview(editButton)
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        editButton.bottomAnchor.constraint(equalTo: detailedViewController.view.bottomAnchor, constant: -50).isActive = true
        editButton.rightAnchor.constraint(equalTo: detailedViewController.view.rightAnchor, constant: -50).isActive = true
    }
    
}
