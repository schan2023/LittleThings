//
//  Alerts.swift
//  LittleThings
//
//  Created by Simone Chan on 7/23/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

struct Alerts {
    
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        return alert
    }
}
