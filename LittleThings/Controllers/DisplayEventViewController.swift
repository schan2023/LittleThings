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
    
    var arrayOfEvents: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateEvent(completionHandler: handleArrayOfEventsCompletion)
    }
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        print("generate button tapped!")
        arrayOfEvents.removeAll()
        generateEvent(completionHandler: handleArrayOfEventsCompletion)
    }
    
    func generateEvent(completionHandler: @escaping ([String]) -> Void) -> Void {
        
        //Get snapshot of user.uid
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //get numOfEvents
            let numOfEvents = value!["numOfEvents"] as? UInt32
            
            //random number
            let randNum = Int(arc4random_uniform(UInt32(numOfEvents!))) + 1
            
            //Get value of specific day
            let foundDateArray = value!["EventDaysKeys"] as? NSArray
            let foundDate = foundDateArray![randNum] as! String
            
            //Get snapshot of EventDays.foundDate
            ref.child("EventDays").child(foundDate).observeSingleEvent(of: .value, with: { (snap) in
                let snapDict = snap.value as! NSDictionary
                for (key, value) in snapDict as! [String : String] {
                    if key != "date" {
                        self.arrayOfEvents.append(value)
                    }
                }
                print(self.arrayOfEvents)
                completionHandler(self.arrayOfEvents)
            })
        })
        
    }
    
    func handleArrayOfEventsCompletion(arrayOfEventsList: [String]) -> Void {
        arrayOfEvents = arrayOfEventsList
        
        //generate random event
        returnRandomEvent(eventsArray: arrayOfEvents)
    }
    
    func returnRandomEvent(eventsArray: [String]) -> Void {
        let num = eventsArray.count

        //Generate random number from 0 or array size
        let randomInt = Int(arc4random_uniform(UInt32(num)))

        //Set label as event description
        eventLabel.text = eventsArray[randomInt]
    }
    
    //Use segue identifier to go to day function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayEventDay":
            print("inside display event day segue")
            let destination = segue.destination as! EventDayViewController
            destination.currentEventsDay = arrayOfEvents
            
        default:
            print("unexpected segue identifier")
        }
    }
}
