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
    
    init(id: Int, name: String) {
        setAttributes(id, name: name)
    }
    
    // MARK: Functions
    
    func setAttributes(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
