//
//  ResponseDao.swift
//  Myezteam
//
//  Created by Tom Caflisch on 12/14/15.
//  Copyright © 2015 Tom Caflisch. All rights reserved.
//

import Foundation

struct ResponseDao {
    
    // MARK: Functions
    
    /**
        Gets the logged in user's response for the id event id passed in
     */
    static func getMineForEvent(id: Int, callback: (NSArray?, String?) -> Void) throws {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/responses/\(id)"))!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let token = NSUserDefaults.standardUserDefaults().stringForKey("myezteamToken")
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if error != nil {
                callback(nil, error!.localizedDescription)
            } else {
                let responses: NSArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                callback(responses, nil)
            }
        }
        task.resume()
    }
    
}