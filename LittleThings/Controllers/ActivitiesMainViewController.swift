//
//  ActivitiesMainViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class ActivitiesMainViewController: UIViewController {
    
    @IBOutlet weak var adviceButton: UIButton!
    @IBOutlet weak var kindnessButton: UIButton!
    @IBOutlet weak var complimentsButton: UIButton!
    @IBOutlet weak var designView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixButtons(button: adviceButton)
        fixButtons(button: kindnessButton)
        fixButtons(button: complimentsButton)
        
        designView.layer.cornerRadius = 20
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
}
