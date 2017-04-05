//
//  ContactInfoViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import SwiftValidator

class ContactInfoViewController: UIViewController, ValidationDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var emailHintBar: UISegmentedControl!
    
    var validator:Validator!
    var keyboardHeight:CGFloat!
    var expirationHandler:SessionExpirationHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        state.text = AppLevelVariables.Survey!.Address.State
        expirationHandler = SessionExpirationHandler(viewController:self, waitTime: 120)
        { [weak self] abandoned in
            print("Session expired")
            self?.addressLine1.resignFirstResponder()
            self?.addressLine2.resignFirstResponder()
            self?.city.resignFirstResponder()
            self?.state.resignFirstResponder()
            self?.zip.resignFirstResponder()
            self?.email.resignFirstResponder()
            self?.performSegue(withIdentifier: "ShowFinishFromContactInfo", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        expirationHandler.invalidateTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupValidators()
        email.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ContactInfoViewController.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.origin.y
        
        
        let x = CGFloat(0)
        let width = CGFloat (UIScreen.main.bounds.width)
        let height = emailHintBar.frame.height
        let y = keyboardHeight! - (height)
        
        emailHintBar.frame = CGRect(x:x,y:y,width:width,height:height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textView: UITextField) {
        emailHintBar.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailHintBar.isHidden = true
    }
    
    @IBAction func emailProviderSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("first segement clicked")
            email.text = email.text! + "@gmail.com"
        case 1:
            print("second segment clicked")
            email.text = email.text! + "@yahoo.com"
        case 2:
            print("third segemnet clicked")
            email.text = email.text! + "@hotmail.com"
        case 3:
            print("third segemnet clicked")
            email.text = email.text! + "@aol.com"
        default:
            break;
        }  //Switch
    }
    
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        validator.validate(delegate: self as ValidationDelegate)
    }
    
    func validationSuccessful() {
        AppLevelVariables.Survey!.EmailAddress = email.text!
        AppLevelVariables.Survey!.Address.AddressLine1 = addressLine1.text!
        AppLevelVariables.Survey!.Address.AddressLine2 = addressLine2.text!
        AppLevelVariables.Survey!.Address.City = city.text!
        AppLevelVariables.Survey!.Address.State = state.text!
        AppLevelVariables.Survey!.Address.Zip = zip.text!
        expirationHandler.invalidateTimer()
        self.performSegue(withIdentifier: "ShowInterestedActivities", sender: nil)
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.red.cgColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    func setupValidators(){
        validator = Validator()
        validator.registerField(textField: email, errorLabel: emailError, rules: [RequiredRule()])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
