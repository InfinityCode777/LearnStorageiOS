//
//  Friend+CoreDataClass.swift
//  PetPal
//
//  Created by Jing Wang on 2/3/19.
//  Copyright © 2019 Razeware. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class Friend: NSManagedObject {
    var age: Int? {
        if let dob = self.dob {
            return Calendar.current.dateComponents([.year], from: dob as Date, to: Date()).year
        }
        return nil
    }
    
    var eyeColor: String {
        var eyeColorString = "N/A"
        
        if let eyeColor = self.eyecolor as? UIColor {
            
            switch eyeColor {
            case UIColor.black:
                eyeColorString = "Black"
            case UIColor.blue:
                eyeColorString = "Blue"
            case UIColor.brown:
                eyeColorString = "Brown"
            case UIColor.green:
                eyeColorString = "Green"
            case UIColor.gray:
                eyeColorString = "Gray"
            default:
                eyeColorString = "N/A"
            }
        }
        
        return eyeColorString
    }
    

    
}
