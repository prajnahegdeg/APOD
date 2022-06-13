//
//  FavoritesViewController.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 13/06/22.
//

import Foundation
import UIKit

class FavoritesViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var datasource: FavoritesDataManager = FavoritesDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favorites = datasource.favorites {
            return favorites.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.PictureCell, for: indexPath) as? PictureCell {
            if let picture = datasource.pictureAtIndex(index: indexPath.row) {
                cell.titleLabel.text = picture.title
                cell.dateLabel.text = picture.date
                cell.pictureImageView.image = UIImage(data: picture.image!)
                return cell
            }
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            AlertService.showConfirmCanelAlert(title: "Confirm deletion", message: "The item will be removed from the favorite list", viewController: self) {
                self.datasource.deleteFromFavoritesAt(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
           
        }
    }
    
   
    
}
