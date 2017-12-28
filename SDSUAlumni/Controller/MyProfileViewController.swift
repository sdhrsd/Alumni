                                                

//
//  MyProfileViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/17/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLeftLabel: UILabel!
    @IBOutlet weak var genderLeftLabel: UILabel!

    @IBOutlet weak var myProfileImage: UIImageView!
    var userReference = Database.database().reference().child("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDetail()
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /***************** Prepare for segue *********************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditMyProfileViewController {
            destination.name = nameLabel.text
            destination.degree = degreeLabel.text
            destination.college = collegeLabel.text
            destination.year = yearLabel.text
            destination.country = countryLabel.text
            destination.state = stateLabel.text
            destination.city = cityLabel.text
            if(myProfileImage.image != nil) {
            destination.editProfileImage = myProfileImage.image
            }
            if(addressLabel.text != "")
            {
                destination.address = addressLabel.text
            }
             if (genderLabel.text != "") {
                destination.gender = genderLabel.text
            }
        }
    }
    /*********************** Function for logout *************************************/
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainViewController")
            self.present(welcomeViewController, animated: true, completion: nil)
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    /********************* Function to load user details ***********************************/
    func loadUserDetail() {
        let id = Auth.auth().currentUser?.uid
        userReference.child(id!).observeSingleEvent(of: .value) { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                self.nameLabel.text = details["name"] as? String
                self.degreeLabel.text = details["degree"] as? String
                self.collegeLabel.text = details["college"] as? String
                self.countryLabel.text = details["country"] as? String
                self.stateLabel.text = details["state"] as? String
                self.yearLabel.text = details["year"] as? String
                self.cityLabel.text = details["city"] as? String
                self.emailLabel.text = details["email"] as? String
                if(details["address"] == nil) {
                    self.addressLabel.isHidden = true
                    self.addressLeftLabel.isHidden = true
                }
                else {
                    self.addressLabel.isHidden = false
                    self.addressLeftLabel.isHidden = false
                    self.addressLabel.text = details["address"] as? String
                }
                if(details["gender"] == nil) {
                    self.genderLabel.isHidden = true
                    self.genderLeftLabel.isHidden = true
                }
                else {
                    self.genderLabel.isHidden = false
                    self.genderLeftLabel.isHidden = false
                    self.genderLabel.text = details["gender"] as? String
                }
                if(details["profileImage"] == nil) {
                }
                else {
                    if let profileImageURL = details["profileImage"] {
                        self.myProfileImage.storeImage(urlProfile: profileImageURL as! String)
                    }
                }
            }
        }
    }
}
