//
//  SettingsViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var deviceId: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deviceId.text = AppLevelVariables.Survey?.DeviceId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeView = storyboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(homeView,animated: true, completion:nil)
    }

    @IBAction func saveClick(_ sender: Any) {
        AppLevelVariables.Survey?.DeviceId = deviceId.text;
        UserDefaults.standard.set(deviceId.text, forKey: "DeviceId")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeView = storyboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(homeView,animated: true, completion:nil)
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
