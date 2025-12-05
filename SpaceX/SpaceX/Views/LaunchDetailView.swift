//
//  LaunchDetailView.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import SwiftUI
import MapKit

struct LaunchDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    let launch: Launch
    
    var titleName: String {
        return (launch.id ?? "")
    }
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var userViewModel: UserViewModel

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
                    Text("Launch Details")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 40)
                    Spacer()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                
                // Indhold
                GeometryReader { geometry in
                    switch viewModel.specificLaunchStatus {
                        
                    case .notStarted:
                        EmptyView()
                        
                    case .fetching:
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    case .success:
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                // Viser launchens badge/billede
                                if let patchURLString = launch.links.patch.small {
                                    AsyncImage(url: patchURLString) { phase in
                                        switch phase {
                                        case .empty:
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.gray.opacity(0.1))
                                                ProgressView()
                                            }
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 120)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 60)
                                }
                                
                                // Viser navn, dato og detaljer om missionen
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(launch.name ?? "Unknown Launch")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    if let date = launch.date_utc {
                                        Text(date.formatted(.dateTime.year().month().day().hour().minute()))
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    } else {
                                        Text("Ingen dato")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                if let details = launch.details, !details.isEmpty {
                                    Text(details)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .padding(.top, 4)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 4)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Raketten
                            if let rocket = viewModel.rocket {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Rocket")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(rocket.name ?? "Unknown rocket")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    
                                    if let type = rocket.type {
                                        Text("Type: \(type)")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                    }
                                    
                                    if let active = rocket.active {
                                        Text(active ? "Status: Active" : "Status: Inactive")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // Capsules
                            if !viewModel.capsules.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Capsules")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(viewModel.capsules, id: \.id) { capsule in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(capsule.serial ?? "Unknown capsule")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            
                                            if let type = capsule.type {
                                                Text("Type: \(type)")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                            }
                                            
                                            if let status = capsule.status {
                                                Text("Status: \(status)")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // Launchpad map
                            if let pad = viewModel.launchPad {
                                VStack {
                                    let coordinates = CLLocationCoordinate2D(latitude: pad.latitude, longitude: pad.longitude)
                                    
                                    Map(
                                        initialPosition: .region(
                                            MKCoordinateRegion(
                                                center: coordinates,
                                                span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                            )
                                        ),
                                        interactionModes: [.zoom]
                                    ) {
                                        Marker(pad.name, coordinate: coordinates)
                                    }
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding()
                                }
                            }
                            
                            // Crew
                            if !viewModel.crewMembers.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Crew")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    ForEach(viewModel.crewMembers, id: \.id) { crew in
                                        HStack(alignment: .top, spacing: 12) {
                                            
                                            if let urlString = crew.image,
                                               let url = URL(string: urlString) {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: 60, height: 60)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 60, height: 60)
                                                            .clipShape(Circle())
                                                    case .failure:
                                                        Image(systemName: "person.crop.circle")
                                                            .resizable()
                                                            .frame(width: 60, height: 60)
                                                            .foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Image(systemName: "person.crop.circle")
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(crew.name ?? "Unknown crew member")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                                if let agency = crew.agency {
                                                    Text("Agency: \(agency)")
                                                        .font(.footnote)
                                                        .foregroundColor(.white)
                                                }
                                                
                                                if let status = crew.status {
                                                    Text("Status: \(status)")
                                                        .font(.footnote)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                        
                    case .failed(let error):
                        Text(error.localizedDescription)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .toolbar {
                if userViewModel.isLogIn {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                await viewModel.toggleFavorite(launch)
                                await viewModel.loadSavedLaunches()
                            }
                        } label: {
                            Image(systemName: viewModel.savedLaunches.contains(where: { $0.id == launch.id }) ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .task {
                let capsuleIds = launch.capsules ?? []
                let rocket = launch.rocket
                let crewIds = (launch.crew ?? []).compactMap { $0.crew }
                let launchPadId = launch.launchpad
                
                await viewModel.getDataForSpecificLaunch(
                    capsuleIds: capsuleIds,
                    rocketId: rocket,
                    crewIds: crewIds,
                    launchPadId: launchPadId
                )
            }
        }
    }
}
