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
    
    var name: String
    var team: Team
    var time: String
    var description: String?
    var myResponse: String
    
    // MARK: Initialization
    
    init(name: String, team: Team, time: String, description: String, myResponse: String) {
        self.name = name
        self.team = team
        self.time = time
        self.description = description
        self.myResponse = myResponse
    }
    
}