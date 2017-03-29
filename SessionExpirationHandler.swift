//
//  SessionExpirationHandler.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/27/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import Foundation
import UIKit
class SessionExpirationHandler {

    var abandon:Bool!
    var viewController:UIViewController!
    var waitTime:Double!
    var timer:Timer!
    var sessionAbandoned: ((_ abandoned:Bool) -> ())?
    
    init(viewController:UIViewController, waitTime: Double){
        self.waitTime = waitTime;
        //self.sessionAbandoned = sessionAbandonedCallback
        timer = Timer.scheduledTimer(timeInterval: waitTime, target: self, selector: #selector(self.areYouThereQuestion), userInfo: nil, repeats: true);
        self.viewController = viewController
        
    }
    
    func invalidateTimer(){
        self.timer.invalidate()
        self.viewController = nil
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
        
        viewController.present(alert, animated: true)
        
    }
    
    func abandonSurvey(){
        if (abandon == true)
        {
            self.timer.invalidate()
            //self.sessionAbandoned?(abandon)
            AppLevelVariables.Survey?.WasAbandonded = true;
            viewController.performSegue(withIdentifier: "FinishFromQ1", sender: nil)
        }
    }
}
