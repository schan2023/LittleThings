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
    
    @IBOutlet weak var inputEventLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
    }
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var inputEventTextField: UITextField!
    
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

