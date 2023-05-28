//
//  TaskTableViewCell.swift
//  CheckYourTask
//
//  Created by macbook on 27.05.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
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
        
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            reminderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reminderImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            reminderImageView.widthAnchor.constraint(equalToConstant: 20),
            reminderImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        nameLabel.text = task.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let taskTime = task.time {
            timeLabel.text = dateFormatter.string(from: taskTime)
        } else {
            timeLabel.text = ""
        }
        
        if task.reminder {
            reminderImageView.image = UIImage(named: "reminder-on")
        } else {
            reminderImageView.image = UIImage(named: "reminder-off")
        }
    }
}
