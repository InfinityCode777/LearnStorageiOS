//
//  ViewController.swift
//  TextFileReadAndWrite
//
//  Created by Jing Wang on 2/11/19.
//  Copyright © 2019 Jing Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var savedString: String = ""
    var localDict = [String: String]()
    var fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBtn.setTitle(F8LocaleStrings.continueNext.localized, for: .normal)
        
        print("System preferred languages >> \(Locale.preferredLanguages)")
        
        //        print("Path = \(FileManager.documentDirectoryURL.path)")
        print("Main bundle = \(Bundle.main.bundlePath)")
        
        let bundleURL = Bundle.main.bundleURL
        let resourceURL = Bundle.main.resourceURL
        
        //        print("mainBundleURL = \(bundleURL)")
        //        print("resourceURL = \(resourceURL)")
        var localeFileURLList = [URL]()
        
        do {
            localeFileURLList = try fileManager.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: [])
        } catch {
            print("Error in fetch localization files under path \(Bundle.main.bundlePath)")
        }
        
        let bundleContents = localeFileURLList.map( {$0.lastPathComponent})
        
        print("Bundle Contents >> \(bundleContents)")
        
        var supportedLanguageNameList = bundleContents.filter( {$0.contains(".lproj") && !$0.contains("Base")})
        supportedLanguageNameList = supportedLanguageNameList.map( {$0.replacingOccurrences(of: ".lproj", with: "")} )

        print("Supported Languages >> \(supportedLanguageNameList)")
        

        // Get URLs of all language package under main bundle i.e. [APP_NAME].APP/
        var supportedLangURLList = localeFileURLList.filter( {$0.lastPathComponent.contains(".lproj") && !$0.lastPathComponent.contains("Base")} )

        
//        var langContentURLList = [URL]()
//
//        do {
//            langContentURLList = try fileManager.contentsOfDirectory(at: supportedLangURLList[0], includingPropertiesForKeys: nil, options: [])
//        } catch {
//            print("Error in fetch localization files under path \(Bundle.main.bundlePath)")
//        }

        
        
//        for supportedLangURL in supportedLangURLList {
        
            if let supportedLangBundle = Bundle(url: supportedLangURLList[1]) {
                
                
                for localeKey in F8LocaleStrings.allCases {
                    print("\"\(localeKey.rawValue)\" = \"\(localeKey.rawValue.localized(bundle: supportedLangBundle))\"")
                }
            } else {
                print("Could not convert supported language URL to bundle!")
            }
            
//        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        do {
            if let savedString = try read("TextSample", fileExtension: "txt", from: bundleURL) {
                self.savedString = savedString
                print("Saved String = \(self.savedString)")
            }
        } catch {
            print("Error reading file! >> \(error)")
        }
        
        
        
        if let fileName = Bundle.main.url(forResource: "TextSample", withExtension: "strings") {
            if let textNSDict = NSDictionary(contentsOf: fileName) {
                if let textDict = textNSDict as? [String: String] {
                    //                    print("textDict[\"doneText\"] = \(textDict["doneText"]))")
                    localDict = textDict
                }
                //                print("textNSDict[\"otherActivity\"] = \(textNSDict.object(forKey: "otherActivity"))")
            }
        }
        
//                var outputText: String?
//
//                for f8LocalKey in F8LocaleStrings.allCases {
//        //            outputText = ""
//                    outputText = nil
//                    for localItem in localDict {
//                        if localItem.key == f8LocalKey.rawValue {
//                            outputText = "Found match for key #\(f8LocalKey)# "
//                            if !localItem.value.isEmpty {
//                                outputText?.append("with value @\(f8LocalKey.rawValue)@")
//                                break
//                            }
//                        }
//                    }
//                    print(outputText == nil ? "Not found match for key #\(f8LocalKey.rawValue)#": outputText!)
//                }
//
//
    }
    
    
    
    private func read(_ fileName: String, fileExtension: String = "", from url: URL = FileManager.documentDirectoryURL) throws -> String? {
        var fileURL = url.appendingPathComponent(fileName)
        if !fileExtension.isEmpty {
            fileURL = fileURL.appendingPathExtension(fileExtension)
        }
        
        let savedString = try String(contentsOf: fileURL, encoding: .utf8)
        return savedString
    }
    
}


public extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
