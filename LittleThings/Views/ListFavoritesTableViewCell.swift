//
//  ListEventsTableViewCell.swift
//  LittleThings
//
//  Created by Simone Chan on 7/22/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit

class ListFavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        designView.layer.cornerRadius = 10
        designView.layer.shadowOffset = CGSize(width: 0, height: 3)
        designView.layer.shadowOpacity = Float(0.4)
    }
    
}
