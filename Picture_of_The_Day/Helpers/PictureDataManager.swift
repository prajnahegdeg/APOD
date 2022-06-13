//
//  PictureDataManager.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import CoreData
import UIKit

class PictureDataManager {
    
    public static let shared = PictureDataManager()
    private init() {
        
    }
    
    func savePicture(picture: Picture, image:UIImage) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "PictureInfo", in: context)
            let newPicture = NSManagedObject(entity: entity!, insertInto: context)
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            newPicture.setValue(picture.explanation, forKey: "explanation")
            newPicture.setValue(picture.url, forKey: "url")
            newPicture.setValue(picture.title, forKey: "title")
            newPicture.setValue(picture.hdurl, forKey: "hdurl")
            newPicture.setValue(picture.date, forKey: "date")
            newPicture.setValue(picture.copyright, forKey: "copyright")
            newPicture.setValue(picture.media_type, forKey: "mediaType")
            newPicture.setValue(picture.thumbnail_url, forKey: "thumbnail_url")
            newPicture.setValue(false, forKey: "favorite")
            let imageData = image.jpegData(compressionQuality: 1)
            newPicture.setValue(imageData, forKey: "image")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func getLastSavedPicture() -> Picture? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
            request.returnsObjectsAsFaults = false
            
            
            do {
                let allElementsCount = try context.count(for: request)
                if(allElementsCount > 0) {
                    request.fetchLimit = 1
                    request.fetchOffset = allElementsCount - 1
                    request.returnsObjectsAsFaults = false
                    let result = try context.fetch(request)
                    var picture: Picture?
                    for data in result as! [NSManagedObject] {
                        picture = populatePictureFromData(data: data)
                    }
                    return picture
                }
                return nil
                
            } catch {
                
                print("Failed")
            }
        }
        return nil
        
    }
    
    func getFavoritePictures() -> [Picture]? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "favorite = %@",NSNumber.init(value: true))
            
            do {
                
                request.returnsObjectsAsFaults = false
                let result = try context.fetch(request)
                var pictures: [Picture] = []
                if(result.count > 0) {
                    for data in result as! [NSManagedObject] {
                        pictures.append(populatePictureFromData(data: data))
                    }
                }
                
                return pictures
                
            } catch {
                
                print("Failed")
            }
        }
        return nil
    }
    
    func getPictureWithUrl(url: String) -> Picture? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "url like '\(url)'")
            
            do {
                let allElementsCount = try context.count(for: request)
                if(allElementsCount > 0) {
                    request.returnsObjectsAsFaults = false
                    let result = try context.fetch(request)
                    var picture: Picture?
                    for data in result as! [NSManagedObject] {
                        picture = populatePictureFromData(data: data)
                    }
                    return picture
                }
                return nil
                
            } catch {
                
                print("Failed")
            }
        }
        return nil
        
    }
    
    func updateFavoriteState(picture: Picture, isFavorite: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PictureInfo")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "url like '\(picture.url ?? "")'")
            
            do {
                let allElementsCount = try context.count(for: request)
                if(allElementsCount > 0) {
                    request.returnsObjectsAsFaults = false
                    let result = try context.fetch(request)
                    let objectUpdate = result[0] as! NSManagedObject
                    objectUpdate.setValue(isFavorite, forKey: "favorite")
                    do {
                        try context.save()
                    }catch  {
                        print("Failed")
                    }
                }
                return
                
            } catch {
                
                print("Failed")
            }
        }
    }
    
    
    private func populatePictureFromData(data:NSManagedObject) -> Picture {
        var picture: Picture
        let explanation = data.value(forKey: "explanation") as? String ?? ""
        let url = data.value(forKey: "url") as? String ?? ""
        let thumbnail_url = data.value(forKey: "thumbnail_url") as? String ?? ""
        let title = data.value(forKey: "title") as? String ?? ""
        let hdurl = data.value(forKey: "hdurl") as? String ?? ""
        let date = data.value(forKey: "date") as? String ?? ""
        let copyright = data.value(forKey: "copyright") as? String ?? ""
        let media_Type = data.value(forKey: "mediaType") as? String ?? ""
        let isFavorite = data.value(forKey: "favorite") as? Bool ?? false
        let imageData = data.value(forKey: "image") as? Data
        picture = Picture(copyright: copyright, date: date, explanation: explanation, hdurl: hdurl, media_type: media_Type, title: title, url: url,thumbnail_url: thumbnail_url, image: imageData,favorite: isFavorite)
        return picture
    }
    
}
