                                        /* Name : Hera Siddiqui
                                           RedId: 819677411
                                           Date: 12/24/2017 */


//
//  EditMyProfileViewController.swift
//  SDSUAlumni
//
//  Created by Admin on 12/19/17.
//  Copyright © 2017 Hera Siddiqui. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ProgressHUD

class EditMyProfileViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editDegreeTextField: UITextField!
    @IBOutlet weak var editYearTextField: UITextField!
    @IBOutlet weak var editCountryTextField: UITextField!
    @IBOutlet weak var editStateTextField: UITextField!
    @IBOutlet weak var editCityTextField: UITextField!
    @IBOutlet weak var editAddressTextField: UITextField!
    @IBOutlet weak var editGenderTextField: UITextField!
    @IBOutlet weak var editCollegeTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var editDegreeArray: Array<String>?
    var editDegreeSelected: String?
    var editCollegeArray: Array<String>?
    var editCollegeSelected: String?
    var editYearArray: Array<String>?
    var editYearSelected: String?
    var editCountryArray: Array<String>?
    var editCountry1Selected: String?
    var editStateArray: Array<String>?
    var editStateSelected: String?
    var editGenderArray: Array<String>?
    var editGenderSelected: String?
    var editProfileImage: UIImage?
    let geoCoder = CLGeocoder()
    
    
    var name: String?
    var degree: String?
    var college :String?
    var year: String?
    var country: String?
    var state:String?
    var city: String?
    var address : String?
    var gender: String?
    var countryIndex: String?
    var stateIndex: String?
    var degreeIndex: String?
    var collegeIndex: String?
    var yearIndex: String?
    
    var editDegreePickerView = UIPickerView()
    var editCollegePickerView = UIPickerView()
    var editYearPickerView = UIPickerView()
    var editCountryPickerView = UIPickerView()
    var editStatePickerView = UIPickerView()
    var editGenderPickerView = UIPickerView()

    
    var ref:DatabaseReference? = Database.database().reference()
    var storageRef = Storage.storage().reference().child("userProfileImage")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        if(editProfileImage != nil) {
        profileImage.image = editProfileImage
        }
        editNameTextField.text = name!
        editCityTextField.text = city!
        if(address != nil) {
            editAddressTextField.text = address!
        }
        
        editDegreeTextField.inputView = editDegreePickerView
        editDegreePickerView.delegate = self
        editDegreePickerView.tag = 1
        editCollegeTextField.inputView = editCollegePickerView
        editCollegePickerView.delegate = self
        editCollegePickerView.tag = 2
        editYearTextField.inputView = editYearPickerView
        editYearPickerView.delegate = self
        editYearPickerView.tag = 3
        editCountryTextField.inputView = editCountryPickerView
        editCountryPickerView.delegate = self
        editCountryPickerView.tag = 4
        editStateTextField.inputView = editStatePickerView
        editStatePickerView.delegate = self
        editStatePickerView.tag = 5
        editGenderTextField.inputView = editGenderPickerView
        editGenderPickerView.delegate = self
        editGenderPickerView.tag = 6
        
        
        /********************* Loading Degree ***************************/
        let data1:Bundle = Bundle.main
        let degreePlist:String? = data1.path(forResource: "Degree", ofType: "plist")
        if degreePlist != nil {
            editDegreeArray = (NSArray.init(contentsOfFile: degreePlist!) as! Array)
            if(degree != nil){
                if let passedDegreeIndex = editDegreeArray?.index(of: degree!) {
                editDegreeTextField.text = editDegreeArray?[passedDegreeIndex]
                    editDegreePickerView.selectRow(passedDegreeIndex, inComponent: 0, animated: false)
            }
        }
    }
        
        /********************* Loading College ***************************/
        let data2:Bundle = Bundle.main
        let collegePlist:String? = data2.path(forResource: "College", ofType: "plist")
        if collegePlist != nil {
            editCollegeArray = (NSArray.init(contentsOfFile: collegePlist!) as! Array)
            if(college != nil){
                if let passedCollegeIndex = editCollegeArray?.index(of: college!) {
                    editCollegeTextField.text = editCollegeArray?[passedCollegeIndex]
                    editCollegePickerView.selectRow(passedCollegeIndex, inComponent: 0, animated: false)
                    
                }
            }
        }
        
        /********************** Loading Year **********************/
        let data3:Bundle = Bundle.main
        let yearPlist:String? = data3.path(forResource: "Year", ofType: "plist")
        if  yearPlist != nil {
            editYearArray = (NSArray.init(contentsOfFile: yearPlist!) as! Array)
            if(year != nil){
                if let passedYearIndex = editYearArray?.index(of: year!) {
                    editYearTextField.text = editYearArray?[passedYearIndex]
                    editYearPickerView.selectRow(passedYearIndex, inComponent: 0, animated: false)
                }
            }
        }
        /********************** Loading Gender **********************/
        let data4:Bundle = Bundle.main
        let genderPlist:String? = data4.path(forResource: "Gender", ofType: "plist")
        if  genderPlist != nil {
            editGenderArray = (NSArray.init(contentsOfFile: genderPlist!) as! Array)
            if(gender != nil){
                if let passedGenderIndex = editGenderArray?.index(of: gender!) {
                    editGenderTextField.text = editGenderArray?[passedGenderIndex]
                    editGenderPickerView.selectRow(passedGenderIndex, inComponent: 0, animated: false)
                }
                else {
                    editGenderTextField.text = editGenderArray?.first
                }
            }
            else {
                editGenderTextField.text = editGenderArray?.first
            }
        }
        /********************** Loading Countries *******************************/
        loadTheCountries(completion:  { success in
            if success {
                if(self.country != nil){
                    if let passedCountryIndex = self.editCountryArray?.index(of: self.country!) {
                        self.countryIndex = String(passedCountryIndex)
                        self.editCountryTextField.text = self.editCountryArray?[passedCountryIndex]
                        self.editCountryPickerView.selectRow(passedCountryIndex, inComponent: 0, animated: false)
                        self.loadTheStates(completion:  { success in
                            if success {
                                if(self.state != nil){
                                    if let passedStateIndex = self.editStateArray?.index(of: self.state!) {
                                        self.stateIndex = "\(passedStateIndex)"
                                        self.editStateTextField.text = self.editStateArray?[passedStateIndex]
                                        self.editStatePickerView.selectRow(passedStateIndex, inComponent: 0, animated: false)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
        
        /************************* Adding a done button when UIPicker pops up *************************/
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EditMyProfileViewController.donePressed(sender:)))
        toolbar.setItems([flexible,doneButton,flexible], animated: true)
        editDegreeTextField.inputAccessoryView = toolbar
        editCollegeTextField.inputAccessoryView = toolbar
        editYearTextField.inputAccessoryView = toolbar
        editNameTextField.inputAccessoryView = toolbar
        editCountryTextField.inputAccessoryView = toolbar
        editStateTextField.inputAccessoryView = toolbar
        editCityTextField.inputAccessoryView = toolbar
        editGenderTextField.inputAccessoryView = toolbar
        editAddressTextField.inputAccessoryView = toolbar


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func donePressed(sender:UIBarButtonItem) {
        view.endEditing(true)
    }
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
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
    /****************** PickerView related Functions ************************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            guard (editDegreeArray != nil) else {
                return 0
            }
            return (editDegreeArray?.count)!
        }
        else if pickerView.tag == 2 {
            guard (editCollegeArray != nil) else {
                return 0
            }
            return (editCollegeArray?.count)!
        }
        else if pickerView.tag == 3 {
            guard (editYearArray != nil) else {
                return 0
            }
            return (editYearArray?.count)!
        }
        else if pickerView.tag == 4 {
            guard (editCountryArray != nil) else {
                return 0
            }
            return (editCountryArray?.count)!
        }
        else if pickerView.tag == 5 {
            guard (editStateArray != nil) else {
                return 0
            }
            return (editStateArray?.count)!
        }
        else if pickerView.tag == 6 {
            guard (editGenderArray != nil) else {
                return 0
            }
            return (editGenderArray?.count)!
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            guard(editDegreeArray != nil) else {
                return nil
            }
            return editDegreeArray?[row]
        }
        else if pickerView.tag == 2 {
            guard(editCollegeArray != nil) else {
                return nil
            }
            return editCollegeArray?[row]
        }
        else if pickerView.tag == 3 {
            guard(editYearArray != nil) else {
                return nil
            }
            return editYearArray?[row]
        }
        else if pickerView.tag == 4 {
            guard(editCountryArray != nil) else {
                return nil
            }
            return editCountryArray?[row]
        }
        else if pickerView.tag == 5 {
            guard(editStateArray != nil) else {
                return nil
            }
            return editStateArray?[row]
        }
        else if pickerView.tag == 6 {
            guard(editGenderArray != nil) else {
                return nil
            }
            return editGenderArray?[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            editDegreeTextField.text = editDegreeArray?[row]
        }
        else if pickerView.tag == 2 {
            editCollegeTextField.text = editCollegeArray?[row]
        }
        else if pickerView.tag == 3 {
            editYearTextField.text = editYearArray?[row]
        }
        else if pickerView.tag == 4 {
            countryIndex = "\(row)"
            editCountryTextField.text = editCountryArray?[row]
            //countrySelected = editCountryTextField.text
            country = editCountryTextField.text
            loadTheStates(completion:  { success in
                if success {
                    self.editStateTextField.text = self.editStateArray?.first
                }
            })
            
        }
        else if pickerView.tag == 5 {
            editStateTextField.text = editStateArray?[row]
        }
        else if pickerView.tag == 6 {
            editGenderTextField.text = editGenderArray?[row]
        }
    }
    /*************************** Picker View related functions end here ***************************************/
    
    /********************** Function to load countries **********************************/
    func loadTheCountries(completion: @escaping (Bool) -> Void)  {
        var countries = [String]()
        ref?.child("countries").observe(.childAdded, with: {  (snapshot) in
            if let country = snapshot.value as? [String:Any] {
                if let country1 = country["country"] as? String {
                    countries.append(country1)
                }
            }
            self.editCountryArray = countries
            completion(true)
        })
        
    }
    /********************* Function to load States *****************************************/
    func loadTheStates(completion: @escaping (Bool) -> Void)  {
        var states = [String]()
        let countryRef = ref?.child("countries")
        if let index = self.editCountryArray?.index(of: self.country!) {
            countryIndex = "\(index)"
            countryRef?.child(countryIndex!).observeSingleEvent(of:.value, with: {  (snapshot) in
            if let country = snapshot.value as? [String:Any] {
                if let country1 = country["states"] as? Array<String> {
                    states = country1
                }
            }
            self.editStateArray = states
            completion(true)
        })
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
            if(editNameTextField.text == "") {
            let alert = UIAlertController(title: "Enter Your Name", message: "Please enter your Name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if(editCityTextField.text == "") {
            let alert = UIAlertController(title: "Enter Your City", message: "Please enter a City ", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
            else {
                var values = [String:Any]()
                let address = editCityTextField.text! + " " + editStateTextField.text! + " " + editCountryTextField.text!
                
                forwardGeocoding(address:address ,completion: {success, coordinate in
                    if success {
                        let coordinate1 = coordinate
                        let lat = coordinate1?.latitude
                        let lon = coordinate1?.longitude
                        values = ["name": self.editNameTextField.text!,"degree": self.editDegreeTextField.text!,"college":self.editCollegeTextField.text!,"year": self.editYearTextField.text!,"country" : self.editCountryTextField.text!,"state": self.editStateTextField.text!,"city": self.editCityTextField.text!,"latitude" : lat!,"longitude": lon!]
                        if(self.editGenderTextField.text != "Select Gender") {
                            values["gender"] = self.editGenderTextField.text
                        }
                        else {
                            values["gender"] = " "
                        }
                        if(self.editAddressTextField.text != "") {
                            values["address"] = self.editAddressTextField.text
                        }
                        else {
                            values["address"] = " "
                        }
                        self.submitData(values: values)
                    }
                    else {
                        values = ["name": self.editNameTextField.text!,"degree": self.editDegreeTextField.text!,"college":self.editCollegeTextField.text!,"year": self.editYearTextField.text!,"country" : self.editCountryTextField.text!,"state": self.editStateTextField.text!,"city": self.editCityTextField.text!,"latitude" : 0.0,"longitude": 0.0]
                        if(self.editGenderTextField.text != "Select Gender") {
                            values["gender"] = self.editGenderTextField.text
                        }
                        if(self.editAddressTextField.text != "") {
                            values["address"] = self.editAddressTextField.text
                        }
                        self.submitData(values: values)
                    }
                })
        }
        
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
    /********************* Function to edit submitted data ***********************************/
    func submitData(values:[String:Any]) {
        ProgressHUD.show("Waiting...", interaction: false)
        var values = values
        guard let id = Auth.auth().currentUser?.uid else {
        return
    }
        let imageStorageRef = storageRef.child("\(id).jpg")
        if (editProfileImage != nil) {
            if let uploadImage = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) {
                imageStorageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                    if(error != nil) {
                        return
                    }
                    else {
                        let userReference = self.ref?.child("users").child(id)
                        if let imageURL = metadata?.downloadURL()?.absoluteURL{
                            values["profileImage"] = "\(imageURL)"
                            userReference?.updateChildValues(values, withCompletionBlock: {
                                (error,ref) in
                                if(error != nil) {
                                    return
                                }
                                ProgressHUD.showSuccess("Success")
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                        }
                    })
                }
            }
        else {
            //upload just values code
             let userReference = self.ref?.child("users").child(id)
            userReference?.updateChildValues(values, withCompletionBlock: {
                (error,ref) in
                if(error != nil) {
                 return
             }
             ProgressHUD.showSuccess("Success")
             self.dismiss(animated: true, completion: nil)
             })
        
        }
        
    }
    /************************** Function to add or change image *************************************/
    @IBAction func addOrChangeImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker,animated:true,completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            editProfileImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            editProfileImage = originalImage
        }
        if let selectedImage = editProfileImage {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
