//
//  Person+CoreDataProperties.swift
//  CoreData-Transformable
//
//  Created by Samuel Folledo on 6/29/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit.UIColor

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var favoriteColor: UIColor
    @NSManaged public var name: String
    @NSManaged public var colors: [UIColor]

}
