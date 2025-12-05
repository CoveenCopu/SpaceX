//
//  Person.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import Foundation

struct Person: Decodable, Identifiable {
    var id: String?
    var name: String?
    var agency: String?
    var image: String?
    var launches: [String]?
    var status: String?
}
