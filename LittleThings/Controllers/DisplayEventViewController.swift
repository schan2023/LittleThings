//
//  DisplayEventViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class DisplayEventViewController: UIViewController {
    
    var currentEvent: Event?
    var arrayOfEvents: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateEvent()
    }
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        generateEvent()
    }
    
    func generateEvent() -> Void {
        
        //Get snapshot of user.uid
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value)
            
            //get numOfEvents
            let numOfEvents = value!["numOfEvents"] as? UInt32
            print("Number of events: \(numOfEvents)")
            
            //random number
            let randNum = Int(arc4random_uniform(UInt32(numOfEvents!))) + 1
            print("random number: \(randNum)")
            
            //Get value of specific day
            let foundDateArray = value!["EventDaysKeys"] as? NSArray
            let foundDate = foundDateArray![randNum] as! String
            print("This date was found: \(foundDate)")
            
            //Get snapshot of EventDays.foundDate
            ref.child("EventDays").child(foundDate).observeSingleEvent(of: .value, with: { (snap) in
                print("Retrieve snapshot of EventDate.foundDate")
                print(snap.value)
                let snapDict = snap.value as! NSDictionary
                for (key, value) in snapDict as! [String : String] {
                    if key != "date" {
                        self.arrayOfEvents.append(value)
                    }
                }
                print(self.arrayOfEvents)
            })
            
        })
        
//        //Retrieve events from core data
//        let eventsArray = CoreDataHelper.retrieveEvents()
//        let num = eventsArray.count
//
//        //Generate random number from 0 or array size
//        let randomInt = Int(arc4random_uniform(UInt32(num)))
//
//        //Set label as event description
//        eventLabel.text = eventsArray[randomInt].eventDescription
//
//        //Saves current event
//        currentEvent = eventsArray[randomInt]
        
    }
    
    //Use segue identifier to go to day function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayEventDay":
            print("inside display event day segue")
            let destination = segue.destination as! EventDayViewController
            destination.currentEvent = currentEvent
            
        default:
            print("unexpected segue identifier")
        }
    }
}
