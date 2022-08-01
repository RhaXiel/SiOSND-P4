//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method
* invocation when a pin annotation is tapped. It accomplishes this using two delegate
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var logoutButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStudentLocations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                Utilities.openUrl(viewController: self, url: toOpen)
            }
        }
    }
    
    private func getStudentList() {
        APIClient.getStudentLocation(limit: nil, skip: nil, order: "-updatedAt", uniqueKey: nil){success, error in
            self.handleGetStudentsResponse(students: success, error: error)
        }
    }
    
    func handleGetStudentsResponse(students: [StudentLocation], error: Error?) {
        if error != nil {
            Utilities.showMessage(viewController: self, title: "Get Students Error", message: error?.localizedDescription ?? "")
        } else {
            StudentsData.students = students
            loadStudentLocations()
        }
    }
    
    func loadStudentLocations(){
        let locations = StudentsData.students
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.annotations.forEach {
          if !($0 is MKUserLocation) {
            self.mapView.removeAnnotation($0)
          }
        }
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    
    @IBAction func handleLogout(_ sender: Any) {
        APIClient.deleteSession(){success, error in
            if APIClient.Auth.sessionId == "" {
                StudentsData.currentUser = nil
                self.dismiss(animated: true)
                //Utilities.showMessage(viewController: self.parent!.parent!, title: "Logged out succesfully", message: "Returning to loggin screen.")
            } else {
                Utilities.showMessage(viewController: self, title: "Logout failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func handleRefresh(_ sender: Any) {
        getStudentList()
    }
    
    private func navigateToAddLocationViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") {
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    @IBAction func handleAddLocation(_ sender: Any) {
        if StudentsData.currentLocationId != nil {
            Utilities.showYesCancelWithCompletion(viewController: self, title: "Confirm update?", message: "Confirm update current location?") { (success) in
                if success {
                    self.navigateToAddLocationViewController()
                }
            }
        } else {
            navigateToAddLocationViewController()
        }
    }
    
}
