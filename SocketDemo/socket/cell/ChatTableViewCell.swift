//
//  ChatTableViewCell.swift
//  SocketDemo
//
//  Created by Zimi on 2019/5/30.
//  Copyright © 2019 Zimi. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
   
    @IBOutlet weak var labelMessage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       labelName.adjustsFontSizeToFitWidth = true
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
