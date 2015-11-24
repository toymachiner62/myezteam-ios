//
//  User.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/17/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import UIKit

class User {
    
    // MARK: Properties
    var email: String
    var password: String
    
    // Mark: Initialization
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    // MARK: Functions
    
    /**
        Authenticates a user and returns a token
    */
    func authenticate(callback: (String, String?) -> Void) {
        
        let body = [
            "email": self.email,
            "password": self.password
        ] as Dictionary<String, String>
        
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/auth/login")))
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if error != nil {
                callback("", error.localizedDescription)
            } else {
                var result: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                
                let token: String? = result["token"] as String?
                if  token != nil {
                    callback(token!, nil)
                } else {
                    callback("", "ERROR")
                }
            }
        }
        task.resume()
    }
}