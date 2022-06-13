//
//  PictureRequest.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation

class PictureRequest {
    
    static let networkService = NetworkService()
    
    class func searchForPicture(date: String, completionHandler: @escaping (Picture?) -> Void) {
    
        PictureRequest.networkService.fetchAPOD(date: date) { picture in
            completionHandler(picture)
        }
    }

}
