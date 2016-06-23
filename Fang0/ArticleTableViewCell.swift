//
//  ArticleTableViewCell.swift
//  Fang0
//
//  Created by TinaTien on 2015/12/20.
//  Copyright © 2015年 TinaTien. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

//    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
