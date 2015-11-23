//
//  User.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/17/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

class User {
    
    // MARK: Properties
    var email: String
    var password: String
    
    // Mark: Initialization
    init(email: String, password: String) {
        self.email = email
        self.password = password
        
        // Initialization should fail if there is no name or if the rating is negative.
//        if email.isEmpty || password.isEmpty {
//            return nil
//        }
    }
    
    // MARK: Functions
    
    /**
        Authenticates a user and returns a token
    */
    func authenticate(callback: (String, String?) -> Void) {
        //println("in authenticate")
        
        let body = [
            "email": self.email,
            "password": self.password
        ] as Dictionary<String, String>
        
        var request = NSMutableURLRequest(URL: NSURL(string: Constants.makeUrl("/auth/login")))
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.allZeros, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("Bearer 6cfee427-e2cc-4ba7-89c0-8dbfda2ce6b4", forHTTPHeaderField: "Authorization")
        
        //println("request.httpbody = \(request)")
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            println("data = \(data)")
            println("response = \(response)")
            println("error = \(error)")
            
            if error != nil {
                callback("", error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding: NSASCIIStringEncoding)
//                println("DATAAA = \(data)")
//                println("RESULT = \(result)")
                let newData: NSData = data
                var result2: NSDictionary = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                let token: AnyObject? = result2["token"]!
                
                //var json: AnyObject? = result2.parseAs
//                println("result2 = \(result2)")
                println("authenticate token = \(token)")
                
                callback(token as NSString, nil)
            }
        }
        task.resume()
    }
}