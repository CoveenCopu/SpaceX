//
//  ViewModel.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

struct SavedLaunchRef {
    let id: String
    let savedAt: Date
}

@MainActor
class ViewModel: ObservableObject {
    
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }
    
    // Status
    private(set) var allLaunchesStatus: FetchStatus = .notStarted
    private(set) var allLaunchpadsStatus: FetchStatus = .notStarted
    private(set) var specificLaunchStatus: FetchStatus = .notStarted
    private(set) var savedLaunchesStatus: FetchStatus = .notStarted
    
    private let db = Firestore.firestore()
    private let dataFetcher = DataFetcher()
    
    // Published: opdaterer UI automatisk, når værdierne ændres
    @Published var allLaunches: [Launch] = []
    @Published var savedLaunches: [Launch] = []
    @Published var crewMembers: [Person] = []
    @Published var rocket: Rocket? = nil
    @Published var capsules: [Capsule] = []
    @Published var launchPad: LaunchPad? = nil
    @Published var allLaunchpads: [LaunchPad] = []
    
    // Specific launch data - Funktion
    func getDataForSpecificLaunch(capsuleIds: [String], rocketId: String, crewIds: [String], launchPadId: String) async {
        specificLaunchStatus = .fetching
        do {
            if !crewIds.isEmpty {
                var loadedCrew: [Person] = []
                for id in crewIds {
                    let person = try await dataFetcher.fetchPerson(id: id)
                    loadedCrew.append(person)
                }
                crewMembers = loadedCrew
            }
            else {
                crewMembers = []
            }
            
            launchPad = try await dataFetcher.fetchLaunchPad(launchPadId)
            
            if !rocketId.isEmpty {
                rocket = try await dataFetcher.fetchRocket(id: rocketId)
            }
            else {
                rocket = nil
            }
            
            if !capsuleIds.isEmpty {
                var loadedCapsules: [Capsule] = []
                for id in capsuleIds {
                    let capsule = try await dataFetcher.fetchCapsule(id: id)
                    loadedCapsules.append(capsule)
                }
                capsules = loadedCapsules
            }
            else {
                capsules = []
            }
            
            specificLaunchStatus = .success
        } catch {
            specificLaunchStatus = .failed(underlyingError: error)
        }
    }
    
    // All launches - Funktion
    func getLaunches() async {
        allLaunchesStatus = .fetching
        do {
            let launches = try await dataFetcher.fetchLaunches()
            allLaunches = launches
            allLaunchesStatus = .success
        } catch {
            allLaunchesStatus = .failed(underlyingError: error)
        }
    }
    
    // Save favorites in Firestore - Funktion
    func saveLaunch(launch: Launch) {
        let userId = Auth.auth().currentUser?.uid ?? "unknown"
        let docRef = db.collection("users").document(userId)
        
        docRef.setData([
            "favorites": FieldValue.arrayUnion([launch.id])
        ], merge: true)
    }
    
    // Remove favorites in Firestore - Funktion
    func removeFavorite(_ launchId: String) async throws {
        let userId = Auth.auth().currentUser?.uid ?? "unknown"
        let docRef = db.collection("users").document(userId)
        
        try await docRef.updateData([
            "favorites": FieldValue.arrayRemove([launchId])
        ])
    }
    
    // Get favorites in Firestore - Funktion
    func getSavedLaunchRefs() async -> [String] {
        let userId = Auth.auth().currentUser?.uid ?? "unknown"
        do {
            let snapshot = try await db.collection("users").document(userId).getDocument()
            let favorites = snapshot.get("favorites") as? [String] ?? []
            return favorites
        } catch {
            print("Failed to fetch favorites:", error)
            return []
        }
    }
    
    // Load saved launches from API - Funktion
    func loadSavedLaunches() async {
        savedLaunchesStatus = .fetching
        let favoriteIds = await getSavedLaunchRefs()
        
        var launches: [Launch] = []
        for id in favoriteIds {
            do {
                let launch = try await dataFetcher.fetchLaunch(id: id)
                launches.append(launch)
            } catch {
                print("Failed to fetch launch \(id):", error)
            }
        }
        
        await MainActor.run {
            self.savedLaunches = launches
            self.savedLaunchesStatus = .success
        }
    }
    
    // Toggle favorite lokalt + Firestore - Funktion
    func toggleFavorite(_ launch: Launch) async {
        if savedLaunches.contains(where: { $0.id == launch.id }) {
            savedLaunches.removeAll { $0.id == launch.id }
            try? await removeFavorite(launch.id)
        } else {
            savedLaunches.append(launch)
            saveLaunch(launch: launch)
        }
    }
    
    // Get all launchpads from API - Funktion
    func getAllLaunchpads() async {
        allLaunchpadsStatus = .fetching
        do {
            allLaunchpads = try await dataFetcher.fetchLaunchPads()
            allLaunchpadsStatus = .success
        } catch {
            allLaunchpadsStatus = .failed(underlyingError: error)
        }
    }
}

