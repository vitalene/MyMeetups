//  Copyright © 2016 Neil Vitale. All rights reserved.

import Foundation
import CoreData

class CityAPI {
    
    enum CitiesResult {
        case success([City])
        case failure(Error)
    }
    enum cityError: Error {
        case badData
    }
    
    
    fileprivate static let baseURLString = "https://api.meetup.com"
    
    
    fileprivate class func flickrURL(method: Method,
                                     parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "city" : "blah blah",
            "metadata1" : "whatever2",
            ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components?.queryItems = queryItems
        return components!.url!
    }
    
    class func citiesFromJSONData(_ data: Data, inContext context: NSManagedObjectContext) -> CitiesResult {
        
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [AnyHashable: Any],
                let cityArray = jsonDictionary["city"] as? [String:AnyObject],
                let countryArray = city["country"] as? [[String:AnyObject]]
                else {
                    return .failure(cityError.badData)
            }
            
            var finalCities = [City]()
            
            for cityJSON in cityArray {
                if let city = citiesFromJSONData(cityJSON, inContext: context) {
                    finalCities.append(city)
                }
            }
        } catch let error {
            return CitiesResult.failure(error)
        }
    }

    fileprivate class func cityFromJSONObject(_ json: [String : AnyObject],
                                               inContext context: NSManagedObjectContext) -> City? {
        guard let
            cityName = json["city"] as? String,
            let countryName = json["country"] as? String
            else {
                //not enough information to make a city
                return nil
        }
    
        let fetchRequest: NSFetchRequest<City> = NSFetchRequest<City>  (entityName: "City")
        
        var fetchedCities: [City]!
        context.performAndWait {
            fetchedCities = try! context.fetch(fetchRequest)

        }
        if fetchedCities.count > 0 {
            return fetchedCities.first
        }
        
        var city: City!
        context.performAndWait {
            city = NSEntityDescription.insertNewObject(forEntityName: "city", into: context) as! City
        }
        return city
        
    }
    
}
