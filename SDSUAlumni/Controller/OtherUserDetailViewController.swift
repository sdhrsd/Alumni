                                                       

//
//  OtherUserDetailViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/23/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase

class OtherUserDetailViewController: UIViewController {
    
    @IBOutlet weak var otherNameLabel: UILabel!
    @IBOutlet weak var otherDegreeLabel: UILabel!
    @IBOutlet weak var otherCollegeLabel: UILabel!
    @IBOutlet weak var otherYearLabel: UILabel!
    @IBOutlet weak var otherCountryLabel: UILabel!
    @IBOutlet weak var otherStateLabel: UILabel!
    @IBOutlet weak var otherCityLabel: UILabel!
    @IBOutlet weak var otherEmailLabel: UILabel!
    @IBOutlet weak var otherProfileImage: UIImageView!
    
    var userId:String?
    var ref = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(userId != "") {
            loadThisUser(userId: userId!)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /***********************Function to load tapped user ***************************************/
    func loadThisUser(userId:String) {
        ref.child(userId).observeSingleEvent(of: .value) { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                self.otherNameLabel.text = details["name"] as? String
                self.otherDegreeLabel.text = details["degree"] as? String
                self.otherCollegeLabel.text = details["college"] as? String
                self.otherCountryLabel.text = details["country"] as? String
                self.otherStateLabel.text = details["state"] as? String
                self.otherYearLabel.text = details["year"] as? String
                self.otherCityLabel.text = details["city"] as? String
                self.otherEmailLabel.text = details["email"] as? String
    
                if(details["profileImage"] == nil) {
                }
                else {
                    if let profileImageURL = details["profileImage"] {
                        self.otherProfileImage.storeImage(urlProfile: profileImageURL as! String)
                    }
                }
            }
        }
    }
}
