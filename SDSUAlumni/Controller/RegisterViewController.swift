                                                /* Name : Hera Siddiqui
                                                 RedId: 819677411
                                                 Date: 12/24/2017 */

//
//  RegisterViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/17/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ProgressHUD

class RegisterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var regEmailTextField: UITextField!
    @IBOutlet weak var regPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var country1TextField : UITextField!
    @IBOutlet weak var stateTextField : UITextField!
    @IBOutlet weak var cityTextField : UITextField!

    
    var degreeArray: Array<String>?
    var degreeSelected: String?
    var collegeArray: Array<String>?
    var collegeSelected: String?
    var yearArray: Array<String>?
    var yearSelected: String?
    var country1Array: Array<String>?
    var country1Selected: String?
    var stateArray: Array<String>?
    var stateSelected: String?
    let geoCoder = CLGeocoder()
    var country1Index = "0"
    
    
    var degreePickerView = UIPickerView()
    var collegePickerView = UIPickerView()
    var yearPickerView = UIPickerView()
    var country1PickerView = UIPickerView()
    var statePickerView = UIPickerView()
    
    var ref:DatabaseReference? = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        degreeTextField.inputView = degreePickerView
        degreePickerView.delegate = self
        degreePickerView.tag = 1
        collegeTextField.inputView = collegePickerView
        collegePickerView.delegate = self
        collegePickerView.tag = 2
        yearTextField.inputView = yearPickerView
        yearPickerView.delegate = self
        yearPickerView.tag = 3
        country1TextField.inputView = country1PickerView
        country1PickerView.delegate = self
        country1PickerView.tag = 4
        stateTextField.inputView = statePickerView
        statePickerView.delegate = self
        statePickerView.tag = 5
        
        
        /********************* Loading Degree ***************************/
        let data1:Bundle = Bundle.main
        let degreePlist:String? = data1.path(forResource: "Degree", ofType: "plist")
        if degreePlist != nil {
            degreeArray = (NSArray.init(contentsOfFile: degreePlist!) as! Array)
            degreeTextField.text = degreeArray?.first
            degreeSelected = degreeArray!.first
        }
        
        /********************* Loading College ***************************/
        let data2:Bundle = Bundle.main
        let collegePlist:String? = data2.path(forResource: "College", ofType: "plist")
        if collegePlist != nil {
            collegeArray = (NSArray.init(contentsOfFile: collegePlist!) as! Array)
            collegeTextField.text = collegeArray?.first
            collegeSelected = collegeArray!.first
        }
        /********************** Loading Year **********************/
        let data3:Bundle = Bundle.main
        let yearPlist:String? = data3.path(forResource: "Year", ofType: "plist")
        if  yearPlist != nil {
            yearArray = (NSArray.init(contentsOfFile: yearPlist!) as! Array)
            yearArray = yearArray?.sorted(by:>)
            yearTextField.text = yearArray?.first
            yearSelected = yearArray!.first
        }
        
        /********************** Loading Countries *******************************/
        loadTheCountries(completion:  { success in
            if success {
                self.country1TextField.text = self.country1Array?.first
            }
        })
        /*********************** Loading States *****************************/
        loadTheStates(completion:  { success in
            if success {
                self.stateTextField.text = self.stateArray?.first
            }
        })
        
        /************************* Adding a done button when UIPicker pops up *************************/
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(RegisterViewController.donePressed(sender:)))
        toolbar.setItems([flexible,doneButton,flexible], animated: true)
        degreeTextField.inputAccessoryView = toolbar
        collegeTextField.inputAccessoryView = toolbar
        yearTextField.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
        regEmailTextField.inputAccessoryView = toolbar
        regPasswordTextField.inputAccessoryView = toolbar
        country1TextField.inputAccessoryView = toolbar
        stateTextField.inputAccessoryView = toolbar
        cityTextField.inputAccessoryView = toolbar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
    }
    
    /****************** PickerView related Functions ************************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            guard (degreeArray != nil) else {
                return 0
            }
            return (degreeArray?.count)!
        }
        else if pickerView.tag == 2 {
            guard (collegeArray != nil) else {
                return 0
            }
            return (collegeArray?.count)!
        }
        else if pickerView.tag == 3 {
            guard (yearArray != nil) else {
                return 0
            }
            return (yearArray?.count)!
        }
        else if pickerView.tag == 4 {
            guard (country1Array != nil) else {
                return 0
            }
            return (country1Array?.count)!
        }
        else if pickerView.tag == 5 {
            guard (stateArray != nil) else {
                return 0
            }
            return (stateArray?.count)!
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            guard(degreeArray != nil) else {
                return nil
            }
            return degreeArray?[row]
        }
        else if pickerView.tag == 2 {
            guard(collegeArray != nil) else {
                return nil
            }
            return collegeArray?[row]
        }
        else if pickerView.tag == 3 {
            guard(yearArray != nil) else {
                return nil
            }
            return yearArray?[row]
        }
        else if pickerView.tag == 4 {
            guard(country1Array != nil) else {
                return nil
            }
            return country1Array?[row]
        }
        else if pickerView.tag == 5 {
            guard(stateArray != nil) else {
                return nil
            }
            return stateArray?[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            degreeTextField.text = degreeArray?[row]
        }
        else if pickerView.tag == 2 {
            collegeTextField.text = collegeArray?[row]
        }
        else if pickerView.tag == 3 {
            yearTextField.text = yearArray?[row]
        }
        else if pickerView.tag == 4 {
            country1Index = "\(row)"
            country1TextField.text = country1Array?[row]
            country1Selected = country1TextField.text
            loadTheStates(completion:  { success in
                if success {
                    self.stateTextField.text = self.stateArray?.first
                }
            })
        }
        else if pickerView.tag == 5 {
            stateTextField.text = stateArray?[row]
        }
    }
/*************************** Picker View related functions end here ***************************************/
    
    /************************** Function to register user ************************************/
    @IBAction func registerButtonPressed(_ sender: Any) {
        if(regEmailTextField.text == "") {
            let alert = UIAlertController(title: "Enter email address", message: "Please enter your email address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if(regPasswordTextField.text == "") {
            let alert = UIAlertController(title: "Enter password", message: "Please enter a password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if(nameTextField.text == "") {
            let alert = UIAlertController(title: "Enter Your Name", message: "Please enter your Name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if(cityTextField.text == "") {
            let alert = UIAlertController(title: "Enter Your City", message: "Please enter a City ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            var values = [String:Any]()
            let address = cityTextField.text! + " " + stateTextField.text! + " " + country1TextField.text!
            
            forwardGeocoding(address:address ,completion: {success, coordinate in
                if success {
                    let coordinate1 = coordinate
                    let lat = coordinate1?.latitude
                    let lon = coordinate1?.longitude
                    values = ["email": self.regEmailTextField.text!,"name": self.nameTextField.text!,"degree": self.degreeTextField.text!,"college":self.collegeTextField.text!,"year": self.yearTextField.text!,"country" : self.country1TextField.text!,"state": self.stateTextField.text!,"city": self.cityTextField.text!,"latitude" : lat!,"longitude": lon!]
                    self.submitData(values: values)
                }
                else {
                    values = ["email": self.regEmailTextField.text!,"name": self.nameTextField.text!,"degree": self.degreeTextField.text!,"college":self.collegeTextField.text!,"year": self.yearTextField.text!,"country" : self.country1TextField.text!,"state": self.stateTextField.text!,"city": self.cityTextField.text!,"latitude" : 0.0,"longitude": 0.0]
                        self.submitData(values: values)
                }
            })
        }
    }
    
    @IBAction func alreadyHaveAccountPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*********************** Function to geocode an address ********************************/
    func forwardGeocoding (address: String, completion: @escaping (Bool, CLLocationCoordinate2D?) -> () ) {
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                completion(false,nil)
                return
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                completion(true, coordinates)
            }
        })
    }
    /******************** Function to submit user data ************************************/
    func submitData(values:[String:Any]) {
        var values = values
        ProgressHUD.show("Waiting....", interaction: false)
        Auth.auth().createUser(withEmail: regEmailTextField.text!, password: regPasswordTextField.text!) {
            (user, error) in
            if error != nil {
                ProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                guard let id = user?.uid else {
                    return
                }
                values["id"] = id
                let userReference = self.ref?.child("users").child(id)
                userReference?.updateChildValues(values, withCompletionBlock: {
                    (error,ref) in
                    if(error != nil) {
                        return
                    }
                    ProgressHUD.showSuccess("Success")
                    self.performSegue(withIdentifier: "TabBarViaRegistration", sender: self)
                })
            }
        }
    }
    
    /********************** Function to load countries **********************************/
    func loadTheCountries(completion: @escaping (Bool) -> Void)  {
        var countries = [String]()
        ref?.child("countries").observe(.childAdded, with: {  (snapshot) in
            if let country = snapshot.value as? [String:Any] {
                if let country1 = country["country"] as? String {
                    countries.append(country1)
                }
            }
            self.country1Array = countries
            completion(true)
        })
        
    }
    /********************* Function to load States *****************************************/
    func loadTheStates(completion: @escaping (Bool) -> Void)  {
        var states = [String]()
        let countryRef = ref?.child("countries")
        countryRef?.child(country1Index).observeSingleEvent(of:.value, with: {  (snapshot) in
            if let country = snapshot.value as? [String:Any] {
                if let country1 = country["states"] as? Array<String> {
                    states = country1
                }
            }
            self.stateArray = states
            completion(true)
        })
        
    }
}
