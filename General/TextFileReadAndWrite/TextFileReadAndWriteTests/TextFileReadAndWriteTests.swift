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
    
    // Be very careful to change the following two list for supported/unsupported language
    let expectedSupportedLangNameList: [String] = ["en", "zh-Hans"]
    let testUnsupportedLangNameList: [String] = ["zh-Hant", "es", "ru"]
    
    var fileManager = FileManager.default
    var bundleContentURLList = [URL]()
    var fetchedSupportedLangNameList = [String]()
    
    override func setUp() {
        // Refer to the following two links for iso language code
        // https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
        // https://en.wikipedia.org/wiki/ISO_15924
        
        
        do {
            bundleContentURLList = try fileManager.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("Error in fetch localization files under path \(Bundle.main.bundlePath)")
        }
        
        // Get names of all components under main bundle i.e. [APP_NAME].APP/
        let bundleContentList = bundleContentURLList.map( {$0.lastPathComponent})
        // Search for names of all language packages, which ends with ".lproj". Also remove name for base language package
        fetchedSupportedLangNameList = bundleContentList.filter( {$0.contains(".lproj") && !$0.contains("Base")} )
        // Remove ".lproj" extension
        fetchedSupportedLangNameList = fetchedSupportedLangNameList.map( {$0.replacingOccurrences(of: ".lproj", with: "")} )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSupportedLanguages() {
        // This is a test to veify whether the [LANUAGE_CODE].strings file for supported language [LANUAGE_CODE] should exist, test fails the corresponding file is not found
        
        for supportedLang in fetchedSupportedLangNameList {
            XCTAssertTrue(expectedSupportedLangNameList.contains(supportedLang), "Could not find localization file for supported language \(supportedLang)!")
        }
    }
    
    
    func testUnsupportedLanguages() {
        // This is a test to veify whether the [LANUAGE_CODE].strings file for unsupported language [LANUAGE_CODE] should not exist, test fails the corresponding file is found
        
        for unsupportedLang in testUnsupportedLangNameList {
            XCTAssertFalse(fetchedSupportedLangNameList.contains(unsupportedLang), "Do not support language \(unsupportedLang)!")
        }
    }
    
    
    func testLocaleKeyValuePair() {
        
        for supportedLangName in fetchedSupportedLangNameList {
            // Get URL given supported language name
            if let supportedLangURL = Bundle.main.url(forResource: supportedLangName, withExtension: "lproj") {
                // Get bundle given supported language URL, which is needed to retrieve .strings file
                if let supportedLangBundle = Bundle(url: supportedLangURL) {
                    // Loop through all enum keys
                    for localeKey in F8LocaleStrings.allCases {
                        let isLocalized = !localeKey.rawValue.localized(bundle: supportedLangBundle).contains("*")
                        XCTAssertTrue(isLocalized, "Could not find localized string for key #\(localeKey.rawValue)# under language #\(supportedLangURL.lastPathComponent.replacingOccurrences(of: ".lproj", with: ""))#")
                    }
                } else {
                    XCTFail("Could not convert URL to bundle for language #\(supportedLangName)#!")
                }
            } else {
                XCTFail("Could not find URL for language #\(supportedLangName)#!")
                
            }
        }
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
