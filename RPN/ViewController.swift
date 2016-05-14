//
//  ViewController.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/7/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var firstNameTextField: UITextField?
    @IBOutlet weak var lastNameTextField: UITextField?
    @IBOutlet weak var tableView: UITableView?
    var managedObjectContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedObjectContext = DataController().managedObjectContext
        if let managedObjectContextWrapped = self.managedObjectContext {
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: UserModel.fetchResultRequestAllUsers(), managedObjectContext: managedObjectContextWrapped, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try self.fetchedResultsController?.performFetch()
                self.fetchedResultsController!.delegate = self;
            }
            catch {
                print("Problems")
            }
            
                self.tableView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped() {
        if let managedObjectContextWrapped = self.managedObjectContext {
            let userModel = UserModel.createUser(managedObjectContextWrapped)
            userModel.firstName = self.firstNameTextField!.text
            userModel.lastName = self.lastNameTextField!.text
            
            let newCar = Car.createCar(managedObjectContextWrapped)
            newCar.color = "Red"
            newCar.volume = "Big"
            userModel.car = NSSet(object: newCar)
            
            do {
                try managedObjectContextWrapped.save()
                
            } catch {
                print("Big problems")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fetchedResultsController?.fetchedObjects?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultTableCell")
        let userModel = self.fetchedResultsController!.fetchedObjects![indexPath.row] as! UserModel
        cell?.textLabel!.text = userModel.firstName
        cell?.detailTextLabel!.text = userModel.lastName
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let userModel = self.fetchedResultsController!.fetchedObjects![indexPath.row] as! UserModel
        self.managedObjectContext?.deleteObject(userModel)
        do {
            try self.managedObjectContext?.save()
        }
        catch {
            print("Problems")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = self.fetchedResultsController!.fetchedObjects![indexPath.row] as! UserModel
        self.performSegueWithIdentifier("CarsSegue", sender: user)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = indexPath {
                tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            else if let indexPath = newIndexPath {
                tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            tableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView?.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)

        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CarsSegue" {
            let nextVC = segue.destinationViewController as? CarsViewController
            nextVC!.user = sender as? UserModel
        }
    }

}

