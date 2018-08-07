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
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.checkIfFavoriteAlreadyExists(currentDate: currentEventDate!) { isExist in
            if isExist {
                let alert = Alerts.createAlert(title: "Event already favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
                let alert = Alerts.createAlert(title: "Event Favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    func checkIfFavoriteAlreadyExists(currentDate: String, completionHandler: @escaping(Bool) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let snapDict = snapshot.value as! NSDictionary
                for (_, value) in snapDict as! [String : String] {
                    if currentDate == value {
                        completionHandler(true)
                        return
                    }
                }
                completionHandler(false)
            }
            else {
                completionHandler(false)
            }
        })
    }
}
