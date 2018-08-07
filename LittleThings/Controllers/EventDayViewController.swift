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
    
    var found: Bool = true
    
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
        print("fave button pressed")
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.checkIfFavoriteAlreadyExists(currentDate: currentEventDate!) { isExist in
            if isExist {
                print("date already exists")
                let alert = Alerts.createAlert(title: "Event already favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                print("date does not exist")
                ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
                print("Added new date")
                let alert = Alerts.createAlert(title: "Event Favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
            }
        }
//        retrieveFavoritesDates(completionHandler: handleRetrieveFavorites, currentFavedDate: currentEventDate!)
//        let ref = Database.database().reference()
//        let user = Auth.auth().currentUser
//
//        print("this is inside found \(found)")
//        if found{
//            let alert = Alerts.createAlert(title: "Event already favorited!", message: "")
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        else {
//            ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
//            print("Added new date")
//            let alert = Alerts.createAlert(title: "Event Favorited!", message: "")
//            self.present(alert, animated: true, completion: nil)
//        }
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
        
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
//    func retrieveFavoritesDates(completionHandler: @escaping ([String], String, Bool) -> Void, currentFavedDate: String) {
//        print("inside retrieve favorite dates")
//        let ref = Database.database().reference()
//        let user = Auth.auth().currentUser
//        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.exists() {
//                print("snapshot exists")
//                let snapDict = snapshot.value as! NSDictionary
//                for (_, value) in snapDict as! [String : String] {
//                    self.currentFavorites.append(value)
//                }
//            }
//            else {
//                print("snapshot does not exist, found = false")
//                self.found = false
//            }
//            completionHandler(self.currentFavorites, self.currentEventDate!, self.found)
//        })
//    }
//
//    func handleRetrieveFavorites(dates: [String], currentFavedDate: String, found: Bool) -> Void {
//        print("inside handle retrieve favorites")
//        print(currentFavedDate)
//        print(found)
//
//        for date in dates {
//            if currentFavedDate == date {
//                print("This date already exists")
//                self.found = false
//            }
//        }
//    }
    
    func checkIfFavoriteAlreadyExists(currentDate: String, completionHandler: @escaping(Bool) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print("snapshot exists")
                let snapDict = snapshot.value as! NSDictionary
                for (_, value) in snapDict as! [String : String] {
                    if currentDate == value {
                        print("\(currentDate) date found in favorites")
                        completionHandler(true)
                        return
                    }
                }
                print("date not found in favorites")
                completionHandler(false)
            }
            else {
                print("snapshot does not exist, completion handler returns false")
                completionHandler(false)
            }
        })
    }
    
}
