//
//  DisplayFavoritedDayViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/31/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class DisplayFavoritedDayViewController: UIViewController {
    
    var date: String?
    var favoritedEventsArray: [String] = [String]()
    
    @IBOutlet weak var favoritedEventDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        retrieveFavoritedEvent(completionHandler: handleFavoritesArrayCompletion)
        retrieveFavoritedEvent { (events) in
            self.favoritedEventsArray = events
            self.favoritedEventDateLabel.text = self.date
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        collectionView?.dataSource = self
        homeBtn.layer.cornerRadius = 10
        homeBtn.clipsToBounds = true
        setConstraints()
    }
    
    private func setConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        favoritedEventDateLabel.snp.makeConstraints { (make) in
            let eventDateHeight = screenHeight * 0.1644
            let eventDateWidth = screenWidth * 0.9106
            make.height.equalTo(eventDateHeight)
            make.width.equalTo(eventDateWidth)
            make.top.equalToSuperview().offset(49)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-17)
        }
        
//        lineView.snp.makeConstraints{ (make) in
//            let lineHeight = screenHeight * 0.00091
//            make.height.equalTo(lineHeight)
//            make.top.equalToSuperview().offset(91)
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.bottom.equalTo(collectionView).offset(53.33)
//        }
//
        collectionView.snp.makeConstraints { (make) in
            let collectionViewHeight = screenHeight * 0.468
            make.height.equalTo(collectionViewHeight)
            make.top.equalTo(lineView).offset(53.33)
            make.top.equalTo(favoritedEventDateLabel).offset(39)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        homeBtn.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.06114
            let btnWidth = screenWidth * 0.2899
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
//            make.bottom.equalToSuperview().offset(100)
//            make.left.equalToSuperview().offset(146)
//            make.right.equalToSuperview().offset(-146)
//            make.top.equalTo(collectionView).offset(32)
        }
        
    }
    
    func retrieveFavoritedEvent(completionHandler: @escaping ([String]) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child((user?.uid)!).child("EventDays").child(date!).observeSingleEvent(of: .value, with: { (snap) in
            let snapDict = snap.value as! NSDictionary
            for (key, value) in snapDict as! [String : String] {
                if key != "date" {
                    self.favoritedEventsArray.append(value)
                }
            }
            completionHandler(self.favoritedEventsArray)
        })
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension DisplayFavoritedDayViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritedEventsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "displayEventCell", for: indexPath) as! DisplayEventDayCollectionViewCell
        cell.eventDescriptionLabel.text = favoritedEventsArray[indexPath.item]
        
        return cell
    }
}
