//
//  DisplayComplimentViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 8/2/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayComplimentViewController: UIViewController {
    
    @IBOutlet weak var complimentLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var designCardView: UIView!
    
    var complimentsArray: [String] = [String]()
    var numOfCompliments: Int?
    var singleCompliment: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixButtons(button: addButton)
        fixButtons(button: homeButton)
        generateCompliment(completionHander: handleCompliments)
        designCardView.layer.cornerRadius = 10
        designCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designCardView.layer.shadowOpacity = Float(0.2)
    }
    
    func generateCompliment(completionHander: @escaping ([String], Int) -> Void) {
        
        let ref = Database.database().reference()
        ref.child("Compliments").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapDict = snapshot.value as? NSDictionary
            self.numOfCompliments = snapDict?.count
            for(_, value) in snapDict as! [String: String] {
                self.complimentsArray.append(value)
            }
            completionHander(self.complimentsArray, self.numOfCompliments!)
        })
        
    }
    
    func handleCompliments(compliments: [String], numOfCompliments: Int) -> Void {
        print("array of compliments \(compliments)")
        print("numOfCompliments \(numOfCompliments)")
        
        let randomInt = Int(arc4random_uniform(UInt32(numOfCompliments-1)))
        
        print("displaying on label")
        complimentLabel.text = compliments[randomInt]
        singleCompliment = compliments[randomInt]
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let complimentString = "Received compliment: " + (singleCompliment)!
        CreateEvent().createEvent(eventDescription: complimentString)
        
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
