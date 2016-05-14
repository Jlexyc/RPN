//
//  CarDetailsViewController.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/13/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import UIKit
import CoreData

class CarDetailsViewController: UIViewController {

    @IBOutlet weak var colorField: UITextField?
    @IBOutlet weak var volumeField: UITextField?
    @IBOutlet weak var tradeMarkField: UITextField?
    var managedObjectContext: NSManagedObjectContext?
    var car: Car?
    var user: UserModel?
    
    override func viewDidLoad() {
        self.managedObjectContext = DataController().managedObjectContext
        if self.car != nil {
            self.colorField?.text = car?.color ?? ""
            self.volumeField?.text = car?.volume ?? ""
            self.tradeMarkField?.text = car?.tradeMark == nil ? car?.tradeMark?.stringValue : ""
        }
    }
    
    @IBAction func saved() {
        if self.car == nil {
            self.car = Car.createCar((self.user?.managedObjectContext)!)
        }
        self.car?.color = self.colorField!.text
        self.car?.tradeMark = Int(self.tradeMarkField!.text!) ?? 0
        self.car?.volume = self.volumeField!.text
        self.car?.user = self.user
        do {
            try (self.user?.managedObjectContext)!.save()
        }
        catch {
            print("Problems")
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
