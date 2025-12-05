//
//  UserViewModel.swift
//  SpaceX
//
//  Created by dmu mac 26 on 03/12/2025.
//

import Foundation
import FirebaseAuth
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLogIn: Bool = false
    
    private let service = AuthService()
    
    // Login - Funktion
    func login(email: String, password: String) async {
        do{
            let user = try await service.signin(email: email, password: password)
            self.isLogIn = true
            self.user = user
        } catch{
            print(error)
        }
    }
    
    // signUp - Funktion
    func signUp(email: String, password: String) async -> Bool {
        do {
            let user = try await service.signup(email: email, password: password)
            self.isLogIn = true
            self.user = user
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // signOut - Funktion
    func signOut(){
        do{
            try service.signout()
            self.isLogIn = false
            self.user = nil
        } catch{
            print (error)
        }
    }
}




