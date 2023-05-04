//
//  ViewController.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import UIKit

class TasksViewController: UIViewController {

    let todayLabel = UILabel()
    let percentagesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabelTop()
        avatarButton()
        addTaskButton()
        percentagesMadeLayer()
        
        updateTodayLabel()
        percentagesUpdateLayer()
    }
    
    //MARK: - date label settings -
    func dateLabelTop() {
        todayLabel.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: 50)
        todayLabel.font = UIFont.boldSystemFont(ofSize: 20)
        todayLabel.textAlignment = .center
        view.addSubview(todayLabel)
    }
    
    func updateTodayLabel() {
        let formater = DateFormatter()
        formater.dateFormat = "dd MMMM, yyyy"
        let dateString = formater.string(from: Date())
        todayLabel.text = dateString
    }

//MARK: - avatar settings -
    func avatarButton() {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 65, width: 60, height: 60))
        imageView.image = UIImage(named: "avatarImage")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.isUserInteractionEnabled = true //взаємодія як кнопка
        view.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSettings))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func showSettings() {
        print("image button pressed")
    }
    
    //MARK: - add button + setting -
    func addTaskButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: view.frame.width - 80, y: 65, width: 60, height: 60)
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        let image = UIImage(named: "plusImage")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.imageView?.contentMode = .scaleAspectFit
        view.addSubview(button)
    }
    
    @objc func addTask() {
        print("add button pressed")
    }
    
    //MARK: - percentages made layer -
    func percentagesMadeLayer() {
        percentagesLabel.frame = CGRect(x: -130, y: 130, width: view.frame.width, height: 50)
        percentagesLabel.font = UIFont.boldSystemFont(ofSize: 20)
        percentagesLabel.textAlignment = .center
        view.addSubview(percentagesLabel)
    }
    
    func percentagesUpdateLayer() {
        var done = "15"
        percentagesLabel.text = "\(done)%"
    }
    
    //MARK: - add progress view -
}

