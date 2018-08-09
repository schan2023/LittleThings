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
    
    @IBOutlet weak var actOfKindnessTitleLabel: UILabel!
    @IBOutlet weak var actOfKindnessLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var designCardView: UIView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    private func setConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        designView.snp.makeConstraints { (make) in
            let designViewHeight = screenHeight * 0.3356
            make.height.equalTo(designViewHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(75)
            
        }
        
        actOfKindnessTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(58)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(64)
            make.left.equalToSuperview()
        }
        
        designCardView.snp.makeConstraints { (make) in
            make.top.equalTo(designView.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }
        
        actOfKindnessLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(30)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(designCardView.snp.bottom).offset(71)
            make.right.equalToSuperview().offset(-37)
            make.left.equalToSuperview().offset(37)
            make.bottom.equalToSuperview().offset(88)
        }
        
        addButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.06114
            let btnWidth = screenWidth * 0.2899
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
        homeButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.06114
            let btnWidth = screenWidth * 0.2899
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
    }
    
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
        setConstraints()
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
