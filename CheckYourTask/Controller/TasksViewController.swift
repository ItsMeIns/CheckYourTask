//
//  ViewController.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import UIKit
import FSCalendar

class TasksViewController: UIViewController {
    
    
    // FSCalendar properties
        fileprivate weak var calendar: FSCalendar!
        fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
        fileprivate let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        // CollectionView properties
        fileprivate var collectionView: UICollectionView!
        fileprivate let cellIdentifier = "cell"
        fileprivate let itemsPerRow: CGFloat = 7
        fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
    
    
    
    let todayLabel = UILabel()
    let percentagesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabelTop()
        avatarButton()
        addTaskButton()
        percentagesMadeLayer()
        addProgressView()
        addCalendar()
        
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
    func addProgressView() {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 140, y: 153, width: 200, height: 20)
//        progressView.center = view.center
        progressView.progress = 0.15
        view.addSubview(progressView)
    }
    
    //MARK: - add FSCalendar -
    func addCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 170, width: view.frame.width, height: 300))
        calendar.scope = .week
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerDateFormat = "LLLL yyyy"
        calendar.appearance.weekdayTextColor = .darkGray
        calendar.appearance.todayColor = .systemBlue
        calendar.appearance.selectionColor = .brown
        view.addSubview(calendar)
    }
    
    func setupCollectionView() {
            // Initialize collectionView
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            let itemWidth = (view.frame.width) / itemsPerRow
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.sectionInset = sectionInsets
            collectionView = UICollectionView(frame: CGRect(x: 0, y: 360, width: view.frame.width, height: view.frame.height - 360), collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
            collectionView.backgroundColor = UIColor.white
            view.addSubview(collectionView)
        }
    
}

extension TasksViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let day = self.gregorian.component(.day, from: date)
        if day % 3 == 0 {
            return "Task"
        } else {
            return nil
        }
    }
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        //
//        return FSCalendarCell()
//    }
    
}

extension TasksViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 31
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            cell.backgroundColor = UIColor.gray
            return cell
        }
 }
