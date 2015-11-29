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
    static func getTeamInfo(id: Int, callback: (NSDictionary?, String?) -> Void) throws {

        let request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/teams/\(id)"))!)
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
                let teamInfo: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                callback(teamInfo, nil)
            }
        }
        task.resume()
    }

}
