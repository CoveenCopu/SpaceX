//
//  DataFetcher.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import Foundation

struct DataFetcher {
    
    // Hent en launchpad via ID fra API - Funktion
    func fetchLaunchPad(_ id: String) async throws -> LaunchPad {
        let url = URL(string: "https://api.spacexdata.com/v4/launchpads/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(LaunchPad.self, from: data)
    }
    
    // Hent alle launchpads fra API - Funktion
    func fetchLaunchPads() async throws -> [LaunchPad] {
        let url = URL(string: "https://api.spacexdata.com/v4/launchpads")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        
        let launchpads = try decoder.decode([LaunchPad].self, from: data)
        return launchpads
    }
    
    // Hent alle launches fra API - Funktion
    func fetchLaunches() async throws -> [Launch] {
        let url = URL(string: "https://api.spacexdata.com/v5/launches")!
        let (data, response) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
         decoder.dateDecodingStrategy = .iso8601
        
        let launches = try decoder.decode([Launch].self, from: data)
        return launches
    }
    
    // Hent en kapsel via ID fra API - Funktion
    func fetchCapsule(id: String) async throws -> Capsule {
        let url = URL(string: "https://api.spacexdata.com/v4/capsules/" + id)!
        let (data, response) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        
        let capsule = try decoder.decode(Capsule.self, from: data)
        return capsule
    }
    
    // Hent en launch via ID fra API - Funktion
    func fetchLaunch(id: String) async throws -> Launch {
        let url = URL(string: "https://api.spacexdata.com/v5/launches/" + id)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
         decoder.dateDecodingStrategy = .iso8601
        
        let launch = try decoder.decode(Launch.self, from: data)
        return launch
    }
    
    // Hent en raket via ID fra API - Funktion
    func fetchRocket(id: String) async throws -> Rocket {
        let url = URL(string: "https://api.spacexdata.com/v4/rockets/" + id)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
       
        let rocket = try decoder.decode(Rocket.self, from: data)
        return rocket
    }
    
    // Hent et crew-medlem via ID fra API - Funktion
    func fetchPerson(id: String) async throws -> Person {
        let url = URL(string: "https://api.spacexdata.com/v4/crew/" + id)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        let person = try decoder.decode(Person.self, from: data)
        return person
    }
}
