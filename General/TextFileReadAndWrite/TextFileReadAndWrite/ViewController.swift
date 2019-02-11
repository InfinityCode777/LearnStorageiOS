//
//  ViewController.swift
//  TextFileReadAndWrite
//
//  Created by Jing Wang on 2/11/19.
//  Copyright © 2019 Jing Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var savedString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Path = \(FileManager.documentDirectoryURL.path)")
        print("Main bundle = \(Bundle.main.bundlePath)")
        
        let bundleURL = Bundle.main.bundleURL
        let resourceURL = Bundle.main.resourceURL
        
        print("mainBundleURL = \(bundleURL)")
        print("resourceURL = \(resourceURL)")
        
        
        // Do any additional setup after loading the view, typically from a nib.
        do {
            if let savedString = try read("TextSample", fileExtension: "txt", from: bundleURL) {
                self.savedString = savedString
                print("Saved String = \(self.savedString)")
            }
        } catch {
            print("Error reading file! >> \(error)")
        }
        
        
    }
    
    
    
    private func read(_ fileName: String, fileExtension: String = "", from url: URL = FileManager.documentDirectoryURL) throws -> String? {
        var fileURL = url.appendingPathComponent(fileName)
        if !fileExtension.isEmpty {
            fileURL = fileURL.appendingPathExtension(fileExtension)
        }
        
        let savedString = try String(contentsOf: fileURL, encoding: .utf8)
        //        let savedString = try String(contentsOfFile: fileURL.path, encoding: .utf8)
        //        let savedString = try String(contentsOfFile: fileURL.path, encoding: String.Encoding.init(rawValue: 4))
        return savedString
    }
    
}


public extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
