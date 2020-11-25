import Foundation
import CoreData

extension CustomCompany {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomCompany> {
        return NSFetchRequest<CustomCompany>(entityName: "CustomCompany")
    }

    @NSManaged public var arobase: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var sector: String?
    
    public var wrappedArobase: String {
        arobase ?? "Unknown @"
    }
    
    public var wrappedId: String {
        id ?? "Unknown Stock Symbol"
    }
    
    public var wrappedName: String {
        name ?? "Unknown Company Name"
    }
    
    public var wrappedSector: String {
        sector ?? "Unknown Sector"
    }

}

extension CustomCompany : Identifiable {

}
