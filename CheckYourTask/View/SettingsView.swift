//
//  SettingsView.swift
//  CheckYourTask
//
//  Created by macbook on 18.06.2023.
//

import UIKit

class SettingsView {
    var settingViewController: SettingViewController!
    
    // - Choose themeLabel -
    let chooseThemeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Choose theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // - save -
    let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.layer.cornerRadius = 15
        saveButton.clipsToBounds = true
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.black.cgColor
        //        saveButton.backgroundColor = UIColor(named: "ColorCreate")
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    // - collectionView -
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(ThemeCollectionViewCell.self, forCellWithReuseIdentifier: "settingCell")
        return cv
    }()
    
    //MARK: - constraint -
    func setupConstraints() {
        // - save -
        settingViewController.view.addSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: settingViewController.view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: settingViewController.view.bottomAnchor, constant: -50).isActive = true
        
        // - titleLabel -
        settingViewController.view.addSubview(chooseThemeLabel)
        chooseThemeLabel.centerXAnchor.constraint(equalTo: settingViewController.view.centerXAnchor).isActive = true
        chooseThemeLabel.topAnchor.constraint(equalTo: settingViewController.view.topAnchor, constant: 100).isActive = true
        
        // collection view
        settingViewController.view.addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
        collectionView.topAnchor.constraint(equalTo: settingViewController.view.topAnchor, constant: 150 ).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: settingViewController.view.leadingAnchor, constant: 40 ).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: settingViewController.view.trailingAnchor, constant: -40 ).isActive = true
    }
}

