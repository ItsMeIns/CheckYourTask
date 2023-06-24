//
//  ThemeCollectionViewCell.swift
//  CheckYourTask
//
//  Created by macbook on 18.06.2023.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    

    
    
    var themeData: ThemeData? {
            didSet {
                guard let themeData = themeData else { return }
                background.image = themeData.image
            }
        }
    
    
   
    fileprivate let background: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    
    
    
    
    //MARK: - init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(background)
        background.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
