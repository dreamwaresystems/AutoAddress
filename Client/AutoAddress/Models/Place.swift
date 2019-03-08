//
//  Place.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation

// codable places API response
struct PlaceResponse: Codable {
    var status: String
    var error: String?
    var list: [Place]
}

// base place object
struct Place: Codable {
    var id: String
    var desc: String
    var match_length: Int
    var match_offset: Int
    var place_id: String
    var structured_main: String
    var structured_second: String
    var types: String?
}
