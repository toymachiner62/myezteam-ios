//
//  constants.swift
//  Myezteam
//
//  Created by Caflisch, Thomas J. (Tom) on 11/18/15.
//  Copyright (c) 2015 Tom Caflisch. All rights reserved.
//

import Foundation

struct Constants {
    static let baseUrl = "http://ws.myezteam.com/v1"
    static let apiKey = "?api_key=9c0ba686-e06c-4a2c-821b-bae2a235fd3d"
    
    /**
        Creates a url with the passed in path
    */
    static func makeUrl(path: String) -> String {
        let url: String = baseUrl + path + apiKey
        return url
    }
}
