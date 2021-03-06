//
//  SessionExpirationHandler.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/27/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

class SessionExpirationHandler {
    
    var abandon:Bool!
    var viewController:UIViewController!
    var waitTime:Double!
    var timer:Timer!
    var sessionAbandoned: ((_ abandoned:Bool) -> ())?
    
    init(viewController:UIViewController, waitTime: Double, sessionAbandonedCallback: @escaping (_ abandoned: Bool)->()){
        self.waitTime = waitTime;
        //self.waitTime = 7; //use for testing
        self.sessionAbandoned = sessionAbandonedCallback
        timer = Timer.scheduledTimer(timeInterval: self.waitTime, target: self, selector: #selector(self.areYouThereQuestion), userInfo: nil, repeats: true);
        self.viewController = viewController
        
    }
    
    func invalidateTimer(){
        self.timer.invalidate()
        self.viewController = nil
    }
    
    @objc func areYouThereQuestion() {
        self.abandon = true
        print ("self.abandon in are u there = \(self.abandon!)")
        let alert = UIAlertController(title: "Alert",
                                      message: "Are you still there? " , preferredStyle: UIAlertControllerStyle.alert)
        //if they click yes, set abandon = false so they get more time
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            self.abandon = false
            print ("self.abandon in alert handler = \(self.abandon!)")
        }))
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: false, completion: nil)
        }
        
        let when2 = DispatchTime.now() + 5.5
        DispatchQueue.main.asyncAfter(deadline: when2){
            self.abandonSurvey()
        }
        self.viewController.present(alert, animated: true)
        
    }
    
    func abandonSurvey(){
        print ("self.abandon = \(self.abandon!)")
        if (self.abandon! == true)
        {
            let params = ["Screen": self.viewController.restorationIdentifier!]
            Flurry.logEvent("Abandonded Session", withParameters: params)
            self.timer.invalidate()
            self.viewController = nil
            AppLevelVariables.Survey?.WasAbandonded = true;
            self.sessionAbandoned?(abandon)
        }
    }
}
