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
    @IBOutlet weak var deviceId: UITextField!
    @IBOutlet weak var successMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deviceId.text = AppLevelVariables.Survey!.DeviceId
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dropboxLoginClick(_ sender: Any) {
        
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { (url: URL) ->Void in UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        })
    }

    
    @IBAction func uploadButtonClick(_ sender: Any) {
        if let client = DropboxClientsManager.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                if let account = response {
                    print("Hello \(account.name.givenName)")
                    self.successMessage.text = "Hello \(account.name.givenName)"
                } else {
                    self.successMessage.text = "Unable to connect"
                    print(error!)
                }
            }
        }
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        performSegue(withIdentifier: "UnwindFromSettings", sender: nil)
    }

    @IBAction func saveClick(_ sender: Any) {
        AppLevelVariables.Survey!.DeviceId = deviceId.text!;
        UserDefaults.standard.set(deviceId.text, forKey: "DeviceId")
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
