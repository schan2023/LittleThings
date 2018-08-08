//
//  DisplayAdviceViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 8/6/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayAdviceViewController: UIViewController {
    
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var designCardView: UIView!
    @IBOutlet weak var designView: UIView!
    
    var advicesArray: [String] = [String]()
    var numOfAdvices: Int?
    var singleAdvice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixButtons(button: addButton)
        fixButtons(button: homeButton)
        generateAdvice(completionHander: handleAdvices)
        designView.layer.cornerRadius = 20
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
        designCardView.layer.cornerRadius = 10
        designCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designCardView.layer.shadowOpacity = Float(0.2)
    }
    
    func generateAdvice(completionHander: @escaping ([String], Int) -> Void) {
        
        let ref = Database.database().reference()
        ref.child("Advice").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapDict = snapshot.value as? NSDictionary
            self.numOfAdvices = snapDict?.count
            for(_, value) in snapDict as! [String: String] {
                self.advicesArray.append(value)
            }
            completionHander(self.advicesArray, self.numOfAdvices!)
        })
        
    }
    
    func handleAdvices(advices: [String], numOfAdvices: Int) -> Void {
        
        let randomInt = Int(arc4random_uniform(UInt32(numOfAdvices-1)))

        adviceLabel.text = advices[randomInt]
        singleAdvice = advices[randomInt]
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let adviceString = "Received advice: " + (singleAdvice)!
        CreateEvent().createEvent(eventDescription: adviceString)
        
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
