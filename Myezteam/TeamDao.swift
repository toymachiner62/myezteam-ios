//
//  TeamDao.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/24/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

struct TeamDao {
    
    // MARK: Functions
    
    /**
        Gets the team info from the team id
    */
    static func getTeamInfo(id: Int, callback: (NSDictionary?, String?) -> Void) {

        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/teams/\(id)")))
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
                var teamInfo: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                callback(teamInfo, nil)
            }
        }
        task.resume()
    }

}
