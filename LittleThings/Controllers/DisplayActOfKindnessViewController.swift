//
//  DisplayActOfKindnessViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 8/2/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayActOfKindnessViewController: UIViewController {
    
    var actsOfKindnessArray: [String] = [String]()
    var numOfActs: Int?
    var singleActOfKindness: String?
    
    @IBOutlet weak var actOfKindnessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateActOfKindness(completionHander: handleActOfKindnessArray)
    }
    
    func generateActOfKindness(completionHander: @escaping ([String], Int) -> Void) {
        
        let ref = Database.database().reference()
        ref.child("Kindness").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapDict = snapshot.value as? NSDictionary
            self.numOfActs = snapDict?.count
            for(_, value) in snapDict as! [String: String] {
                self.actsOfKindnessArray.append(value)
            }
            completionHander(self.actsOfKindnessArray, self.numOfActs!)
        })
        
    }
    
    func handleActOfKindnessArray(actsOfKindness: [String], numOfActs: Int) -> Void {
        print("array of kindness \(actsOfKindness)")
        print("numOfActs \(numOfActs)")
        
        let randomInt = Int(arc4random_uniform(UInt32(numOfActs-1)))
        
        print("displaying on label")
        actOfKindnessLabel.text = actsOfKindness[randomInt]
        singleActOfKindness = actsOfKindness[randomInt]
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        print(singleActOfKindness)
        CreateEvent().createEvent(eventDescription: singleActOfKindness!)
        
        let alert = Alerts.createAlert(title: "Event Saved!", message: "")
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
    }
    
    
    
}
