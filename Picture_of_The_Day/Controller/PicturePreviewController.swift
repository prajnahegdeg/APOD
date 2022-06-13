//
//  PicturePreviewController.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 13/06/22.
//

import Foundation
import UIKit

class PicturePreviewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var picture: Picture!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        self.imageView.downloadImage(picture: picture, isHD: true) {
            self.activityIndicator.stopAnimating()
        }
    }
}
