
import Foundation
import UIKit
import os.log
import MapKit

class Hotel: NSObject, NSCoding{
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var comment: String
    var coordinate: CLLocationCoordinate2D?
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let comment = "comment"
//        static let longitude = "longitude"
//        static let latitude = "latitude"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hotels")
    
    //MARK: Initialisation
    init?(name: String, photo: UIImage?, rating:Int, comment: String, coordinate: CLLocationCoordinate2D? = nil) {
        
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        //The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //Initialise stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        self.comment = comment
        self.coordinate = coordinate
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(comment, forKey: PropertyKey.comment)
//        aCoder.encode(coordinate?.longitude ?? 0.0, forKey: PropertyKey.longitude)
//        aCoder.encode(coordinate?.latitude ?? 0.0, forKey: PropertyKey.latitude)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
            os_log("Unable to decode the name for a Hotel object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let comment = aDecoder.decodeObject(forKey: PropertyKey.comment) as? String
            else {
                os_log("Unable to decode the comment for a Hotel object.", log: OSLog.default, type: .debug)
                return nil }
        
        // Because photo is an optional property of Hotel, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
//       let longitude = aDecoder.decodeDouble(forKey: PropertyKey.longitude)
//        let latitude = aDecoder.decodeDouble(forKey: PropertyKey.latitude)
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, comment: comment )
        
    }
    
}

