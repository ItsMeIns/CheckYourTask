//
//  SettingViewController.swift
//  CheckYourTask
//
//  Created by macbook on 17.06.2023.
//

import UIKit

class SettingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    //MARK: - properties -
    let settingsView = SettingsView()
    
    
    
    //MARK: - content -
    let themeData = [
        ThemeData(title: "first", image: #imageLiteral(resourceName: "image33")),
        ThemeData(title: "first", image: #imageLiteral(resourceName: "image44")),
        ThemeData(title: "first", image: #imageLiteral(resourceName: "image11")),
        ThemeData(title: "first", image: #imageLiteral(resourceName: "image22"))
    ]
    
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        settingsView.settingViewController = self
        settingsView.collectionView.delegate = self
        settingsView.collectionView.dataSource = self
        

        settingsView.setupConstraints()
        saveSettings()
        
        
        
    }
    
    
    
    //MARK: - intents -
    
    
    //save button
    func saveSettings() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        settingsView.saveButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func saveButtonTapped() {
        let backToTaskVC = TasksViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(backToTaskVC, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
     }
    
    
    
    
    
    // collectionView delegate & datasource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: settingsView.collectionView.frame.width/2.5, height: settingsView.collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as! ThemeCollectionViewCell
        cell.themeData = self.themeData[indexPath.row]
        return cell
    }
    
    
    
}

