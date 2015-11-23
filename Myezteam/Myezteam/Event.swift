//
//  Event.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/18/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

class Event {
    
    // MARK: Properties
    
    var game: String?
    var team: Team?
    var time: String?
    
    // MARK: Initialization
    
    init() {
        self.team = Team()
    }
    
    init(game: String, team: Team, time: String) {
        setAttributes(game, team: team, time: time)
        
        // Initialization should fail if there is no name or if the rating is negative.
        //        if email.isEmpty || password.isEmpty {
        //            return nil
        //        }
    }
    
    // MARK: Functions
    
    /**
        Set the attributes of an event
    */
    func setAttributes(game: String, team: Team, time: String) {
        self.game = game
        self.team = team
        self.time = time
    }
    
    /**
        Get all the upcoming events
    */
    func getUpcoming(callback: (NSArray?, String?) -> Void) {
        
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/events")))
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let token = NSUserDefaults.standardUserDefaults().stringForKey("myezteamToken")
        println("token = \(token!)")
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            //println("data = \(data)")
            println("response = \(response)")
            println("error = \(error)")
            
            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding: NSASCIIStringEncoding)
                //println("result = \(result)")
                let newData: NSData = data
                //println("newData = \(newData)")
                var upcomingEvents: NSArray = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
                //println("upcomingEvents = \(upcomingEvents)")
                callback(upcomingEvents, nil)
            }
        }
        task.resume()
    }
    
}