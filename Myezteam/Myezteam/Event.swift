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
    var team: String?
    var time: String?
    
    // MARK: Initialization
    
    init() {
        
    }
    
    init(game: String, team: String, time: String) {
        setAttributes(game, team: team, time: time)
        
        // Initialization should fail if there is no name or if the rating is negative.
        //        if email.isEmpty || password.isEmpty {
        //            return nil
        //        }
    }
    
    func setAttributes(game: String, team: String, time: String) {
        
        println("game = \(game)")
        println("team = \(team)")
        println("time = \(time)")
        self.game = game
        self.team = team
        self.time = time
        
    }
    
    // MARK: Functions
    func getUpcoming(callback: (NSArray?, String?) -> Void) {
        
        //println("In get upcoming")
        
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/events")))
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer 6cfee427-e2cc-4ba7-89c0-8dbfda2ce6b4", forHTTPHeaderField: "Authorization")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            //println("data = \(data)")
            //println("response = \(response)")
            //println("error = \(error)")
            
            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding: NSASCIIStringEncoding)
                //println("result = \(result)")
              
                let newData: NSData = data
                //println("before")
                var upcomingEvents: NSArray = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
                //println("FIRST EVENT = \(upcomingEvents[0])")
                //println("after")
              
                callback(upcomingEvents, nil)
            }

        }
        task.resume()
    }
}