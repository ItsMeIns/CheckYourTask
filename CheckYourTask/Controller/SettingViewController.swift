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
    let tasksVC = TasksViewController()
    
    
    
    //MARK: - content -
    
    
    
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.settingViewController = self
        settingsView.collectionView.delegate = self
        settingsView.collectionView.dataSource = self
        

        settingsView.setupConstraints()
        saveSettings()
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: NSNotification.Name("ThemeChangedNotification"), object: nil)
        updateInterfaceWithTheme()
    }
    
    
    
    //MARK: - intents -
    
    
    
    
    @objc private func themeChanged() {
        if let themeIndex = tasksVC.themeData.firstIndex(of: ThemeManager.shared.selectedTheme!) {
                ThemeManager.shared.saveSelectedThemeIndex(themeIndex)
            }
            updateInterfaceWithTheme()
            
        }
    
    
    private func updateInterfaceWithTheme() {
            guard let theme = ThemeManager.shared.selectedTheme else {
                return
            }

        
        view.backgroundColor = theme.color45
        settingsView.collectionView.backgroundColor = theme.color45
        
        }
    
    
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
        return tasksVC.themeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as! ThemeCollectionViewCell
        cell.themeData = self.tasksVC.themeData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTheme = tasksVC.themeData[indexPath.item]
        ThemeManager.shared.selectedTheme = selectedTheme
        updateInterfaceWithTheme()
        print("натиснута \(tasksVC.themeData[indexPath.item])")
    }
    
}

