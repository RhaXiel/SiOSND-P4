//
//  CompleteAddLocationViewController.swift
//  On The Map
//
//  Created by RhaXiel on 31/7/22.
//

import UIKit
import MapKit

class CompleteAddLocationViewController: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placemark: CLPlacemark?
    var mediaUrl: String?
    var locationText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let placemark = placemark else {
            return
        }
        setAnnotation(placemark: placemark)
        //self.mapView.delegate = self
    }
    
    func setAnnotation(placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(placemark.name ?? ""), \(placemark.country ?? "")"
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    // MARK: Following will set the region, to focus on the map where the annotation placed.
    func setRegion(with placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        let userLocation: CLLocationCoordinate2D = coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation, span: span)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    func handleUserLocationResponse(success: Bool, error: Error?) {
        
        if success {
            navigateToTabBarViewController()
        } else {
            Utilities.showMessage(viewController: self.parent!.parent!, title: "Add Location Error", message: error?.localizedDescription ?? "")
        }
    }
    
    func navigateToTabBarViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .roundedRect)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBAction func handleNavigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleConfirmClicked(_ sender: Any) {
        guard let coordinate = placemark?.location?.coordinate else {
            return
        }
        
        if StudentsData.currentLocationId == nil {
            APIClient.postStudenLocation(firstName: StudentsData.currentUser?.firstName ?? "", lastName: StudentsData.currentUser?.lastName ?? "", latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude), mapString: locationText ?? "", mediaURL: mediaUrl ?? "", uniqueKey: APIClient.Auth.userKey) { success, error in
                self.handleUserLocationResponse(success: (success != nil), error: error)
            }
        } else {
            APIClient.putStudentLocation(firstName: StudentsData.currentUser?.firstName ?? "", lastName: StudentsData.currentUser?.lastName ?? "", latitude: Float(coordinate.latitude), longitude: Float(coordinate.longitude), mapString: locationText ?? "", mediaURL: mediaUrl ?? "", uniqueKey: APIClient.Auth.userKey, objectId: StudentsData.currentLocationId ?? ""){ success, error in
                self.handleUserLocationResponse(success: (success != nil), error: error)
            }
            
        }

    }
    
}
