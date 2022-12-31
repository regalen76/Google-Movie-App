import CoreData

@objc(Userdata)
class Userdata: NSManagedObject{
    @NSManaged var username: String!
    @NSManaged var password: String!
    @NSManaged var isadmin: NSNumber!
}
