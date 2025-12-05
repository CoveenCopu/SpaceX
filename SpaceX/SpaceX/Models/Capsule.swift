//
//  Capsule.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import Foundation

struct Capsule: Decodable, Identifiable {
    var id: String?
    var serial: String?
    var status: String?
    var type: String?
    var waterLandings: Int?
    var landLandings: Int?
    var lastUpdate: String?
    var launches: [String]?
}
