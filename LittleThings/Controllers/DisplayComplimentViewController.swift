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
import SnapKit

class DisplayComplimentViewController: UIViewController {
    
    @IBOutlet weak var complimentTitleLabel: UILabel!
    @IBOutlet weak var complimentLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var designCardView: UIView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    var complimentsArray: [String] = [String]()
    var numOfCompliments: Int?
    var singleCompliment: String?
    
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
        
        complimentTitleLabel.snp.makeConstraints { (make) in
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
        
        complimentLabel.snp.makeConstraints { (make) in
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
        generateCompliment(completionHander: handleCompliments)
        designView.layer.cornerRadius = 20
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
        designCardView.layer.cornerRadius = 10
        designCardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designCardView.layer.shadowOpacity = Float(0.2)
        setConstraints()
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
        let randomInt = Int(arc4random_uniform(UInt32(numOfCompliments-1)))
        
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
