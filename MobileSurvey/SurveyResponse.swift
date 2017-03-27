//
//  Survey.swift
//  MobileSurvey
//
//  Created by Jyoten Patel on 3/22/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import Foundation

class SurveyResponse {
    init() {
        self.StartTime = Date()
        self.ResponseId = UUID().uuidString
        self.Address = AddressInfo()
    }
    
    var Rating:Int = -1
    var Comment:String?
    var HowDidYouHear:String?
    var FirstName:String?
    var LastName:String?
    var OrganizationName:String?
    var EmailAddress:String?
    var Address:AddressInfo?
    var InterestedInKidsActivities:Bool = false
    var InterestedInFestivals:Bool = false
    var InterestedInYouthActivities:Bool = false
    var InterestedInSatsangActivities:Bool = false
    var AncestralState:String?
    var AncestralPlace:String?
    var ReferredBy:String?
    var StartTime:Date?
    var ResponseId:String?
    var DeviceId:String?
    var SurveyType:String?
    var EndTime:Date?
    var WasCancelled:Bool = false
    var WasAbandonded:Bool = false
}
