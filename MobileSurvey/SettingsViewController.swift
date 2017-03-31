//
//  SettingsViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import SwiftyDropbox

class SettingsViewController: UIViewController {
    @IBOutlet weak var dropBoxLoginButton: UIButton!
    @IBOutlet weak var deviceId: UITextField!
    @IBOutlet weak var successMessage: UILabel!
    @IBOutlet weak var screenSaverSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deviceId.text = AppLevelVariables.Survey!.DeviceId
        checkUser()
        if (AppLevelVariables.screenSaverEnabled! == true){
            screenSaverSwitch.isOn = true
        }
        else {
            screenSaverSwitch.isOn = false
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        if (screenSaverSwitch.isOn){
            AppLevelVariables.screenSaverEnabled = true
        }
        else {
            AppLevelVariables.screenSaverEnabled = false
        }
    }
    @IBAction func dropboxLoginClick(_ sender: Any) {
        let handler: (Bool)->Void = {result in
            if (result){
                print("result: \(result)")
                self.checkUser()
            }
        }
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { (url: URL) ->Void in UIApplication.shared.open(url, options: [:], completionHandler: handler)
        })
    }

    
    @IBAction func uploadButtonClick(_ sender: Any) {

    }
    
    func checkUser(){
        if let client = DropboxClientsManager.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    print("Hello \(account.name.givenName)")
                    self.successMessage.text = " You are logged in as \n \(account.name.givenName)"
                    self.successMessage.textColor = UIColor.green
                    self.dropBoxLoginButton.isHidden = true
                } else {
                    self.successMessage.text = "Not connected to Dropbox"
                    self.successMessage.textColor = UIColor.red
                    self.dropBoxLoginButton.isHidden = false
                    print(error!)
                }
            }
        }
        else {
            self.successMessage.text = "Not connected to Dropbox"
            self.successMessage.textColor = UIColor.red
            self.dropBoxLoginButton.isHidden = false
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromSettings", sender: nil)
    }

    @IBAction func saveClick(_ sender: Any) {
        AppLevelVariables.Survey!.DeviceId = deviceId.text!;
        UserDefaults.standard.set(deviceId.text, forKey: "DeviceId")
        UserDefaults.standard.set(AppLevelVariables.screenSaverEnabled, forKey: "ScreenSaver")
        performSegue(withIdentifier: "UnwindFromSettings", sender: nil)
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
