//
//  TreeInfoCell.swift
//  IOS
//
//  Created by admin on 6/26/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class TreeInfoCell: UITableViewCell {

    
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    //customised cell in the treeinfomation table
    func setup(cname: String, walkname: String, trailid: String)
    {
        leftLabel.text = cname
        middleLabel.text = walkname
        rightLabel.text = trailid
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
