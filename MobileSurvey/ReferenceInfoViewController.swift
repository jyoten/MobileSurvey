//
//  ReferenceInfoViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class ReferenceInfoViewController: UIViewController {
    @IBOutlet weak var ancestralState: UITextField!
    @IBOutlet weak var ancestralPlace: UITextField!
    @IBOutlet weak var referredBy: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        AppLevelVariables.Survey?.AncestralState = ancestralState.text
        AppLevelVariables.Survey?.AncestralPlace = ancestralPlace.text
        AppLevelVariables.Survey?.ReferredBy = referredBy.text
        performSegue(withIdentifier: "ShowFinish", sender: nil)
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
