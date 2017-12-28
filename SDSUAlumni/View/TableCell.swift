                                                  /* Name : Hera Siddiqui
                                                   RedId: 819677411
                                                   Date: 12/24/2017 */
//
//  TableCell.swift
//  SDSUAlumni
//
//  Created by Admin on 12/22/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userDetailLabel2: UILabel!
    @IBOutlet weak var userDetailLabel1: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func updateCell(users:Users) {
        nameLabel.text = users.name
        userDetailLabel1.text = users.degree + " | " + users.college + " | " + users.year
        userDetailLabel2.text = users.country + " | " + users.state + " | " + users.city
        if let profileImageURL = users.profileImage {
            userImage.storeImage(urlProfile: profileImageURL)
       }
    }

}
