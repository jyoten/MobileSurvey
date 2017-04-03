//
//  ViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/22/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import SwiftyDropbox
import MediaPlayer
class ViewController: UIViewController{
    
    @IBOutlet weak var rating1:UIImageView!
    @IBOutlet weak var rating2:UIImageView!
    @IBOutlet weak var rating3:UIImageView!
    @IBOutlet weak var rating4:UIImageView!
    @IBOutlet weak var rating5:UIImageView!
    @IBOutlet weak var button:UIButton?
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var videoView:UIView!
    @IBOutlet weak var settingsButton:UIButton!
    
    //@IBOutlet weak var howDidYouHearBox: UITextView!
    @IBOutlet weak var statusView: UIView!
    var timer2Hrs:Timer!
    var timer1Min:Timer!
    var todaysScreenSaverStartTime:Date!
    var todaysScreenSaverEndTime:Date!
    var player:AVPlayer!
    var avPlayerLayer:AVPlayerLayer!
    
    var rating:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSettings()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetForm()
        setupRatingsImageViewGestureRecognizers()
        sendSurveys()
        setupTimers()
        setupVideo()
        if (AppLevelVariables.videoOn == true){
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        invalidateTimers()
        player.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectRating(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
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
    
    @IBAction func settingsButtonClicked(_ sender: UIButton){
        
        let alert = UIAlertController(title: "RBV Survey", message: "Settings not available during Guided Access Mode" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if (!UIAccessibilityIsGuidedAccessEnabled()) {
            performSegue(withIdentifier: "GoToSettings", sender: nil)
        }
        else {
            self.present(alert, animated: true)
        }

    }
    
    @IBAction func unwindFromFinish(segue: UIStoryboardSegue){
        resetForm()
        //DropboxHelper.sendStoredSurveysToDropbox()
        setupTimers()
        if (AppLevelVariables.videoOn == true){
            player.play()
        }
    }
    
    @IBAction func unwindFromScreenSaver(segue: UIStoryboardSegue){
        resetForm()
        setupTimers()
        //DropboxHelper.sendStoredSurveysToDropbox()
        if (AppLevelVariables.videoOn == true){
            player.play()
        }
    }
    
    func resetForm()
    {
        AppLevelVariables.Survey = SurveyResponse()
        rating1.image = UIImage(named:"Off")
        rating2.image = UIImage(named:"Off")
        rating3.image = UIImage(named:"Off")
        rating4.image = UIImage(named:"Off")
        rating5.image = UIImage(named:"Off")
        commentBox.text = ""
        //howDidYouHearBox.text = ""
    }
    
    func readSettings(){
        checkForDeviceId()
        checkScreenSaverSettings()
    }
    
    func checkForDeviceId(){
        let deviceID = UserDefaults.standard.string(forKey: "DeviceId")
        if (deviceID == nil || deviceID == ""){
            let alert = UIAlertController(title: "Initial Setup", message: "Please click on the gear icon to setup this device: " , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            AppLevelVariables.deviceId = deviceID!
        }
    }
    
    func checkScreenSaverSettings(){
        AppLevelVariables.screenSaverEnabled = UserDefaults.standard.bool(forKey: "ScreenSaver")
        AppLevelVariables.videoOn = UserDefaults.standard.bool(forKey: "Video")
        
        
        AppLevelVariables.screenSaverStartTime =
            UserDefaults.standard.string(forKey: "StartScreenSaver")
        AppLevelVariables.screenSaverEndTime =
            UserDefaults.standard.string(forKey: "EndScreenSaver")
        if (AppLevelVariables.screenSaverStartTime == nil || AppLevelVariables.screenSaverStartTime == ""){
            AppLevelVariables.screenSaverStartTime = "12:00 AM"
        }
        if (AppLevelVariables.screenSaverEndTime == nil || AppLevelVariables.screenSaverEndTime == ""){
            AppLevelVariables.screenSaverEndTime = "08:00 AM"
        }
        if (AppLevelVariables.screenSaverEnabled == nil){
            AppLevelVariables.screenSaverEnabled = true
        }
        
        
        todaysScreenSaverStartTime = ScreenSaverDateHelper.getTodayDateAndTimeFrom(timeOnlyString: AppLevelVariables.screenSaverStartTime)
        todaysScreenSaverEndTime = ScreenSaverDateHelper.getTodayDateAndTimeFrom(timeOnlyString: AppLevelVariables.screenSaverEndTime)
        
    }
    
    func sendSurveys(){
        if DropboxClientsManager.authorizedClient != nil {
            self.statusView.backgroundColor = UIColor.green
            DropboxHelper.sendStoredSurveysToDropbox()
        }
        else {
            self.statusView.backgroundColor = UIColor.red
        }
    }
    
    func setServerStatus(){
        if DropboxClientsManager.authorizedClient != nil {
            self.statusView.backgroundColor = UIColor.green
        }
        else {
            self.statusView.backgroundColor = UIColor.red
        }
    }
    
    func setupTimers() {
        self.timer2Hrs = Timer.scheduledTimer(timeInterval: 7200, target: self, selector: #selector(ViewController.doEvery2Hours), userInfo: nil, repeats: true)
        
        self.timer1Min = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.doEveryMinute), userInfo: nil, repeats: true)
    }
    
    func invalidateTimers(){
        timer2Hrs.invalidate()
        timer1Min.invalidate()
    }
    
    func doEvery2Hours(){
        sendSurveys()
    }
    
    func doEveryMinute(){
        if (AppLevelVariables.screenSaverEnabled! == true){
            if (Date() > todaysScreenSaverStartTime! && Date() < todaysScreenSaverEndTime!){
                performSegue(withIdentifier: "GoToScreenSaver", sender: nil)
            }
        }
    }
    
    func setupVideo(){
        let pathToEx1 = Bundle.main.path(forResource: "MandirMoods", ofType: "mp4")
        let pathUrl = URL.init(fileURLWithPath: pathToEx1!)
        
        player = AVPlayer(url: pathUrl)
        player.isMuted = true
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = self.videoView.frame
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayerLayer.player?.seek(to: CMTime(seconds: 3, preferredTimescale: 1))
        self.videoView.layer.addSublayer(avPlayerLayer)
        
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: player.currentItem)
    }
    
    func playerItemDidReachEnd(notification:NSNotification){
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime(seconds: 3, preferredTimescale: 1))
        }
    }
}

