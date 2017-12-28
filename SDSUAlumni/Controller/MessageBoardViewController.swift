                                               /* Name : Hera Siddiqui
                                                RedId: 819677411
                                                Date: 12/24/2017 */

//
//  MessageBoardViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/23/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase

class MessageBoardViewController: UIViewController, UITextFieldDelegate ,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var messageView: UIView!
    var messageRef = Database.database().reference().child("messages")
    var userRef = Database.database().reference().child("users")

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName:String?
    var userId:String?
    var userImage:String?
    var messageArray = [Message]()
    var storeIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        if(messageTextField.text == "") {
            sendButton.isEnabled = false
        }
        else {
            sendButton.isEnabled = true
        }
        loadUserDetails()
        retrieveMessages()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        messageTableView.rowHeight = 120
        NotificationCenter.default.addObserver(self, selector: #selector(MessageBoardViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageBoardViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /****************************Functions related to tableview **************************************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageDisplay") as? MessageDisplayCell {
            let message = messageArray[indexPath.row]
            let id = message.sendId
            cell.updateCellOfUser(userId: id)
            cell.chatNameLabel.text = message.sendName
            cell.messageTextView.text = message.sentMessage
            let seconds = message.timestamp
            let timestampDate = Date(timeIntervalSince1970: seconds)
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm:ss a"
            cell.chatTimeLabel.text = dateformatter.string(from: timestampDate)
            return cell
        } else {
            return MessageDisplayCell()
        }

    }
    /************************* Functions for moving the hidden textfields *********************************/
    /*https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    
   
    @IBAction func messageTextChanged(_ sender: Any) {
        if(messageTextField.text == "") {
            sendButton.isEnabled = false
        }
        else {
            sendButton.isEnabled = true
        }
    }
    /********************** Function to load current user details **********************************/
    func loadUserDetails() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        userRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                self.userName = details["name"] as? String
                if(details["profileImage"] == nil){
                } else {
                self.userImage = details["profileImage"] as? String
                }
            }
        }
    }
    
    /*********************************** Sending the message *******************************************/
    @IBAction func messageSendPressed(_ sender: Any) {
        view.endEditing(true)
        sendButton.isEnabled = false
        let childRef = messageRef.childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        guard let sentMessage = messageTextField.text,let senderName = userName,let senderId = userId else {return}
        
        var values = ["sendId":senderId,"sentMessage":sentMessage,"sendName":senderName,"timestamp":timestamp] as [String : Any]
        if(userImage != "") {
            values["profileImage"] = userImage
        }
        childRef.updateChildValues(values) { (error, ref) in
            if(error != nil) {
                print(error!)
                return
            }
        }
        messageTextField.text = ""
        messageTableView.reloadData()
    }
    /*********************Function To Retrieve the messages ***************************************************/
    func retrieveMessages() {
        messageRef.observe(.childAdded) { (snapshot) in
            if let details = snapshot.value as? [String:Any] {
                let sendName = details["sendName"] as? String
                let sendId = details["sendId"] as? String
                let message = details["sentMessage"] as? String
                let timestamp = details["timestamp"] as? Double
                let messageT = Message(sendName: sendName!, sendId: sendId!, timestamp: timestamp!, sentMessage: message!)
                self.messageArray.append(messageT)
                self.messageArray.sort(by: { (m1, m2) -> Bool in
                    return m1.timestamp < m2.timestamp
                     })
                  }
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
                self.messageTableView.scrollToLastCall(animated: false)

            }
            }
        }
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
    }
        
    }
/*************************** To load to the last Cell of Table View *************************************/
/* https://stackoverflow.com/questions/31308113/uitableview-indexpath-of-last-row */
extension UITableView {
    func scrollToLastCall(animated : Bool) {
        let lastSectionIndex = self.numberOfSections - 1
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
        self.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
    }
    
}
