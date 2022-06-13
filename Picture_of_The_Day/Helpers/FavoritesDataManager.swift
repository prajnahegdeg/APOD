//
//  FavoritesDataManager.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 13/06/22.
//

import Foundation

class FavoritesDataManager {
        
    var favorites:[Picture]?
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        favorites = PictureDataManager.shared.getFavoritePictures()
    }
    
    func pictureAtIndex(index:Int) -> Picture? {
        return favorites?[index] ?? nil
    }
    
    func deleteFromFavoritesAt(index: Int) {
        if let picture = pictureAtIndex(index: index) {
            PictureDataManager.shared.updateFavoriteState(picture: picture, isFavorite: false)
            loadFavorites()
        }
    }
  
}
