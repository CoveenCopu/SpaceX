//
//  LaunchPad.swift
//  SpaceX
//
//  Created by dmu mac 26 on 03/12/2025.
//

import Foundation

struct LaunchPad: Decodable, Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let launches: [String]
 

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case launches
    }
}
