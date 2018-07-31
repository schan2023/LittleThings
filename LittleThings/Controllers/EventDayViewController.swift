//
//  EventDayViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class EventDayViewController: UIViewController {
    
    var currentEventsDay: [String]?
    var currentEventDate: String?
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventsDayDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayEventsByDay()
    }
    
    func displayEventsByDay() {
        print("inside event day view")
        let eventString = currentEventsDay?.joined(separator: ", ")
        eventDateLabel.text = currentEventDate
        eventsDayDisplayLabel.text = eventString
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func faveButtonPressed(_ sender: Any) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()) {
                let snapDict = snapshot.value as! NSDictionary
                print(snapDict)
                print(self.currentEventDate)
                //check for duplicates
                for(_, value) in snapDict as! [String: String] {
                    if value == self.currentEventDate {
                        print("This already exists!")
                    }
                    else {
                        ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
                        print("Added new date")
                    }
                }
            }
            else {
                print("snapshot does not exist")
                ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
            }
        })
    }
    
    
}
