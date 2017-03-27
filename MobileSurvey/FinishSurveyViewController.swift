//
//  FinishSurveyViewController.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/26/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import UIKit

class FinishSurveyViewController: UIViewController {


    var filenamePrefix = "MobileSurvey_"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppLevelVariables.Survey?.EndTime = Date()
        let output = "ID: \(AppLevelVariables.Survey?.ResponseId)" +
            "\n Date: \(AppLevelVariables.Survey?.StartTime)" +
            "\n Rating: \(AppLevelVariables.Survey?.Rating)" +
            "\n Comment: \(AppLevelVariables.Survey?.Comment)" +
            "\n HowDidYouHear: \(AppLevelVariables.Survey?.HowDidYouHear)" +
            "\n FirstName: \(AppLevelVariables.Survey?.FirstName)" +
            "\n LastName: \(AppLevelVariables.Survey?.LastName)" +
            "\n Address: \(AppLevelVariables.Survey?.Address?.AddressLine1) \(AppLevelVariables.Survey?.Address?.AddressLine2)" +
            "\n City: \(AppLevelVariables.Survey?.Address?.City)" +
            "\n State: \(AppLevelVariables.Survey?.Address?.State)" +
            "\n Zip: \(AppLevelVariables.Survey?.Address?.Zip)" +
            "\n Country: \(AppLevelVariables.Survey?.Address?.Country)" +
            "\n Organization: \(AppLevelVariables.Survey?.OrganizationName)" +
            "\n Email: \(AppLevelVariables.Survey?.EmailAddress)" +
            "\n KidsInterest: \(AppLevelVariables.Survey?.InterestedInKidsActivities)" +
            "\n FestivalInterest: \(AppLevelVariables.Survey?.InterestedInFestivals)" +
            "\n SatsangInterest: \(AppLevelVariables.Survey?.InterestedInSatsangActivities)" +
            "\n YouthInterest: \(AppLevelVariables.Survey?.InterestedInYouthActivities)" +
            "\n AncestralState: \(AppLevelVariables.Survey?.AncestralState)" +
            "\n AncestralPlace: \(AppLevelVariables.Survey?.AncestralPlace)" +
            "\n ReferredBy: \(AppLevelVariables.Survey?.ReferredBy)" +
            "\n SurveyType: \(AppLevelVariables.Survey?.SurveyType)" +
            "\n StartTime: \(AppLevelVariables.Survey?.StartTime)" +
            "\n EndTime: \(AppLevelVariables.Survey?.EndTime)" +
            "\n WasAbandoned: \(AppLevelVariables.Survey?.WasAbandonded)" +
        "\n WasCancelled: \(AppLevelVariables.Survey?.WasCancelled)"
        print("Survey results are: \(output)")
        writeSurveyToCSV();
        Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(FinishSurveyViewController.restartSurvey), userInfo: nil, repeats: false)
        
    }
    
    func restartSurvey() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeView = storyboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(homeView,animated: true, completion:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "ShowHome", sender: nil)
    }

    
    // MARK: CSV file creating
    func writeSurveyToCSV() -> Void {
        let filename = createFileNameForToday(prefix: filenamePrefix)//gets file name with todays date appended
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        let headerText = "DeviceID|SurveyID|Date|Rating|Comment|HowDidYouHear|FirstName|LastName|Address1|Address2|City|State|" +
            "Zip|Country|Organization|Email|KidsInterest|FestivalInterest|SatsangInterest|YouthInterest|" +
            "AncestralState|AncestralPlace|ReferredBy|SurveyType|StartTime|EndTime|WasAbandoned|WasCancelled\n"
        
        if let fileHandle = FileHandle(forWritingAtPath: (path?.absoluteString)!)
        {
            let contentToAppend = createContent()
            //Append to file
            fileHandle.seekToEndOfFile()
            fileHandle.write(contentToAppend.data(using: String.Encoding.utf8)!)
        }
        else
        {
            //Create new file
            do {
                let content = "\(headerText)\n\(createContent())"
                try content.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            }   catch {
                print("Error creating \(path)")
            }
        }
    }

    func checkIfFileExists(filePath:String)->Bool {
        let fileManager = FileManager.default
        // Check if file exists, given its path
        if fileManager.fileExists(atPath: filePath) {
            print("File \(filePath) exists")
            return true
        } else {
            print("File \(filePath) does not exists")
            return false
        }
    }

    func createFileNameForToday(prefix:String)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return prefix + formatter.string(from:Date())
        
    }
        
        func createContent() -> String {
            let content =
                    "\(AppLevelVariables.Survey?.DeviceId)|" +
                    "\(AppLevelVariables.Survey?.ResponseId)|" +
                    "\(AppLevelVariables.Survey?.StartTime)|" +
                    "\(AppLevelVariables.Survey?.Rating)|" +
                    "\(AppLevelVariables.Survey?.Comment)|" +
                    "\(AppLevelVariables.Survey?.HowDidYouHear)|" +
                    "\(AppLevelVariables.Survey?.FirstName)|" +
                    "\(AppLevelVariables.Survey?.LastName)|" +
                    "\(AppLevelVariables.Survey?.Address?.AddressLine1)|" +
                    "\(AppLevelVariables.Survey?.Address?.AddressLine2)|" +
                    "\(AppLevelVariables.Survey?.Address?.City)|" +
                    "\(AppLevelVariables.Survey?.Address?.State)|" +
                    "\(AppLevelVariables.Survey?.Address?.Zip)|" +
                    "\(AppLevelVariables.Survey?.Address?.Country)|" +
                    "\(AppLevelVariables.Survey?.OrganizationName)|" +
                    "\(AppLevelVariables.Survey?.EmailAddress)|" +
                    "\(AppLevelVariables.Survey?.InterestedInKidsActivities)|" +
                    "\(AppLevelVariables.Survey?.InterestedInFestivals)|" +
                    "\(AppLevelVariables.Survey?.InterestedInSatsangActivities)|" +
                    "\(AppLevelVariables.Survey?.InterestedInYouthActivities)|" +
                    "\(AppLevelVariables.Survey?.AncestralState)|" +
                    "\(AppLevelVariables.Survey?.AncestralPlace)|" +
                    "\(AppLevelVariables.Survey?.ReferredBy)|" +
                    "\(AppLevelVariables.Survey?.SurveyType)|" +
                    "\(AppLevelVariables.Survey?.StartTime)|" +
                    "\(AppLevelVariables.Survey?.EndTime)|" +
                    "\(AppLevelVariables.Survey?.WasAbandonded)|" +
                    "\(AppLevelVariables.Survey?.WasCancelled)"
            
            return content
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