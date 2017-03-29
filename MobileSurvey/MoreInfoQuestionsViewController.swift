//
//  MoreInfoQuestionsViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class MoreInfoQuestionsViewController: UIViewController {
    var expirationHandler: SessionExpirationHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            expirationHandler = SessionExpirationHandler(viewController:self, waitTime: 4)
        { [weak self] abandoned in
            print("Session expired")
            self?.expirationHandler.invalidateTimer()
            self?.performSegue(withIdentifier: "FinishFromQ1", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        expirationHandler.invalidateTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        AppLevelVariables.Survey!.SurveyType = "Full"
        expirationHandler.invalidateTimer()
        self.performSegue(withIdentifier: "ShowContactInfo", sender: nil)

    }

    @IBAction func noButtonClicked(_ sender: Any) {

        AppLevelVariables.Survey!.EndTime = Date()
        AppLevelVariables.Survey!.SurveyType = "Quick";
        self.performSegue(withIdentifier: "FinishFromQ1", sender: nil)
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
