//
//  DisplayFavoritedDayViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/31/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayFavoritedDayViewController: UIViewController {
    
    var date: String?
    var favoritedEventsArray: [String] = [String]()
    
    @IBOutlet weak var favoritedEventDateLabel: UILabel!
    @IBOutlet weak var favoritedEventsDayDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveFavoritedEvent(completionHandler: handleFavoritesArrayCompletion)
    }
    
    func retrieveFavoritedEvent(completionHandler: @escaping ([String]) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child((user?.uid)!).child("EventDays").child(date!).observeSingleEvent(of: .value, with: { (snap) in
            let snapDict = snap.value as! NSDictionary
            for (key, value) in snapDict as! [String : String] {
                if key != "date" {
                    self.favoritedEventsArray.append(value)
                }
            }
            completionHandler(self.favoritedEventsArray)
        })
    }

    func handleFavoritesArrayCompletion(favoritesArray: [String]) -> Void {
        let favoriteEventsString = favoritesArray.joined(separator: ", ")
        favoritedEventDateLabel.text = date
        favoritedEventsDayDisplayLabel.text = favoriteEventsString
    }
}
