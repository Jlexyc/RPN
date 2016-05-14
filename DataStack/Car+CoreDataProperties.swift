//
//  Car+CoreDataProperties.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/10/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Car {

    @NSManaged var tradeMark: NSNumber?
    @NSManaged var volume: String?
    @NSManaged var color: String?
    @NSManaged var user: UserModel?
    
    static func entityName() -> String {
        return "Car"
    }
    
    static func createCar(inContext: NSManagedObjectContext) -> Car {
        return NSEntityDescription.insertNewObjectForEntityForName(Car.entityName(), inManagedObjectContext: inContext) as! Car
    }
}
