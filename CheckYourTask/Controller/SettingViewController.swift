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
        ThemeData(title: "themeWhite", image: #imageLiteral(resourceName: "themeWhite"), color45: #colorLiteral(red: 0.9662925601, green: 0.9359712005, blue: 0.9023753405, alpha: 1), color25: #colorLiteral(red: 0.8632949591, green: 0.7654848695, blue: 0.7064731717, alpha: 1), color20: #colorLiteral(red: 0.2705166936, green: 0.4434500039, blue: 0.6271486878, alpha: 1), color10: #colorLiteral(red: 0.1030795798, green: 0.2106405497, blue: 0.3431667686, alpha: 1)),
        ThemeData(title: "themeBlack", image: #imageLiteral(resourceName: "themeBlack"),  color45: #colorLiteral(red: 0.1345694363, green: 0.2182236314, blue: 0.3096637726, alpha: 1), color25: #colorLiteral(red: 0.2919410765, green: 0.4307475984, blue: 0.5186447501, alpha: 1), color20: #colorLiteral(red: 0.5955082178, green: 0.701184094, blue: 0.7551148534, alpha: 1), color10: #colorLiteral(red: 0.8588636518, green: 0.903434813, blue: 0.9322379231, alpha: 1))
    ]
    
    
    
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
            // Оновіть інтерфейс згідно з новою темою
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
        return themeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as! ThemeCollectionViewCell
        cell.themeData = self.themeData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTheme = themeData[indexPath.item]
        ThemeManager.shared.selectedTheme = selectedTheme
        updateInterfaceWithTheme()
        print("натиснута \(themeData[indexPath.item])")
    }
    
}

