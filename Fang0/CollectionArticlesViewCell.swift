//
//  CollectionArticlesViewCell.swift
//  Fang0
//
//  Created by Chun Tie Lin on 2016/4/6.
//  Copyright © 2016年 TinaTien. All rights reserved.
//

import UIKit

class CollectionArticlesViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
