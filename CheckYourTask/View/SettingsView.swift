//
//  SettingsView.swift
//  CheckYourTask
//
//  Created by macbook on 18.06.2023.
//

import UIKit

class SettingsView {
    var settingViewController: SettingViewController!
    
    
    //MARK: - avatar + settings -
    let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatarImage")
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.isUserInteractionEnabled = true //взаємодія як кнопка
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // - Choose themeLabel -
    let chooseThemeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = HomeStrings.chooseThemeLabel.translation
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
        saveButton.setTitle(HomeStrings.saveButton.translation, for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
        
        //avatar
        settingViewController.view.addSubview(avatar)
        avatar.heightAnchor.constraint(equalToConstant: 150).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        avatar.centerXAnchor.constraint(equalTo: settingViewController.view.centerXAnchor).isActive = true
        avatar.topAnchor.constraint(equalTo: settingViewController.view.topAnchor, constant: 80).isActive = true
        
        
        // - titleLabel -
        settingViewController.view.addSubview(chooseThemeLabel)
        chooseThemeLabel.centerXAnchor.constraint(equalTo: settingViewController.view.centerXAnchor).isActive = true
        chooseThemeLabel.topAnchor.constraint(equalTo: settingViewController.view.topAnchor, constant: 260).isActive = true
        
        // collection view
        settingViewController.view.addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
        collectionView.topAnchor.constraint(equalTo: settingViewController.view.topAnchor, constant: 300 ).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: settingViewController.view.leadingAnchor, constant: 40 ).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: settingViewController.view.trailingAnchor, constant: -40 ).isActive = true
        
        // - save -
        settingViewController.view.addSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: settingViewController.view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: settingViewController.view.bottomAnchor, constant: -50).isActive = true
    }
}

