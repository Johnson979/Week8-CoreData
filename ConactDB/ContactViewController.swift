//
//  ContactViewController.swift
//  ConactDB
//
//  Created by Charles Konkol on 2/26/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    
   var contactdb:NSManagedObject!
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBOutlet weak var fullname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    
    @IBAction func btnSave(sender: UIButton) {
        if (contactdb != nil)
        {
            
            contactdb.setValue(fullname.text, forKey: "fullname")
             contactdb.setValue(email.text, forKey: "email")
            contactdb.setValue(phone.text, forKey: "phone")
           
        }
        else
        {
        let entityDescription =
        NSEntityDescription.entityForName("Contact",
            inManagedObjectContext: managedObjectContext!)
        
        let contact = Contact(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        contact.fullname = fullname.text
        contact.email = email.text
        contact.phone = phone.text
        }
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            status.text = err.localizedFailureReason
        } else {
           self.dismissViewControllerAnimated(false, completion: nil)
           
        }
            
    }
    
    @IBAction func btnFind(sender: UIButton) {
        let entityDescription =
        NSEntityDescription.entityForName("Contact",
            inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(fullname = %@)", fullname.text)
        request.predicate = pred
        
        var error: NSError?
        
        var objects = managedObjectContext?.executeFetchRequest(request,
            error: &error)
        
        if let results = objects {
            
            if results.count > 0 {
                let match = results[0] as NSManagedObject
                
                fullname.text = match.valueForKey("fullname") as String
                email.text = match.valueForKey("email") as String
                phone.text = match.valueForKey("phone") as String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //forces resign first responder and hides keyboard
        DismissKeyboard()
    }
    func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        fullname.endEditing(true)
         email.endEditing(true)
         phone.endEditing(true)
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     if (contactdb != nil)
     {
        fullname.text = contactdb.valueForKey("fullname") as String
        email.text = contactdb.valueForKey("email") as String
        phone.text = contactdb.valueForKey("phone") as String
         btnSave.setTitle("Update", forState: UIControlState.Normal)
        }
         fullname.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
