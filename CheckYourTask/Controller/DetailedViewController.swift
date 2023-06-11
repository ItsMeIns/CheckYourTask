//
//  DetailedViewController.swift
//  CheckYourTask
//
//  Created by macbook on 09.06.2023.
//

import UIKit


class DetailedViewController: UIViewController {
    //MARK: - properties -
    var task: DataTask?
    
    
    
    
    
    
    
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        
        
        
        setupConstraints()
        updateUI()
        
        
       
    }
    
    
   
    
    
        
    // - task name -
    let taskName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    //MARK: - constraint -
    func setupConstraints() {
        
        //date label
        view.addSubview(taskName)
        taskName.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        taskName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        taskName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        
        
        
        
        //cancel button
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
    }
    
    func updateUI() {
        taskName.text = task?.taskName
    }
}

