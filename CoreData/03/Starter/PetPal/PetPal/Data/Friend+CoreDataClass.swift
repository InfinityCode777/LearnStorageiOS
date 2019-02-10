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


public class Friend: NSManagedObject {
    var age: Int? {
        
        if let dob = self.dob {
            return Calendar.current.dateComponents([.year], from: dob as Date, to: Date()).year
        }
        
        return nil
    }
}
