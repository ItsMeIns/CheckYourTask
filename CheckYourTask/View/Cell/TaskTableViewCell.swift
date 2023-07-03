//
//  TaskTableViewCell.swift
//  CheckYourTask
//
//  Created by macbook on 27.05.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //MARK: - properties -
    weak var tasksViewController: TasksViewController?
    var contentViewColor: UIColor?
    var cellContentViewColor: UIColor?
    
    
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
    
    let cellContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        
        nameLabel.numberOfLines = 3
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cellContentView.layer.cornerRadius = 15
        cellContentView.addSubview(nameLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        cellContentView.addSubview(timeLabel)
        
        reminderImageView.image = UIImage(named: "reminder_icon")
        reminderImageView.translatesAutoresizingMaskIntoConstraints = false
        cellContentView.addSubview(reminderImageView)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        cellContentView.addSubview(checkBoxButton)
        
        contentView.addSubview(cellContentView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -80),
            nameLabel.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -8),
            timeLabel.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: checkBoxButton.bottomAnchor, constant: 8),
            timeLabel.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -16),
            reminderImageView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -60),
            reminderImageView.centerYAnchor.constraint(equalTo: cellContentView.centerYAnchor),
            reminderImageView.widthAnchor.constraint(equalToConstant: 20),
            reminderImageView.heightAnchor.constraint(equalToConstant: 20),
            checkBoxButton.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -20),
            checkBoxButton.centerYAnchor.constraint(equalTo: cellContentView.centerYAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 30),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 30),
            
            cellContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkBoxButtonTapped() {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let tasksViewController = tasksViewController,
           let indexPath = tasksViewController.tableView.indexPath(for: self) {
            let task = tasksViewController.tasks[indexPath.row]
            if checkBoxButton.isSelected {
                if let notificationId = task.notificationId {
                    tasksViewController.notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
                    task.notificationId = nil
                }
                task.reminder = false
                appDelegate.saveContext()
            }
            task.isComplete = checkBoxButton.isSelected
            do {
                let context = appDelegate.persistentContainer.viewContext
                try context.save()
                tasksViewController.updateProgress()
                tasksViewController.tableView.reloadData()
                print("Натиснуто чекбокс")
            } catch {
                print("Помилка при збереженні задачі: \(error)")
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
        
        updateInterfaceWithTheme()
    }
    
    func updateInterfaceWithTheme() {
        guard let theme = ThemeManager.shared.selectedTheme else {
            return
        }
        
        
        if theme.title == "themeCocoa" || theme.title == "themePink" {
            nameLabel.textColor = .black
            timeLabel.textColor = .black
        } else {
            nameLabel.textColor = .white
            timeLabel.textColor = .white
        }
        
        contentView.backgroundColor = contentViewColor
        cellContentView.backgroundColor = cellContentViewColor
        
        
    }
    
}
