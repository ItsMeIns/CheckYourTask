//
//  TaskTableViewCell.swift
//  CheckYourTask
//
//  Created by macbook on 27.05.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    weak var tasksViewController: TasksViewController?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let reminderImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let checkBoxButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "Color2")
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.gray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        reminderImageView.image = UIImage(named: "reminder_icon")
        reminderImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reminderImageView)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkBoxButton)
        
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            reminderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            reminderImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            reminderImageView.widthAnchor.constraint(equalToConstant: 20),
            reminderImageView.heightAnchor.constraint(equalToConstant: 20),
            
            checkBoxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkBoxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            // Ігноруємо натискання в інших частинах комірки, окрім області checkBoxButton
            return checkBoxButton.frame.contains(point)
        }
    
    @objc func checkBoxButtonTapped() {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let tasksViewController = tasksViewController,
           let indexPath = tasksViewController.tableView.indexPath(for: self) {
            let task = tasksViewController.tasks[indexPath.row]
            task.isComplete = checkBoxButton.isSelected
            
            do {
                let context = appDelegate.persistentContainer.viewContext
                try context.save() // Зберегти зміни в контексті Core Data
                tasksViewController.updateProgress()
                tasksViewController.tableView.reloadData()
            } catch {
                print("Error saving task: \(error)")
            }
        }
    }







    
    func configure(with task: DataTask) {
        nameLabel.text = task.taskName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let taskTime = task.time {
            timeLabel.text = dateFormatter.string(from: taskTime)
            timeLabel.isHidden = !task.reminder
        } else {
            timeLabel.text = ""
            timeLabel.isHidden = true
        }
        
        if task.reminder {
            reminderImageView.image = UIImage(named: "reminder-on")
        } else {
            reminderImageView.image = UIImage(named: "reminder-off")
        }
        
        let checkedImage = UIImage(named: "checkmark")
        let uncheckedImage = UIImage(named: "empty_checkbox")
        
        checkBoxButton.setImage(task.isComplete ? checkedImage : uncheckedImage, for: .normal)
        checkBoxButton.setImage(checkedImage, for: .selected)
        checkBoxButton.isSelected = task.isComplete
    }
}
