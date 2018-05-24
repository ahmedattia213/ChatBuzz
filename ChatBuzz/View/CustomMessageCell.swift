//
//  ChatViewController.swift
//  ChatBuzz
//
//  Created by Ahmed Amr on 5/16/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }


}

