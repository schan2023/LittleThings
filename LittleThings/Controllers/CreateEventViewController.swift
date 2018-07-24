//
//  CreateEventViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var event: Event?
    
    @IBOutlet weak var inputEventTextField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if inputEventTextField.text == "" {
            let alert = Alerts.createAlert(title: "Cannot input empty event!", message: "Please enter event.")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        event = CoreDataHelper.newEvent()
        event?.eventDescription = inputEventTextField.text
        event?.eventDate = convertDateFormatToString(date: Date())
        
        print(event?.eventDescription)
        print(event?.eventDate)
        
        inputEventTextField.resignFirstResponder()
        inputEventTextField.text = ""
        
        CoreDataHelper.saveEvent()
        
        let alert = Alerts.createAlert(title: "Event Saved!", message: "")
        self.present(alert, animated: true, completion: nil)
    }
    
    func convertDateFormatToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy"
        let dateString = dateformatter.string(from: Date())
        
        return dateString
    }
}

