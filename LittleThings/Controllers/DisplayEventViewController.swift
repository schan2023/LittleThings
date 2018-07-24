//
//  DisplayEventViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class DisplayEventViewController: UIViewController {
    
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateEvent()
    }
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        generateEvent()
    }
    
    func generateEvent() -> Void {
        //Retrieve events from core data
        let eventsArray = CoreDataHelper.retrieveEvents()
        let num = eventsArray.count
        
        //Generate random number from 0 or array size
        let randomInt = Int(arc4random_uniform(UInt32(num)))
        
        //Set label as event description
        eventLabel.text = eventsArray[randomInt].eventDescription
        
        //Saves current event
        currentEvent = eventsArray[randomInt]
        
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
