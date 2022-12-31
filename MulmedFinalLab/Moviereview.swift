//
//  Reviewdata.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 31/12/22.
//

import CoreData

@objc(Moviereview)
class Moviereview: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var usernow: String!
    @NSManaged var review: String!
    @NSManaged var rating: NSNumber!
}
