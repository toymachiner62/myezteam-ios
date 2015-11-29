//
//  EventDao.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/24/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

struct EventDao {
    
    // MARK: Functions
    
    /**
        Get all the upcoming events
    */
    static func getUpcoming(callback: (NSArray?, String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/events"))!)
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
                    let upcomingEvents: NSArray?
                    do {
                        let newData: NSData = data!
                        upcomingEvents = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                    } catch {
                        upcomingEvents = nil
                    }
                    callback(upcomingEvents, nil)
                }
            }
        
        
        task.resume()
        
    }

}