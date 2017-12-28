                                                /* Name : Hera Siddiqui
                                                 RedId: 819677411
                                                 Date: 12/24/2017 */

//
//  AllUsersViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/23/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase

class AllUsersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tables = [Users]()
    var userRef = Database.database().reference().child("users")
    var myId: String?
    var myName:String?
    
    override func viewDidLoad() {
        myId = Auth.auth().currentUser?.uid
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        loadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /****************************Functions related to tableview **************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersCell") as? TableCell {
            let user = tables[indexPath.row]
            cell.updateCell(users: user)
            return cell
        } else {
            return TableCell()
        }
    }
    /*************************** Function to load the users ****************************************/
    func loadUsers() {
        userRef.observe(.childAdded, with: { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                guard let name = details["name"] as? String,
                    let degree = details["degree"] as? String,
                    let college = details["college"] as? String,
                    let country = details["country"] as? String,
                    let state = details["state"] as? String,
                    let year = details["year"] as? String,
                    let city = details["city"] as? String,
                    //let email = details["email"] as? String
                    let id = details["id"] as? String else {return}
                var user = Users(name: name, degree: degree, college: college, city: city, state: state, year: year, country: country, id: id)
                if let image = details["profileImage"] as? String {
                    user.profileImage = image
                }
                if(self.myId != id) {
                    self.tables.append(user)
                    self.tables.sort(by: { (user1, user2) -> Bool in
                        return user1.name < user2.name
                    })
                }
                else {
                    self.myName = name
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /************************ Overriding segue function *************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
            if let destination = segue.destination as? OtherUserDetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let user = tables[indexPath.row]
                destination.userId = user.id
            }
            
        else {
            //print("Nottriggered again")
        }
    }
    
}
