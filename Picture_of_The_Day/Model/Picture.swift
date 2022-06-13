//
//  Picture.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//


import Foundation
import UIKit

struct Picture: Codable {
    var copyright: String?
    var date: String?
    var explanation: String?
    var hdurl: String?
    var media_type: String?
    var title: String?
    var url: String?
    var thumbnail_url: String?
    var image: Data?
    var favorite: Bool? = false
}


extension Picture {
    func isVideo() -> Bool {
        return self.media_type == "video"
    }
}
