                                                    
//
//  ViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/17/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class LogInViewController: UIViewController {
    
    @IBOutlet weak var logInEmailTextField: UITextField!
    @IBOutlet weak var logInPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check if user already logged In
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "TabBarViaLogIn", sender: nil)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(LogInViewController.donePressed(sender:)))
        toolbar.setItems([flexible,doneButton,flexible], animated: true)
        logInEmailTextField.inputAccessoryView = toolbar
        logInPasswordTextField.inputAccessoryView = toolbar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*********************** Login pressed ***************************/
    @IBAction func logInButtonPressed(_ sender: Any) {
        view.endEditing(true)
        if(logInEmailTextField.text == "") {
            let alert = UIAlertController(title: "Enter email address", message: "Please enter your email address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if(logInPasswordTextField.text == "") {
            let alert = UIAlertController(title: "Enter password", message: "Please enter your password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else {
        ProgressHUD.show("Waiting....", interaction: false)
        Auth.auth().signIn(withEmail: logInEmailTextField.text!, password: logInPasswordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                ProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                ProgressHUD.showSuccess("Success")
                //print("Login Successful")
                self.performSegue(withIdentifier: "TabBarViaLogIn", sender: self)
            }
        }
    }
    }
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
    }
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

