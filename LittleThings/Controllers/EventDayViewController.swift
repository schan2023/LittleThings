//
//  EventDayViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class EventDayViewController: UIViewController {
    
    var currentEventsDay: [String]?
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventsDayDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayEventsByDay()
    }
    
    func displayEventsByDay() {
        print("inside event day view")
        let eventString = currentEventsDay?.joined(separator: ", ")
        print(eventString)
    }
    
}
