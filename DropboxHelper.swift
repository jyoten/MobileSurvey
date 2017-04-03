//
//  DropboxHelper.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/29/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import Foundation
import SwiftyDropbox
import Flurry_iOS_SDK

class DropboxHelper {
    
    static func sendStoredSurveysToDropbox(){
        let (filenamesOpt, _) = contentsOfDirectoryAtPath(path: NSTemporaryDirectory())
        if filenamesOpt != nil {
            uploadFromTempFolderToDropBox(filenamesOpt: filenamesOpt!)
        }
    }
    
    static func uploadFromTempFolderToDropBox(filenamesOpt:[String]){
        for file in filenamesOpt {
            if (fileIsEligibleForSending(file: file, compareDate: Date()))
            {
                let params = ["filename": file]
                Flurry.logEvent("Found eligible file, sending to Dropbox.", withParameters: params)
                sendFile(file: file)
            }
        }
    }
    
    static func sendFile(file:String){
        if let client = DropboxClientsManager.authorizedClient
        {
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file)
            do {
                let content = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                let fileData = content.data(using: String.Encoding.utf8, allowLossyConversion: false)
                client.files.upload(path: "/\(file)", input: fileData!)
                let params = ["filename": file]
                Flurry.logEvent("Successfully sent file to Dropbox.", withParameters: params)
                AppLevelVariables.lastSentDate = Date()
                do{
                    
                    try FileManager.default.removeItem(at: path!)
                }
                catch {
                    print ("Error deleting file at path: \(path).  Will continue on without deleting.")
                }
            }
            catch {
                print ("Error sending file at path: \(path).  Will continue on without sending.")
            }
        }
    }
    
    static func getDateOfFile(fileName:String)->Date?{
        let indexOfLastUnderscore = fileName.range(of: "_", options: String.CompareOptions.backwards)?.upperBound
        let dateCSV = fileName.substring(from: indexOfLastUnderscore!)
        let indexOfCsv = dateCSV.range(of: ".csv", options: String.CompareOptions.backwards)?.lowerBound
        let onlyDate = dateCSV.substring(to: indexOfCsv!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.date(from:onlyDate)
    }
    
    static func fileIsEligibleForSending(file: String, compareDate:Date)->Bool{
        if (!file.contains(".csv")){
            return false
        }
        guard let dateFromFile = getDateOfFile(fileName: file) else
        {
            return false
        }
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: dateFromFile)
        let date2 = calendar.startOfDay(for: Date())
        
        let daysBetween = NSCalendar.current.dateComponents([.day], from: date1, to: date2)
        let numberOfDaysBetween = daysBetween.day
        if (numberOfDaysBetween! >= 1)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    static func contentsOfDirectoryAtPath(path: String) -> (filenames: [String]?, error: NSError?) {
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
}
