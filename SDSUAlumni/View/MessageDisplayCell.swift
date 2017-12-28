                                                   /* Name : Hera Siddiqui
                                                    RedId: 819677411
                                                    Date: 12/24/2017 */
//
//  MessageDisplayCell.swift
//  SDSUAlumni
//
//  Created by Admin on 12/23/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase

class MessageDisplayCell: UITableViewCell {
    
    var userRef = Database.database().reference().child("users")
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatTimeLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!

    @IBOutlet weak var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func updateCellOfUser(userId:String) {
        userRef.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                self.chatNameLabel.text = details["name"] as? String
                 if let profileImageURL = details["profileImage"] {
                    self.chatImageView.storeImage(urlProfile: profileImageURL as! String)
                }
            }
        }
    }

}
