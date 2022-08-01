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
    
    static func openUrl(viewController: UIViewController, url: String??) {
        let app = UIApplication.shared
        guard var toOpen = url! else {
            Utilities.showMessage(viewController: viewController.parent!.parent!, title: "Url Error", message: "Cannot open the url")
            return
        }
        
        toOpen = toOpen.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if (toOpen != "" && toOpen != "nil") {
            if !toOpen.contains("http") {
                toOpen = "http://" + toOpen
            }
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        } else {
            Utilities.showMessage(viewController: viewController.parent!.parent!, title: "Url Error", message: "Cannot open the url")
        }
    }
    
    static func showYesCancelWithCompletion(viewController: UIViewController, title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "YES", style: .default, handler: { (alert) in
            DispatchQueue.main.async {
                completion(true)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
