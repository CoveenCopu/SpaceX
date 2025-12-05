//
//  SavedView.swift
//


import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Baggrund med gradient og stjerner
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.05, green: 0.0, blue: 0.25),
                        Color(red: 0.0, green: 0.0, blue: 0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                StarBackground()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                // Øverste overskrift
                VStack {
                    Text("Saved Launches")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top,
                    UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40)
                    Spacer()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false) // så man stadig kan scrolle/listen
                
                // Liste eller besked hvis ingen saved launches
                if viewModel.savedLaunches.isEmpty {
                    Text("No Launches saved")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                } else {
                    VerticalListView(launches: viewModel.savedLaunches)
                }
                // Hent saved launches fra ViewModel/Firestore
            } .task {
                await viewModel.loadSavedLaunches()
            }
        }
    }
}

