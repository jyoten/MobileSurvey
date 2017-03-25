//
//  ViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/22/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rating1:UIImageView!
    @IBOutlet weak var rating2:UIImageView!
    @IBOutlet weak var rating3:UIImageView!
    @IBOutlet weak var rating4:UIImageView!
    @IBOutlet weak var rating5:UIImageView!
    @IBOutlet weak var button:UIButton?
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var howDidYouHearBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        AppLevelVariables.Survey?.Rating = Int(tappedImage.tag)
        
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
        rating1.isUserInteractionEnabled = true
        rating1.addGestureRecognizer(ratingOneTapGestureRecognizer)
        rating2.isUserInteractionEnabled = true
        rating2.addGestureRecognizer(ratingTwoTapGestureRecognizer)
        rating3.isUserInteractionEnabled = true
        rating3.addGestureRecognizer(ratingThreeTapGestureRecognizer)
        rating4.isUserInteractionEnabled = true
        rating4.addGestureRecognizer(ratingFourTapGestureRecognizer)
        rating5.isUserInteractionEnabled = true
        rating5.addGestureRecognizer(ratingFiveTapGestureRecognizer)
    }
    
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        AppLevelVariables.Survey?.ResponseId = UUID().uuidString;
        AppLevelVariables.Survey?.SubmittedTime = Date()
        AppLevelVariables.Survey?.Comment = commentBox.text
        AppLevelVariables.Survey?.HowDidYouHear = howDidYouHearBox.text
        let alert = UIAlertController(title: "Alert", message: "ID: \(AppLevelVariables.Survey?.ResponseId)" +
            "\n Date: \(AppLevelVariables.Survey?.SubmittedTime)" +
            "\n Rating: \(AppLevelVariables.Survey?.Rating)" +
            "\n Comment: \(AppLevelVariables.Survey?.Comment)" +
            "\n HowDidYouHear: \(AppLevelVariables.Survey?.HowDidYouHear)", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
         /*self.present(alert, animated: true)*/
        performSegue(withIdentifier: "ShowBasicInfo", sender: nil)
    }
}

