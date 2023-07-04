//
//  TaskView.swift
//  CheckYourTask
//
//  Created by macbook on 18.05.2023.
//

import UIKit
import FSCalendar

class TaskView {
    var taskViewController: TasksViewController!
    
    
    //MARK: - calendar сontentView -
    let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - avatar + settings -
    let avatarSettings: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.image = UIImage(named: "avatarImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.isUserInteractionEnabled = true //взаємодія як кнопка
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - add button + setting -
    let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        let image = UIImage(named: "plusImage")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    //MARK: - percentages made layer -
    let percentagesMadeLayer: UILabel = {
        let percentagesLabel = UILabel()
        percentagesLabel.font = UIFont.boldSystemFont(ofSize: 30)
        percentagesLabel.textAlignment = .center
        var done = "0"
        percentagesLabel.text = "\(done)%"
        percentagesLabel.translatesAutoresizingMaskIntoConstraints = false
        return percentagesLabel
    }()
    
    //MARK: - add progress view -
    let addProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        
        progressView.progress = 0.00
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    func setupConstraints() {
        //MARK: - add subview -
        taskViewController.view.addSubview(avatarSettings)
        taskViewController.view.addSubview(addTaskButton)
        taskViewController.view.addSubview(percentagesMadeLayer)
        taskViewController.view.addSubview(addProgressView)
        taskViewController.view.addSubview(contentView)
        
        //MARK: - calendar сontentView -
        contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.topAnchor.constraint(equalTo: taskViewController.view.topAnchor, constant: 180).isActive = true
        contentView.leftAnchor.constraint(equalTo: taskViewController.view.leftAnchor, constant: 10).isActive = true
        contentView.rightAnchor.constraint(equalTo: taskViewController.view.rightAnchor, constant: -10).isActive = true
        
        //MARK: - constraint add task button -
        addTaskButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addTaskButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addTaskButton.topAnchor.constraint(equalTo: taskViewController.view.topAnchor, constant: 65).isActive = true
        addTaskButton.rightAnchor.constraint(equalTo: taskViewController.view.rightAnchor, constant: -20).isActive = true
        
        //MARK: - constraint avatar + setting -
        avatarSettings.heightAnchor.constraint(equalToConstant: 60).isActive = true
        avatarSettings.widthAnchor.constraint(equalToConstant: 60).isActive = true
        avatarSettings.topAnchor.constraint(equalTo: taskViewController.view.topAnchor, constant: 65).isActive = true
        avatarSettings.leftAnchor.constraint(equalTo: taskViewController.view.leftAnchor, constant: 20).isActive = true
        
        //MARK: - constraint percentageLabel -
        percentagesMadeLayer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        percentagesMadeLayer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        percentagesMadeLayer.topAnchor.constraint(equalTo: taskViewController.view.topAnchor, constant: 65
        ).isActive = true
        percentagesMadeLayer.centerXAnchor.constraint(equalTo: taskViewController.view.centerXAnchor).isActive = true
        percentagesMadeLayer.leftAnchor.constraint(equalTo: avatarSettings.rightAnchor, constant: 20).isActive = true
        percentagesMadeLayer.rightAnchor.constraint(equalTo: addTaskButton.leftAnchor, constant: -20).isActive = true
        
        //MARK: - constraint progresView -
        addProgressView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addProgressView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addProgressView.topAnchor.constraint(equalTo: taskViewController.view.topAnchor, constant: 150).isActive = true
        addProgressView.leftAnchor.constraint(equalTo: taskViewController.view.leftAnchor, constant: 20).isActive = true
        addProgressView.rightAnchor.constraint(equalTo: taskViewController.view.rightAnchor, constant: -20).isActive = true
    }
}

