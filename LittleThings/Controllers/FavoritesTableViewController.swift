//
//  FavoritesTableViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/30/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class FavoritesTableViewController: UITableViewController {
    
    var favoriteDates = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveFavoritesDates(completionHandler: handleRetrieveFavorites)
    }
    
    func retrieveFavoritesDates(completionHandler: @escaping ([String]) -> Void) {
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("users").child((user?.uid)!).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapDict = snapshot.value as! NSDictionary
            for (_, value) in snapDict as! [String : String] {
                self.favoriteDates.append(value)
            }
        completionHandler(self.favoriteDates)
        })
    }
    
    func handleRetrieveFavorites(dates: [String]) -> Void {
        favoriteDates = dates
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return favoriteDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listFavoritesTableViewCell", for: indexPath) as! ListFavoritesTableViewCell
        
        let date = favoriteDates[indexPath.row]
        cell.dateLabel.text = date
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "displayFavoritesDay":

            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let date = favoriteDates[indexPath.row]
            let destination = segue.destination as! DisplayFavoritedDayViewController
            destination.date = date

        default:
            print("unexpected segue identifier")
        }
    }
    
}
