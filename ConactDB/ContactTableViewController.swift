//
//  ContactTableViewController.swift
//  ConactDB
//
//  Created by Charles Konkol on 2/26/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ContactTableViewController: UITableViewController, UITableViewDelegate {
    
    var contactArray = [NSManagedObject]()

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loaddb()
    {
        //       //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Contact")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            contactArray = results
            tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCellWithIdentifier("Cell")
            as UITableViewCell
        
        let person = contactArray[indexPath.row]
        cell.textLabel.text = person.valueForKey("fullname") as String?
        cell.detailTextLabel?.text = ">>"
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You selected cell #\(indexPath.row)")
    }
  
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //       //1
            let appDelegate =
            UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext!
            context.deleteObject(contactArray[indexPath.row])
            var error: NSError? = nil
            if !context.save(&error) {
                println("Unresolved error \(error)")
                abort()
            }
            else
            {
                loaddb()
            }
        }
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if segue.identifier == "UpdateContacts" {
                if let destination = segue.destinationViewController as? ContactViewController {
                    if let SelectIndex = tableView.indexPathForSelectedRow()?.row {
 
                        let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                            destination.contactdb = selectedDevice
                    }
                }
            }
         
        }
  
        
    
 

}
