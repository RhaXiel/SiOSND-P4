//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation
import UIKit

class StudentsTableViewController: UITableViewController {
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsData.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell") as! StudentsTableViewCell
        
        let student = StudentsData.students[indexPath.row]
        let first = student.firstName
        let last = student.lastName
        let fullname = "\(first) \(last)"
        cell.nameLabel.text = fullname.trimmingCharacters(in: .whitespacesAndNewlines) != "" ? fullname : "<Name not found>"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    
    func openSelectedMediaUrl() {
        let student = StudentsData.students[selectedIndex]
        Utilities.openUrl(viewController: self, url: student.mediaURL)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        openSelectedMediaUrl()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    private func getStudentList() {
        APIClient.getStudentLocation(limit: "100", skip: nil, order: "-updatedAt", uniqueKey: nil){success, error in
            self.handleGetStudentsResponse(students: success, error: error)
        }
    }
    
    func handleGetStudentsResponse(students: [StudentLocation], error: Error?) {
        if error != nil {
            Utilities.showMessage(viewController: self.parent!.parent!, title: "Get Students Error", message: error?.localizedDescription ?? "")
        } else {
            StudentsData.students = students
            self.tableView.reloadData()
        }
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
    
    private func navigateToAddLocationViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") {
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
}
