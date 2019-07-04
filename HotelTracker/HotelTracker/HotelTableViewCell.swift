//
//  HotelTableViewCell.swift
//  HotelTracker
//
//  Created by Jennifer Cohen on 24/06/2019.
//  Copyright © 2019 Jennifer Cohen. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
