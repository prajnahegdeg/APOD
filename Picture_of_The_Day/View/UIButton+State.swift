//
//  UIButton+State.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import UIKit

extension UIButton {
    
    func handleFavoriteState(picture: Picture) {
        let updatedPicture = PictureDataManager.shared.getPictureWithUrl(url: picture.url!)
        if let favorite = updatedPicture?.favorite , favorite == true {
            self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.tintColor = .white
    }
}
