//
//  AuthService.swift
//  SpaceX
//
//  Created by dmu mac 26 on 03/12/2025.
//

import Foundation
import FirebaseAuth

class AuthService {
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    // Sign in med email and password - Funktion
    func signin(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    // Sign up med email and password - Funktion
    func signup(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    // Sign out med nuværende user - Funktion
    func signout() throws {
        try Auth.auth().signOut()
    }
}
