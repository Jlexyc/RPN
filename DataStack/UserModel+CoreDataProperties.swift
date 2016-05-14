//
//  UserModel+CoreDataProperties.swift
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

extension UserModel {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var age: NSNumber?
    @NSManaged var dateOfBirth: NSDate?
    @NSManaged var isMale: NSNumber?
    @NSManaged var car: NSSet?

    static func entityName() -> String {
        return "User"
    }
    
    static func fetchResultRequestAllUsers() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        return fetchRequest
    }
    static func allUserModels(inContext: NSManagedObjectContext) -> Array<UserModel> {
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        var returnValue: Array<UserModel>
        do {
            returnValue = try inContext.executeFetchRequest(fetchRequest) as! Array<UserModel>
        }
        catch {
            returnValue = [];
        }
        
        return returnValue
    }
    
    static func createUser(inContext: NSManagedObjectContext) -> UserModel {
        return NSEntityDescription.insertNewObjectForEntityForName(UserModel.entityName(), inManagedObjectContext: inContext) as! UserModel
    }
    
}
