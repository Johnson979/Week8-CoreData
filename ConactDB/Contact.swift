//
//  Contact.swift
//  ConactDB
//
//  Created by Charles Konkol on 2/26/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var fullname: String
    @NSManaged var email: String
    @NSManaged var phone: String

}
