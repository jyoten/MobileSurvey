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
    var timer:Timer!
    var abandon:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.waitTime = waitTime;
        //self.sessionAbandoned = sessionAbandonedCallback
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.areYouThereQuestion), userInfo: nil, repeats: true);
        //timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.areYouThereQuestion), userInfo: nil, repeats: true);
        expirationHandler = SessionExpirationHandler(viewController:self, waitTime: 5) /*{ [unowned self] abandoned in
            print("Session expired")
            self.expirationHandler.invalidateTimer()
            self.performSegue(withIdentifier: "QuickFinish", sender: nil)
        }*/
    }

    @objc func areYouThereQuestion() {
        abandon = true
        
        let alert = UIAlertController(title: "Alert",
                                      message: "Are you still there? " , preferredStyle: UIAlertControllerStyle.alert)
        //if they click yes, set abandon = false so they get more time
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            self.abandon = false
        }))
        
        //auto dismiss alert after 5 seconds
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
            self.abandonSurvey()
        }
        
        self.present(alert, animated: true)
        
    }
    
    func abandonSurvey(){
        if (abandon == true)
        {
            timer.invalidate()
            //self.sessionAbandoned?(abandon)
            AppLevelVariables.Survey?.WasAbandonded = true;
            self.performSegue(withIdentifier: "FinishFromQ1", sender: nil)
        }
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
        expirationHandler.invalidateTimer()
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
