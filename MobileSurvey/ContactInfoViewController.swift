//
//  ContactInfoViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        state.text = AppLevelVariables.Survey?.Address?.State
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        AppLevelVariables.Survey?.EmailAddress = email.text
        AppLevelVariables.Survey?.Address?.AddressLine1 = addressLine1.text
        AppLevelVariables.Survey?.Address?.AddressLine2 = addressLine2.text
        AppLevelVariables.Survey?.Address?.City = city.text
        AppLevelVariables.Survey?.Address?.State = state.text
        AppLevelVariables.Survey?.Address?.Zip = zip.text
        self.performSegue(withIdentifier: "ShowInterestedActivities", sender: nil)
        
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
