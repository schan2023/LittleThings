//
//  DisplayEventViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class DisplayEventViewController: UIViewController {
    
    
    @IBOutlet weak var reflectTitleLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var goToDayButton: UIButton!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var designCardsView: UIView!
    @IBOutlet weak var reflectTitleView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var eventLabel: UILabel!
    
    var arrayOfEvents: [String] = [String]()
    var currentDate: String?
    
    private func setConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        reflectTitleView.snp.makeConstraints { (make) in
            let designViewHeight = screenHeight * 0.3356
            make.height.equalTo(designViewHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(75)
            
        }
        
        reflectTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(58)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(75)
            make.left.equalToSuperview()
        }
        
        eventDateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(120)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        designCardsView.snp.makeConstraints { (make) in
            make.top.equalTo(reflectTitleView.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }
        
        eventLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(30)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(designCardsView.snp.bottom).offset(71)
            make.right.equalToSuperview().offset(-37)
            make.left.equalToSuperview().offset(37)
            make.bottom.equalToSuperview().offset(88)
        }
        
        generateButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.06114
            let btnWidth = screenWidth * 0.2899
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }

        goToDayButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.06114
            let btnWidth = screenWidth * 0.2899
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixButtons(button: generateButton)
        fixButtons(button: goToDayButton)
        formatCards()
        reflectTitleView.layer.cornerRadius = 15
        reflectTitleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        reflectTitleView.layer.shadowOpacity = Float(0.5)
        generateEvent(completionHandler: handleArrayOfEventsCompletion)
    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        print("generate button tapped!")
        arrayOfEvents.removeAll()
        generateEvent(completionHandler: handleArrayOfEventsCompletion)
    }
    
    func generateEvent(completionHandler: @escaping ([String], String) -> Void) -> Void {
        
        //Get snapshot of user.uid
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //get numOfEvents
            let numOfEvents = value!["numOfEvents"] as? UInt32
            
            //random number
            let randNum = Int(arc4random_uniform(UInt32(numOfEvents!))) + 1
            
            //Get value of specific day
            let foundDateArray = value!["EventDaysKeys"] as? NSArray
            let foundDate = foundDateArray![randNum] as! String
            
            //Get snapshot of EventDays.foundDate
            ref.child((user?.uid)!).child("EventDays").child(foundDate).observeSingleEvent(of: .value, with: { (snap) in
                let snapDict = snap.value as! NSDictionary
                for (key, value) in snapDict as! [String : String] {
                    if key != "date" {
                        self.arrayOfEvents.append(value)
                    }
                    else {
                        self.currentDate = value
                    }
                }
                completionHandler(self.arrayOfEvents, self.currentDate!)
            })
        })
        
    }
    
    func handleArrayOfEventsCompletion(arrayOfEventsList: [String], currentDateVar: String) -> Void {
        arrayOfEvents = arrayOfEventsList
        currentDate = currentDateVar
        //generate random event
        returnRandomEvent(eventsArray: arrayOfEvents)
    }
    
    func returnRandomEvent(eventsArray: [String]) -> Void {
        let num = eventsArray.count

        //Generate random number from 0 or array size
        let randomInt = Int(arc4random_uniform(UInt32(num)))

        //Set label as event description
        eventLabel.text = eventsArray[randomInt]
        eventDateLabel.text = self.currentDate
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    func formatCards() {
        designCardsView.layer.cornerRadius = 10
        designCardsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designCardsView.layer.shadowOpacity = Float(0.2)
    }
    
    //Use segue identifier to go to day function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayEventDay":
            print("inside display event day segue")
            let destination = segue.destination as! EventDayViewController
            destination.currentEventsDay = arrayOfEvents
            destination.currentEventDate = currentDate
            
        default:
            print("unexpected segue identifier")
        }
    }
}
