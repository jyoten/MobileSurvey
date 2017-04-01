//
//  ScreenSaverDateHelper.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/31/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import Foundation

class ScreenSaverDateHelper {
    
    static func getTodayDateAndTimeFrom(timeOnlyString:String) -> Date{
        
        //setup dateformatter for todays date
        let dfDate = DateFormatter()
        dfDate.dateFormat = "yyyy-MM-dd "
        let todaysDateString = dfDate.string(from: Date())

        let todaysFullDateString = todaysDateString + timeOnlyString
        
        //setup date formatter for full date
        let dfFullDate = DateFormatter()
        dfFullDate.dateFormat = "yyyy-MM-dd hh:mm a"
        dfFullDate.amSymbol = "AM"
        dfFullDate.pmSymbol = "PM"
        
        return dfFullDate.date(from: todaysFullDateString)!
        
        
    }
    
    static func getTimeOnlyStringFrom(date:Date) ->String {
        let df = getTimeFormatter()
        return df.string(from: date)
    }
    
    static func getTimeFormatter()->DateFormatter{
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        return df
    }
}
