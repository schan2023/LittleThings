//
//  MainViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

class MainViewController: UIViewController {
    
    @IBOutlet weak var generateEventButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var customizedButton: UIButton!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    
    //Adding event
    var ref: DatabaseReference!
    @IBOutlet weak var inputEventTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        handleLogin()
        fixButtons(button: generateEventButton)
        fixButtons(button: favoritesButton)
        fixButtons(button: saveButton)
        
        designView.layer.cornerRadius = 20
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
        
        customizedButton.layer.borderColor = UIColor.white.cgColor
        customizedButton.layer.borderWidth = 1.0
        customizedButton.layer.cornerRadius = 10
    }
    
    func handleLogin() {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    func retrieveInputField() -> String {
        
        //Retrieves data from input field
        let eventDescription = inputEventTextField.text ?? ""
        inputEventTextField.resignFirstResponder()
        inputEventTextField.text = ""
        
        return eventDescription
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let eventDescription = retrieveInputField()
        if eventDescription == "" {
            let alertErr = Alerts.createAlert(title: "Cannot save empty event!", message: "Please input event.")
            self.present(alertErr, animated: true, completion: nil)
            return
        }
        
        CreateEvent().createEvent(eventDescription: eventDescription)
        
        let alert = Alerts.createAlert(title: "Event Saved!", message: "")
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension MainViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        print("handle user signup / login")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
