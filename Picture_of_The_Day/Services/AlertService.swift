//
//  AlertService.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import UIKit

class AlertService {
    
    class func showOKAlert(title:String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showConfirmCanelAlert(title:String, message: String, viewController: UIViewController, confirmAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (alert) in
            confirmAction()
        }))
        viewController.present(alert, animated: true, completion: nil)

    }
}
