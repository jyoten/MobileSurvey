//
//  ScreenSaverViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/30/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class ScreenSaverViewController: UIViewController {

    @IBOutlet weak var blackScreen: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    var timer:Timer!
    var originalBrightness:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(moveText), userInfo: nil, repeats: true)
        let screenTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                   action: #selector (screenTapped(tapGestureRecognizer:)))
        blackScreen?.isUserInteractionEnabled = true
        blackScreen?.addGestureRecognizer(screenTapGestureRecognizer)
        
        originalBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = (0.1)
        let params = ["OriginalBrightness": "\(originalBrightness)", "SaverBrightness": "\(0.1)"]
        Flurry.logEvent("Screensaver started", withParameters: params)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        UIScreen.main.brightness = originalBrightness
        let params = ["SaverBrightness": "\(0.1)", "OriginalBrightness": "\(originalBrightness)"]
        Flurry.logEvent("Screensaver stopped", withParameters: params)
    }

    func moveText(){
        DispatchQueue.main.async {
            var frame = self.noticeLabel.frame
            let x = arc4random_uniform(UInt32(Int(UIScreen.main.bounds.width)))
            let y = arc4random_uniform(UInt32(Int(UIScreen.main.bounds.height)))
            frame.origin.x = CGFloat(x)
            frame.origin.y = CGFloat(y)
            self.noticeLabel.frame = frame
            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func screenTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "BackToHomeScreen", sender: nil)
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
