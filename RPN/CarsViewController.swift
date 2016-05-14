//
//  CarsViewController.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/13/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import UIKit
import CoreData

class CarsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var user: UserModel?
    var cars: Array<Car>?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if self.user != nil {
            self.cars = self.user?.car?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "tradeMark", ascending: true)]) as? Array<Car>
            self.tableView?.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (self.cars?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCar = self.cars![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell")
        cell?.detailTextLabel!.text = currentCar.color
        cell?.textLabel!.text = currentCar.volume
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let car = self.cars![indexPath.row]
        self.performSegueWithIdentifier("carDetails", sender: car)
    }
    
    @IBAction func createTapped() {
        self.performSegueWithIdentifier("carDetails", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let car = self.cars![indexPath.row]
        car.managedObjectContext?.deleteObject(car)
        do {
            try car.managedObjectContext?.save()
        }
        catch {
            print("Problems")
        }
        if self.user != nil {
            self.cars = self.user?.car?.sortedArrayUsingDescriptors([NSSortDescriptor(key: "tradeMark", ascending: true)]) as? Array<Car>
            self.tableView?.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "carDetails" {
            let nextVC = segue.destinationViewController as? CarDetailsViewController
            if sender != nil {
                nextVC!.car = sender as? Car
            }
            nextVC?.user = self.user
        }
    }

}
