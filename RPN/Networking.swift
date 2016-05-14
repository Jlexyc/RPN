//
//  Networking.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/14/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import Alamofire
import CoreData

class Networking {

    func updateInformation(inContext: NSManagedObjectContext) {
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let managedObjectContext = inContext
                    let users = UserModel.allUserModels(inContext)
                    for user in users {
                        managedObjectContext.deleteObject(user)
                    }
                    
                    let newUser = UserModel.createUser(managedObjectContext)
                    newUser.firstName = "New Guy"
                    newUser.lastName = "Jhones 2"
                    
                    do {
                        try managedObjectContext.save()
                    }
                    catch {
                        print("problem")
                    }
                    
                }
        }
    }
    
}
