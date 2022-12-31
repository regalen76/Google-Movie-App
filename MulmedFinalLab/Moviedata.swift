//
//  Movie.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import CoreData

@objc(Moviedata)
class Moviedata: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var genre: String!
    @NSManaged var length: String!
    @NSManaged var releasedate: String!
    @NSManaged var rating: NSNumber!
    @NSManaged var deletedDate: Date?
}
