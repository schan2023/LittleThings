//
//  CreateEvent.swift
//  LittleThings
//
//  Created by Simone Chan on 8/2/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateEvent {
    
    var ref: DatabaseReference!
    
    public func createEvent(eventDescription: String) -> Void {
        let eventDate = convertDateFormatToString(date: Date())
        
        //Saves event to Firebase
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child((user?.uid)!).child("EventDays").child(eventDate).child("date").observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            if snapshot.exists() {
                print("Snapshot value exists: \(snapshot.value)")
                let snapValue = snapshot.value as! String
                if snapValue == eventDate {
                    print("Add events to current reference: EventDays->currentDate->event")
                    self.ref.child((user?.uid)!).child("EventDays").child(eventDate).childByAutoId().setValue(eventDescription)
                }
                else {
                    print("new item w/ index to first tree, add new node to EventDays->currentDate")
                    self.ref.child((user?.uid)!).child("EventDays").child(eventDate).child("date").setValue(eventDate)
                    self.updateEventDays(user: user, id: eventDate)
                }
            }
            else {
                print("Snapshot value does not exist, new item w/ index to first tree, add new node to EventDays->currentDate")
                self.ref.child((user?.uid)!).child("EventDays").child(eventDate).child("date").setValue(eventDate)
                self.ref.child((user?.uid)!).child("EventDays").child(eventDate).childByAutoId().setValue(eventDescription)
                self.updateEventDays(user: user, id: eventDate)
            }
            
        })
        
    }
    
    func convertDateFormatToString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateformatter.string(from: Date())
        
        return dateString
    }
    
    func updateEventDays(user: User?, id: String) {
        //happens with every new date
        ref.child("users").child((user?.uid)!).child("numOfEvents").observeSingleEvent(of: .value, with: {(Snap) in
            if Snap.exists(){
                let num = Snap.value as! Int
                self.ref.child("users").child((user?.uid)!).child("EventDaysKeys").child(String(num+1)).setValue(id)
                self.ref.child("users").child((user?.uid)!).child("numOfEvents").setValue(num + 1)
            } else {
                self.ref.child("users").child((user?.uid)!).child("EventDaysKeys").child(String(1)).setValue(id)
                self.ref.child("users").child((user?.uid)!).child("numOfEvents").setValue(1)
            }
        })
    }
}
