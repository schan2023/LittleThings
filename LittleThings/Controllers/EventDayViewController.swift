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
    var currentFavorites = [String]()
    
    //1) boolean to check for duplicates
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventsDayDisplayLabel: UILabel!
    
    @IBOutlet weak var faveBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let eventString = currentEventsDay?.joined(separator: ", ")
        eventDateLabel.text = currentEventDate
        eventsDayDisplayLabel.text = eventString
        
        fixButtons(button: faveBtn)
        fixButtons(button: homeBtn)
        
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func faveButtonPressed(_ sender: Any) {
        retrieveFavoritesDates(completionHandler: handleRetrieveFavorites, currentFavedDate: currentEventDate!)
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
//        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
//            if(snapshot.exists()) {
//                let snapDict = snapshot.value as! NSDictionary
//                print(snapDict)
//                print(self.currentEventDate)
//                //check for duplicates
//                for(_, value) in snapDict as! [String: String] {
//                    if value == self.currentEventDate {
//                        print("This already exists!")
//                    }
//                    else {
//                        ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
//                        print("Added new date")
//                    }
//                }
//            }
//            else {
//                print("snapshot does not exist")
//                ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
//            }
//        })
        
        let alert = Alerts.createAlert(title: "Event Favorited!", message: "")
        self.present(alert, animated: true, completion: nil)
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    func retrieveFavoritesDates(completionHandler: @escaping ([String], String) -> Bool, currentFavedDate: String) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapDict = snapshot.value as! NSDictionary
            for (_, value) in snapDict as! [String : String] {
                self.currentFavorites.append(value)
            }
            completionHandler(self.currentFavorites, self.currentEventDate!)
        })
    }
    
    func handleRetrieveFavorites(dates: [String], currentFavedDate: String) -> Bool {
        print("inside handle retrieve favorites")
        print(currentFavedDate)
        
        //2) set boolean value
        
        for date in dates {
            if currentFavedDate == date {
                print("This date already exists")
                return false
            }
        }
       print("This date does not exist")
        return true
    }
    
}
