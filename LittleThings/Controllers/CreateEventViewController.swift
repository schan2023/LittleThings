//
//  CreateEventViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateEventViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var ref: DatabaseReference!
    var event: Event?
    
    @IBOutlet weak var inputEventTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if inputEventTextField.text == "" {
            let alertErr = Alerts.createAlert(title: "Cannot save empty event!", message: "Please input event.")
            self.present(alertErr, animated: true, completion: nil)
            return
        }
        
        let eventDescription = inputEventTextField.text
        let eventDate = convertDateFormatToString(date: Date())
        inputEventTextField.resignFirstResponder()
        inputEventTextField.text = ""
        
        //Saves event to Firebase
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Events").child(eventDate).childByAutoId().setValue(eventDescription)
        
        let alert = Alerts.createAlert(title: "Event Saved!", message: "")
        self.present(alert, animated: true, completion: nil)

    }
    
    func convertDateFormatToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateformatter.string(from: Date())
        
        return dateString
    }
}

