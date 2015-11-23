//
//  Team.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/20/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

class Team {
    
    // MARK: Properties
    
    var id: Int?
    var name: String?
    
    // MARK: Initialization
    
    init() {}
    
    init(id: Int, name: String) {
        setAttributes(id, name: name)
    }
    
    // MARK: Functions
    
    func setAttributes(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    /**
        Gets the team info from the team id
    */
    func getTeamInfo(id: Int, callback: (NSDictionary?, String?) -> Void) {
        println("in getTeamInfo")
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/teams/\(id)")))
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let token = NSUserDefaults.standardUserDefaults().stringForKey("myezteamToken")
        println("token = \(token!)")
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            //println("error = \(error)")
            //println("response = \(response)")
            //println("data = \(NSString(data: data, encoding: NSASCIIStringEncoding))")
            
            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                //var result = NSString(data: data, encoding: NSASCIIStringEncoding)
                //let newData: NSDictionary = data
                var teamInfo: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                callback(teamInfo, nil)
            }
        }
        task.resume()
    }
}
