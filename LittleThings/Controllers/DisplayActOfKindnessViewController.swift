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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var designCardView: UIView!
    @IBOutlet weak var designView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixButtons(button: addButton)
        fixButtons(button: homeButton)
        generateActOfKindness(completionHander: handleActOfKindnessArray)
        designView.layer.cornerRadius = 20
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
        designCardView.layer.cornerRadius = 10
        designCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designCardView.layer.shadowOpacity = Float(0.2)
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
        let kindnessString = "Act of kindness: " + (singleActOfKindness)!
        CreateEvent().createEvent(eventDescription: kindnessString)
        
        let alert = Alerts.createAlert(title: "Event Saved!", message: "")
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
}
