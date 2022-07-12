//
//  NotificationHandler.swift
//  On The Map
//
//  Created by RhaXiel on 12/7/22.
//

import Foundation
import UIKit

class Utilities{
    static func showMessage(viewController: UIViewController, title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.show(alertVC, sender: nil)
    }
}
