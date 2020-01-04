//
//  Order+CoreDataProperties.swift
//  PizzaOrders
//
//  Created by Jay Phillips on 1/3/20.
//  Copyright © 2020 Jay Phillips. All rights reserved.
//
//

import SwiftUI
import CoreData


extension Order: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var numberOfSlices: Int16
    @NSManaged public var tableNumber: String
    @NSManaged public var status: String
    
    var orderStatus: Status {
        set {status = newValue.rawValue}
        get {Status(rawValue: status) ?? .pending}
        
    }
    

}

enum Status: String {
    case pending = "Pending"
    case preparing = "Preparing"
    case completed = "Completed"
}
