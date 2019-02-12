//
//  TextFileReadAndWriteTests.swift
//  TextFileReadAndWriteTests
//
//  Created by Jing Wang on 2/11/19.
//  Copyright © 2019 Jing Wang. All rights reserved.
//
//import Foundation
import XCTest

@testable import TextFileReadAndWrite

class TextFileReadAndWriteTests: XCTestCase {
    
    let expectedSupportedLangNameList: [String] = ["en", "zh-Hans"]
    let testUnsupportedLangNameList: [String] = ["zh-Hant", "es", "ru"]
    
    var fileManager = FileManager.default
    var bundleContentURLs = [URL]()
    var supportedLangNameList = [String]()
    var supportedLangURLs = [URL]()
    
    override func setUp() {
        // Refer to the following two links for iso language code
        // https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
        // https://en.wikipedia.org/wiki/ISO_15924
        
        
        do {
            bundleContentURLs = try fileManager.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("Error in fetch localization files under path \(Bundle.main.bundlePath)")
        }
        
        // Get URLs of all language package under main bundle i.e. [APP_NAME].APP/
        supportedLangURLs = bundleContentURLs.filter( {$0.lastPathComponent.contains(".lproj") && !$0.lastPathComponent.contains("Base")} )
        // Get names of all components under main bundle i.e. [APP_NAME].APP/
        let bundleContentList = bundleContentURLs.map( {$0.lastPathComponent})
        // Search for names of all language packages, which ends with ".lproj". Also remove name for base language package
        supportedLangNameList = bundleContentList.filter( {$0.contains(".lproj") && !$0.contains("Base")} )
        // Remove ".lproj" extension
        supportedLangNameList = supportedLangNameList.map( {$0.replacingOccurrences(of: ".lproj", with: "")} )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSupportedLanguages() {
        // This is a test to veify whether the [LANUAGE_CODE].strings file for supported language [LANUAGE_CODE] should exist, test fails the corresponding file is not found
        
        for supportedLang in supportedLangNameList {
            XCTAssertTrue(expectedSupportedLangNameList.contains(supportedLang), "Could not find localization file for supported language \(supportedLang)!")
        }
    }
    
    
    func testUnsupportedLanguages() {
        // This is a test to veify whether the [LANUAGE_CODE].strings file for unsupported language [LANUAGE_CODE] should not exist, test fails the corresponding file is found
        
        for unsupportedLang in testUnsupportedLangNameList {
            
            XCTAssertFalse(supportedLangNameList.contains(unsupportedLang), "Do not support language \(unsupportedLang)!")
        }
    }
    
    
    func testLocaleKeyValuePair() {
        
        for localeKey in F8LocaleStrings.allCases {
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
