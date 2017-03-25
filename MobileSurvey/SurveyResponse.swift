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
    }
    
    var Rating:Int = -1
    var Comment:String?
    var HowDidYouHear:String?
    var FirstName:String?
    var LastName:String?
    var OrganizationName:String?
    var EmailAddress:String?
    var Address:AddressInfo?
    var InterestedIn:String?
    var AncestralState:String?
    var AncestralPlace:String?
    var ReferredBy:String?
    var SubmittedTime:Date?
    var ResponseId:String?
    
    
}
