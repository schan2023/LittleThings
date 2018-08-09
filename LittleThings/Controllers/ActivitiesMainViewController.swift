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
    
    @IBOutlet weak var activitiesTitleLabel: UILabel!
    @IBOutlet weak var adviceButton: UIButton!
    @IBOutlet weak var kindnessButton: UIButton!
    @IBOutlet weak var complimentsButton: UIButton!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
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
    
    private func setConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        designView.snp.makeConstraints { (make) in
            let designViewHeight = screenHeight * 0.4076
            make.height.equalTo(designViewHeight)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(25)
            
        }
        
        activitiesTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(25)
            make.left.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            let stackViewHeight = screenHeight * 0.333
            make.height.equalTo(stackViewHeight)
            make.top.equalTo(designView.snp.bottom).offset(55)
            make.right.equalToSuperview().offset(82)
            make.left.equalToSuperview().offset(82)
            make.bottom.equalToSuperview().offset(72)
        }
        
        adviceButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.0747
            let btnWidth = screenWidth * 0.6039
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
        complimentsButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.0747
            let btnWidth = screenWidth * 0.6039
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
        kindnessButton.snp.makeConstraints { (make) in
            let btnHeight = screenHeight * 0.0747
            let btnWidth = screenWidth * 0.6039
            make.height.equalTo(btnHeight)
            make.width.equalTo(btnWidth)
        }
        
    }
    
}
