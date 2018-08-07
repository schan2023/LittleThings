//
//  DisplayEventDayCollectionViewCell.swift
//  LittleThings
//
//  Created by Simone Chan on 8/7/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class DisplayEventDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var designView: UIView!
    
    override func layoutSubviews() {
        designView.layer.cornerRadius = 10
        designView.layer.shadowOffset = CGSize(width: 0, height: 1)
        designView.layer.shadowOpacity = Float(0.2)
    }
    
}
