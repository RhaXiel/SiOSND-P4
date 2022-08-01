//
//  LoginViewController.swift
//  On The Map
//
//  Created by RhaXiel on 10/7/22.
//

import UIKit

class LoginViewController: UIViewController {

    let signupUrl = "https://auth.udacity.com/sign-up"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoggingIn(true)
        APIClient.postSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            self.handleSessionResponse(success: success?.session.id != nil, error: error)
        }
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        Utilities.openUrl(viewController: self, url: signupUrl)
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            self.handleGetUserInfo(success: success, error: error)
        } else {
            Utilities.showMessage(viewController: self, title: "Login failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func handleGetUserInfo(success: Bool, error: Error?){
        if success{
            APIClient.getUser(userId: APIClient.Auth.userKey){
                _success, _error in
                StudentsData.currentUser = _success
                //self.handleLoginResponse(success: _success?.firstName.isEmpty != nil, error: _error)
                self.handleLoginResponse(success: StudentsData.currentUser != nil, error: _error)
            }
        }else{
            Utilities.showMessage(viewController: self, title: "Login failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        if success{
            performSegue(withIdentifier: "loggedIn", sender: nil)
        }else{
            Utilities.showMessage(viewController: self, title: "Login failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signupButton.isEnabled = !loggingIn
    }
    
}
