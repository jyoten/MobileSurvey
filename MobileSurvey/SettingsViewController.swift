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
    @IBOutlet weak var videoSwitch: UISwitch!
    var selectedStartTime:String!
    var selectedEndTime:String!
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        deviceId.text = AppLevelVariables.deviceId
        if (AppLevelVariables.screenSaverEnabled! == true){
            screenSaverSwitch.isOn = true
        }
        else {
            screenSaverSwitch.isOn = false
        }
        if (AppLevelVariables.videoOn == true){
            videoSwitch.isOn = true
        }
        else {
            videoSwitch.isOn = false
        }
        startTime.text = AppLevelVariables.screenSaverStartTime
        endTime.text = AppLevelVariables.screenSaverEndTime
        checkUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startChanged(_ sender: Any) {
        AppLevelVariables.screenSaverStartTime = startTime.text
    }
    
    
    @IBAction func endChanged(_ sender: Any) {
        AppLevelVariables.screenSaverEndTime = endTime.text
    }
    
    @IBAction func switchToggled(_ sender: Any) {
        if (screenSaverSwitch.isOn){
            AppLevelVariables.screenSaverEnabled = true
        }
        else {
            AppLevelVariables.screenSaverEnabled = false
        }
    }

    @IBAction func videoSwitchToggled(_ sender: Any) {
        if (videoSwitch.isOn){
            AppLevelVariables.videoOn = true
        }
        else {
            AppLevelVariables.videoOn = false
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

    
    func checkUser(){
        if let client = DropboxClientsManager.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    print("Hello \(account.name.givenName)")
                    self.successMessage.text = " You are logged in as \n \(account.name.givenName)"
                    self.successMessage.textColor = UIColor.green
                    //self.dropBoxLoginButton.isHidden = true
                } else {
                    self.successMessage.text = "Not connected to Dropbox"
                    self.successMessage.textColor = UIColor.red
                    //self.dropBoxLoginButton.isHidden = false
                    print(error!)
                }
            }
        }
        else {
            self.successMessage.text = "Not connected to Dropbox"
            self.successMessage.textColor = UIColor.red
            //self.dropBoxLoginButton.isHidden = false
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromSettings", sender: nil)
    }

    @IBAction func saveClick(_ sender: Any) {
        AppLevelVariables.deviceId = deviceId.text!;
        UserDefaults.standard.set(AppLevelVariables.deviceId, forKey: "DeviceId")
        UserDefaults.standard.set(AppLevelVariables.screenSaverEnabled, forKey: "ScreenSaver")
        UserDefaults.standard.set(AppLevelVariables.videoOn, forKey: "Video")
        UserDefaults.standard.set(AppLevelVariables.screenSaverStartTime, forKey: "StartScreenSaver")
        UserDefaults.standard.set(AppLevelVariables.screenSaverEndTime, forKey: "EndScreenSaver")
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
