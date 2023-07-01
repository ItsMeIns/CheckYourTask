//
//  DetailedViewController.swift
//  CheckYourTask
//
//  Created by macbook on 09.06.2023.
//

import UIKit


class DetailedViewController: UIViewController {
    //MARK: - properties -
    let detailedView = DetailedView()
    var task: DataTask?
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        detailedView.detailedViewController = self
        detailedView.setupConstraints()
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
        detailedView.backgroundView.backgroundColor = theme.color25
        detailedView.cancelButton.backgroundColor = theme.color25
        detailedView.editButton.backgroundColor = theme.color25
        
        
        if theme.title == "themeCocoa" || theme.title == "themePink" {
            detailedView.cancelButton.setTitleColor(UIColor.black, for: .normal)
            detailedView.editButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            detailedView.cancelButton.setTitleColor(UIColor.white, for: .normal)
            detailedView.editButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
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
    
    @objc func editButtonPressed() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.task = task
        addTaskVC.isEditMode = true //2
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    private func callSettings() {
        detailedView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        detailedView.editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    }
    
    func updateUI() {
        detailedView.taskName.text = task?.taskName
        detailedView.taskDescription.text = task?.taskDescription
    }
}

