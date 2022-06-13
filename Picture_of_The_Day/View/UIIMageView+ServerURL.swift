//
//  UIImageView+ServerURL.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import UIKit


let networkService = NetworkService()

extension UIImageView {
    
    func downloadImage(picture: Picture, isHD: Bool, completionHandler: @escaping () -> Void) {
        var imageUrl = isHD ? picture.hdurl : picture.url
        if (picture.isVideo()) {
            imageUrl = picture.thumbnail_url
        }
        if let url = URL(string: imageUrl ?? "") {
            image = nil
            
            let existingPicture = PictureDataManager.shared.getPictureWithUrl(url: picture.url ?? "")
            if let image = existingPicture?.image {
                    self.image = UIImage(data: image)
                completionHandler()
                return
            }
            networkService.downloadImage(url: url) { data, response, error in
                if error != nil{
                    DispatchQueue.main.async(execute: {
                        let image = UIImage(named: "thumbnail")
                        self.image = image
                        completionHandler()
                    })
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    if let image = UIImage(data: data!){
                        self.image = image
                        PictureDataManager.shared.savePicture(picture: picture,image: image)
                        completionHandler()
                    }
                })
            }
        }
    }
    
}
