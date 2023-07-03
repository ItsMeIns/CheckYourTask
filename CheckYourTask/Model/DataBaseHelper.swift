//
//  DataBaseHelper.swift
//  CheckYourTask
//
//  Created by macbook on 03.07.2023.
//


import UIKit
import CoreData

class DataBaseHelper {
    static let shareInstance = DataBaseHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        
        let imageInstance = ImageAvatar(context: context)
        imageInstance.img = data
        
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage() -> [ImageAvatar] {
        var fetchingImage = [ImageAvatar]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageAvatar")
         
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [ImageAvatar]
        } catch {
            print("Error while fetching the image")
        }
        return fetchingImage
    }
}
