//
//  SearchTableViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/23.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

  
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
