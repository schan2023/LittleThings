//
//  MainViewController.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var generateEventButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        handleLogin()
        fixButtons(button: addEventButton)
        fixButtons(button: generateEventButton)
        fixButtons(button: activitiesButton)
        fixButtons(button: favoritesButton)
    }
    
    func handleLogin() {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    func fixButtons(button: UIButton) {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }
    
}

extension MainViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        print("handle user signup / login")
    }
}
