//
//  CategoryTableViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
