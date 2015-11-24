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
        
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/events")))
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let token = NSUserDefaults.standardUserDefaults().stringForKey("myezteamToken")
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in

            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                let newData: NSData = data
                var upcomingEvents: NSArray = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
                callback(upcomingEvents, nil)
            }
        }
        task.resume()
    }

}