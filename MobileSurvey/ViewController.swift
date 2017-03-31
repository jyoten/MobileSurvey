//
//  ViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/22/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController{
    
    @IBOutlet weak var rating1:UIImageView!
    @IBOutlet weak var rating2:UIImageView!
    @IBOutlet weak var rating3:UIImageView!
    @IBOutlet weak var rating4:UIImageView!
    @IBOutlet weak var rating5:UIImageView!
    @IBOutlet weak var button:UIButton?
    @IBOutlet weak var commentBox: UITextView!
    //@IBOutlet weak var howDidYouHearBox: UITextView!
    @IBOutlet weak var statusView: UIView!
    var timer:Timer!
    
    var rating:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetForm()
        setupRatingsImageViewGestureRecognizers()
        //doTimedEvents()
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectRating(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        /*let alert = UIAlertController(title: "Alert", message: "ID: \(tappedImage.tag)" , preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true)*/
        
        
        rating1.image = UIImage(named:"Off")
        rating2.image = UIImage(named:"Off")
        rating3.image = UIImage(named:"Off")
        rating4.image = UIImage(named:"Off")
        rating5.image = UIImage(named:"Off")
        tappedImage.image = UIImage(named:"On")
        rating = Int(tappedImage.tag)
        
    }
    
    func setupRatingsImageViewGestureRecognizers(){
        let ratingOneTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector (selectRating(tapGestureRecognizer:)))
        let ratingTwoTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector (selectRating(tapGestureRecognizer:)))
        let ratingThreeTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector (selectRating(tapGestureRecognizer:)))
        let ratingFourTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                    action: #selector (selectRating(tapGestureRecognizer:)))
        let ratingFiveTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                    action: #selector (selectRating(tapGestureRecognizer:)))
        rating1?.isUserInteractionEnabled = true
        rating1?.addGestureRecognizer(ratingOneTapGestureRecognizer)
        rating2?.isUserInteractionEnabled = true
        rating2?.addGestureRecognizer(ratingTwoTapGestureRecognizer)
        rating3?.isUserInteractionEnabled = true
        rating3?.addGestureRecognizer(ratingThreeTapGestureRecognizer)
        rating4?.isUserInteractionEnabled = true
        rating4?.addGestureRecognizer(ratingFourTapGestureRecognizer)
        rating5?.isUserInteractionEnabled = true
        rating5?.addGestureRecognizer(ratingFiveTapGestureRecognizer)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        AppLevelVariables.Survey!.Rating = rating
        AppLevelVariables.Survey!.Comment = commentBox.text
        //AppLevelVariables.Survey!.HowDidYouHear = howDidYouHearBox.text
        performSegue(withIdentifier: "ShowBasicInfo", sender: nil)
    }
    
    @IBAction func unwindFromFinish(segue: UIStoryboardSegue){
        resetForm()
        DropboxHelper.sendStoredSurveysToDropbox()
        setupTimer()
    }
    
    @IBAction func unwindFromScreenSaver(segue: UIStoryboardSegue){
        resetForm()
        DropboxHelper.sendStoredSurveysToDropbox()
        //setupTimer()
    }
    
    func resetForm()
    {
        AppLevelVariables.Survey = SurveyResponse()
        checkForDeviceId()
        rating1.image = UIImage(named:"Off")
        rating2.image = UIImage(named:"Off")
        rating3.image = UIImage(named:"Off")
        rating4.image = UIImage(named:"Off")
        rating5.image = UIImage(named:"Off")
        commentBox.text = ""
        //howDidYouHearBox.text = ""
    }
    
    func checkForDeviceId(){
        let deviceID = UserDefaults.standard.string(forKey: "DeviceId")
        AppLevelVariables.screenSaverEnabled = UserDefaults.standard.bool(forKey: "ScreenSaver")
        if (deviceID == nil || deviceID == ""){
            let alert = UIAlertController(title: "Initial Setup", message: "Please click on the gear icon to setup this device: " , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            AppLevelVariables.Survey!.DeviceId = deviceID!
        }
    }
    
    func doTimedEvents(){
        if DropboxClientsManager.authorizedClient != nil {
            self.statusView.backgroundColor = UIColor.green
            DropboxHelper.sendStoredSurveysToDropbox()
        }
        else {
            self.statusView.backgroundColor = UIColor.red
        }
        
        if (AppLevelVariables.screenSaverEnabled! == true){
            performSegue(withIdentifier: "GoToScreenSaver", sender: nil)
        }
        
    }
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(ViewController.doTimedEvents), userInfo: nil, repeats: true)
    }
}

