//
//  InterestedActivitiesViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class InterestedActivitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kidsButtonClick(_ sender: UIButton) {
        if (AppLevelVariables.Survey?.InterestedInKidsActivities == true)
        {
            AppLevelVariables.Survey?.InterestedInKidsActivities = false
        }
        else
        {
            AppLevelVariables.Survey?.InterestedInKidsActivities = true
        }
        toggleButton(button: sender)
    }
    @IBAction func youthButtonClick(_ sender: UIButton) {
        if (AppLevelVariables.Survey?.InterestedInYouthActivities == true)
        {
            AppLevelVariables.Survey?.InterestedInYouthActivities = false
        }
        else
        {
            AppLevelVariables.Survey?.InterestedInYouthActivities = true
        }
        toggleButton(button: sender)
    }
    
    @IBAction func festivalsButtonClick(_ sender: UIButton) {
        if (AppLevelVariables.Survey?.InterestedInFestivals == true)
        {
            AppLevelVariables.Survey?.InterestedInFestivals = false
        }
        else
        {
            AppLevelVariables.Survey?.InterestedInFestivals = true
        }
        toggleButton(button: sender)
    }
    @IBAction func satsangButtonClick(_ sender: UIButton) {
        if (AppLevelVariables.Survey?.InterestedInSatsangActivities == true)
        {
            AppLevelVariables.Survey?.InterestedInSatsangActivities = false
        }
        else
        {
            AppLevelVariables.Survey?.InterestedInSatsangActivities = true
        }
        toggleButton(button: sender)
    }

    func toggleButton (button:UIButton){
        if(button.backgroundColor == UIColor.white)
        {
            button.backgroundColor = UIColor.green;
        }
        else
        {
            button.backgroundColor = UIColor.white
        }
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
