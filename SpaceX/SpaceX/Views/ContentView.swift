//
//  ContentView.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var userViewModel = UserViewModel()

    var body: some View {
        TabView {
            // Viser alle launches med mulighed for at logge ud
            Tab("Launches", systemImage: "moon.circle") {
                NavigationStack {
                    LaunchesView()
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                if userViewModel.isLogIn {
                                    Button("Sign Out") {
                                        userViewModel.signOut()
                                    }
                                }
                            }
                        }
                }
            }

            // Viser SavedView hvis brugeren er logget ind, ellers LoginView
            Tab(userViewModel.isLogIn ? "Saved" : "Login",
                systemImage: userViewModel.isLogIn ? "arrow.down.to.line" : "person.crop.circle") {
                
                NavigationStack {
                    if userViewModel.isLogIn {
                        SavedView()
                    } else {
                        LoginView()
                    }
                }
            }

            // Viser kort over alle launchpads
            Tab("Launchpads", systemImage: "map") {
                NavigationStack {
                    MapView()
                }
            }
        }
        .environmentObject(userViewModel)
        .environmentObject(viewModel)
    }
}
