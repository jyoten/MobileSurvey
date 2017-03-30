//
//  MobileSurveyTests.swift
//  MobileSurveyTests
//
//  Created by Jyoten Patel on 3/29/17.
//  Copyright © 2017 Jyoten Patel. All rights reserved.
//

import XCTest

@testable import MobileSurvey

class DropboxHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_dropboxHelper_fileEligibilityTest_withValidFileFromYesterday() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let yesterdayString = df.string(from: yesterday!)
        let yesterdayFileName = "MobileSurvey_Device1_" + yesterdayString + ".csv"
        let result = DropboxHelper.fileIsEligibleForSending(file: yesterdayFileName, compareDate: today)
        XCTAssert(result)
    }
    
    func test_dropboxHelper_fileEligibilityTest_withFileFromToday() {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let todayString = df.string(from: today)
        let todayFileName = "MobileSurvey_Device1_" + todayString + ".csv"
        
        let result = DropboxHelper.fileIsEligibleForSending(file: todayFileName, compareDate: today)
        XCTAssertEqual(result, false)
    }
    
    func test_dropboxHelper_fileEligibilityTest_withInvalidFileDate() {
        let invalidDateString = "MobileSurvey_Device1_2017-02-29.csv"
        let result = DropboxHelper.fileIsEligibleForSending(file: invalidDateString, compareDate: Date())
        XCTAssertEqual(result, false)
    }
    
    
    func test_dropboxHelper_fileEligibilityTest_withComInFile() {
        //let todayFileName = "MobileSurvey_Device1_" + todayString + ".csv"
        let fileName = "MobileSurvey_Device1_.com.csv"
        let result = DropboxHelper.fileIsEligibleForSending(file: fileName, compareDate: Date())
        XCTAssertEqual(result, false)
    }
    

    func test_DateOfFile_V(){
        let result = DropboxHelper.getDateOfFile(fileName: "MobileSurvey_Device1_2017-02-28.csv")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let compare = df.date(from:"2017-02-28")
        XCTAssertEqual(result, compare)
    }

    func test_DateOfFile_I(){
        let result = DropboxHelper.getDateOfFile(fileName: "MobileSurvey_Device1_2017-02-29.csv")
        XCTAssertEqual(result, nil)
    }

    func test_ContentsOfDirectoryAtPath_V(){
        let result = DropboxHelper.contentsOfDirectoryAtPath(path: NSTemporaryDirectory())
        XCTAssert((result.filenames?.count)! > 0)
    }

    func test_ContentsOfDirectoryAtPath_I(){
        let invalidUrl = NSURL(fileURLWithPath: "file:///invalid")
        let result = DropboxHelper.contentsOfDirectoryAtPath(path: "\(invalidUrl)")
        XCTAssert(result.filenames == nil && result.error != nil)
    }

    func test_ContentsOfDirectoryAtPath_Empty(){
        let result = DropboxHelper.contentsOfDirectoryAtPath(path: "\(NSHomeDirectory())/Documents")
        XCTAssertEqual(result.filenames?.count, 0)
    }
    
    func test_Upload_V(){
        DropboxHelper.sendStoredSurveysToDropbox()
        XCTAssert(true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
