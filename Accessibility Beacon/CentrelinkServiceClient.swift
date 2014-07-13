//
//  CentrelinkServiceClient.swift
//  Accessibility Beacon
//
//  Created by Jake MacMullin on 12/07/2014.
//  Copyright (c) 2014 Stripy Sock Software. All rights reserved.
//

import Foundation

class CentrelinkServiceClient {
    func getLocationInfo(identifer: NSInteger, completion:(LocationInfo)->Void) {

        let url = NSURL.URLWithString("http://data.gov.au/api/action/datastore_search_sql?sql=SELECT%20*%20from%20%221a257286-a274-4288-ad11-f40e104827ad%22%20WHERE%20_id%20=%20'\(identifer)'")
        let request = NSURLRequest(URL: url)
        let urlSession = NSURLSession.sharedSession()
        let dataTask = urlSession.dataTaskWithRequest(request) {
            (var data, var response, var error) in
            
            var info = LocationInfo()
            
            if (!error) {
                var parseError : NSError?
                let unparsedObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) as NSDictionary
                let result = unparsedObject["result"] as NSDictionary
                let records = result["records"] as NSArray
                let firstRecord = records[0] as NSDictionary
                
                info.name = firstRecord["SITE NAME"] as String
                info.address = firstRecord["ADDRESS"] as String
                
                // TODO: get the descriptions from the data.gov.au data once it has been 
                // updated with accessibility descriptions
                if (identifer == 4) {
                    info.accessibilityDescription = "The customer service representatives are behind a counter 10 metres away directly in front of the door. There is a waiting area on the right hand side of the room with a number of chairs. There are public toilets through a door on the left hand side of the room."
                } else {
                    info.accessibilityDescription = "There's a hallway directly in front of the door. The customer service area is through the third door on your left as you walk down the hallway."
                }
                
            }
            
            completion(info)
        }
        dataTask.resume()
    }
}

