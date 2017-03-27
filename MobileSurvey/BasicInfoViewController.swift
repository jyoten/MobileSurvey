//
//  BasicInfoViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/23/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import SwiftValidator

class BasicInfoViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, ValidationDelegate{
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var organizationName: UITextField!
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var countryError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    
    var countries: [String] = []
    var states: [String] = []
    var abandon:Bool = true
    var statePickerView: UIPickerView!
    var validator:Validator!
    var sessionExpirationHandler:SessionExpirationHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCountryPickerView()
        setupStatePickerView()
        setupValidators()
        sessionExpirationHandler = SessionExpirationHandler(viewController:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        validator.validate(delegate: self as ValidationDelegate)
    }

    func validationSuccessful() {
        AppLevelVariables.Survey?.FirstName = firstName.text
        AppLevelVariables.Survey?.LastName = lastName.text
        AppLevelVariables.Survey?.Address = AddressInfo()
        AppLevelVariables.Survey?.Address?.Country = country.text
        AppLevelVariables.Survey?.Address?.State = state.text
        AppLevelVariables.Survey?.OrganizationName = organizationName.text
        performSegue(withIdentifier: "ShowQuestion1", sender: nil)
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return countries.count
        }
        else {
            if (country.text! != "USA" && country.text! != "United States"){
                return 0
            }
            else{
                return states.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1)
        {
            if (countries[row] == "---------")
            {
                country.text = "";
                return;
            }
            country.text = countries[row]
            if (country.text! != "USA" && country.text! != "United States"){
                state.text = "N/A"
                state.inputView = nil
            }
            else {
                state.text = ""
                state.inputView = statePickerView
            }
        }
        else {
            state.text = states[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView.tag == 1)
        {
            return countries[row]
        }
        else
        {
            return states[row]
        }

    }
    
    func setupCountryPickerView(){
        countries.append("")
        countries.append("USA")
        countries.append("India")
        countries.append("UK")
        countries.append("Australia")
        countries.append("---------")
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        let countryPickerView = UIPickerView()
        countryPickerView.delegate = self
        countryPickerView.tag = 1
        country.inputView = countryPickerView
    }
    
    func setupStatePickerView(){
        states = [ "","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI",
                   "IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC",
                   "ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN",
                   "TX","UT","VA","VI","VT","WA","WI","WV","WY"]
        statePickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.tag = 2
        state.inputView = statePickerView
    }
    
    func setupValidators(){
        validator = Validator()
        validator.registerField(textField: firstName, errorLabel: firstNameError, rules: [RequiredRule()])
        validator.registerField(textField: lastName, errorLabel: lastNameError, rules: [RequiredRule()])
        validator.registerField(textField: country, errorLabel: countryError
            , rules: [RequiredRule()])
    }
    
    
    
}
