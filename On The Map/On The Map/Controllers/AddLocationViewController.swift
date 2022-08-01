//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by RhaXiel on 31/7/22.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        APIClient.getU
        ApiClient.getUserData(completion: handleUserDataResponse(success:error:))
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeAddLocationSegue" {
            let vc = segue.destination as! CompleteAddLocationViewController
            vc.placemark = placemark
            vc.mediaUrl = linkTextField.text
            vc.locationText = locationTextField.text
        }
    }
    
    func isValidFields() -> Bool {
        if locationTextField.text == "" {
            Utilities.showMessage(viewController: self, title: "Validation error", message: "Location cannot be empty")
            return false
        } else if linkTextField.text == "" {
            Utilities.showMessage(viewController: self, title: "Validation error", message: "Link cannot be empty")
            return false
        } else {
            return true
        }
    }
    
    func handleUserDataResponse(success: Bool, error: Error?) {
        if error != nil {
            Utilities.showMessage(viewController: self, title: "User data error", message: "Could not get public user data!")
        }
    }
    
    
    @IBAction func handleAddLocationClicked(_ sender: Any) {
        if isValidFields() {
            CLGeocoder().geocodeAddressString((locationTextField.text)!) { (placemarks, error) in
                guard let placemarks = placemarks else {
                    DispatchQueue.main.async {
                        Utilities.showMessage(viewController: self, title: "Geocode Error", message: "Error finding location!")
                    }
                    return
                }
                self.placemark = placemarks.first
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeAddLocationSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func handleCancelClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
