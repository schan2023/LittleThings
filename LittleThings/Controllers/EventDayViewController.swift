//
//  EventDayViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class EventDayViewController: UIViewController {
    
    var currentEventsDay: [String]?
    var currentEventDate: String?
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var faveBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        collectionView?.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventDateLabel.text = currentEventDate
        fixButtons(button: faveBtn)
        fixButtons(button: homeBtn)
        
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func faveButtonPressed(_ sender: Any) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.checkIfFavoriteAlreadyExists(currentDate: currentEventDate!) { isExist in
            if isExist {
                let alert = Alerts.createAlert(title: "Event already favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                ref.child("users").child((user?.uid)!).child("Favorites").childByAutoId().setValue(self.currentEventDate)
                let alert = Alerts.createAlert(title: "Event Favorited!", message: "")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
    func checkIfFavoriteAlreadyExists(currentDate: String, completionHandler: @escaping(Bool) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let snapDict = snapshot.value as! NSDictionary
                for (_, value) in snapDict as! [String : String] {
                    if currentDate == value {
                        completionHandler(true)
                        return
                    }
                }
                completionHandler(false)
            }
            else {
                completionHandler(false)
            }
        })
    }
}

extension EventDayViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentEventsDay!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "displayEventCell", for: indexPath) as! DisplayEventDayCollectionViewCell
        cell.eventDescriptionLabel.text = currentEventsDay![indexPath.item]
        
        return cell
    }
}
