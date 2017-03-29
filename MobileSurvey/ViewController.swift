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
    @IBOutlet weak var howDidYouHearBox: UITextView!
    var rating:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AppLevelVariables.Survey = SurveyResponse()
        sendReportsToDropbox()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let deviceID = UserDefaults.standard.string(forKey: "DeviceId")
        if (deviceID == nil || deviceID == ""){
            let alert = UIAlertController(title: "Initial Setup", message: "Please click on the gear icon to setup this device: " , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            AppLevelVariables.Survey!.DeviceId = deviceID!
        }
        setupRatingsImageViewGestureRecognizers()
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
        AppLevelVariables.Survey!.HowDidYouHear = howDidYouHearBox.text
        performSegue(withIdentifier: "ShowBasicInfo", sender: nil)
    }
    
    func sendReportsToDropbox(){
        
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        if (AppLevelVariables.lastSentDate == nil)
        {
            AppLevelVariables.lastSentDate = Date()
        }
        
        let date1 = calendar.startOfDay(for: AppLevelVariables.lastSentDate!)
        let date2 = calendar.startOfDay(for: Date())
        
        let diff = date2.timeIntervalSince(date1)
        if (diff > 1.0)
        {
            if let client = DropboxClientsManager.authorizedClient {
                let (filenamesOpt, _) = contentsOfDirectoryAtPath(path: NSTemporaryDirectory())
                if filenamesOpt != nil {
                    for item in filenamesOpt! {
                        if !(item.contains("com.")){
                            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(item)
                            do {
                                let content = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                                let fileData = content.data(using: String.Encoding.utf8, allowLossyConversion: false)
                                client.files.upload(path: "/\(item)", input: fileData!)
                            }
                            catch {
                            }
                        }
                    }
                }
                

            }
        }
        

    }
    
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [String]?, error: NSError?) {
        let error: NSError? = nil
        var contents:[String]?
        let fileManager = FileManager.default
        do {
            contents = try fileManager.contentsOfDirectory(atPath: path)
        } catch {
            //error = NSError(domain: "Error getting list of files", code: 1, userInfo: [:])
            return (nil,error as NSError?)
        }
        
        if contents == nil {
            return (nil, error)
        }
        else {
            let filenames = contents! as [String]
            return (filenames, nil)
        }
    }
    
    @IBAction func unwindFromFinish(segue: UIStoryboardSegue){
        AppLevelVariables.Survey = SurveyResponse()
        sendReportsToDropbox()
    }
    
    @IBAction func unwindFromBasicInfo(segue: UIStoryboardSegue){
        AppLevelVariables.Survey = SurveyResponse()
        sendReportsToDropbox()
    }
    
    @IBAction func unwindFromQuestion1(segue: UIStoryboardSegue){
        AppLevelVariables.Survey = SurveyResponse()
        sendReportsToDropbox()
    }
}

