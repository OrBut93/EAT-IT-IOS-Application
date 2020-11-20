//
//  RecViewCell.swift
//  EAT-IT-Project
//
//  Created by admin on 07/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit

class RecViewCell: UITableViewCell {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
     
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
