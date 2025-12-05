//
//  MapView.swift
//
//  Created by dmu mac 26 on 05/12/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject private var viewModel: ViewModel

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
    )
    
    @State private var selectedLaunchpadID: String? = nil 

    var body: some View {
        NavigationStack {
            ZStack {
                // Baggrund med gradient
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
                
                // Stjernebillede ovenpå baggrunden
                StarBackground()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                // Kort med liste
                GeometryReader { geo in
                    switch viewModel.allLaunchpadsStatus {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .success:
                        VStack {
                            Text("Antal launchpads: \(viewModel.allLaunchpads.count)")
                                .font(.headline)
                            
                            // Kort med annotationer for hver launchpad
                            Map(coordinateRegion: $region, annotationItems: viewModel.allLaunchpads) { launchpad in
                                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: launchpad.latitude, longitude: launchpad.longitude)) {
                                    Button {
                                        selectedLaunchpadID = launchpad.id
                                    } label: {
                                        VStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.title2)
                                            Text(launchpad.name)
                                                .font(.caption)
                                                .fixedSize()
                                        }
                                    }
                                }
                            }
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                            
                            // Liste over launches for valgt launchpad
                            if let launchpadID = selectedLaunchpadID {
                                let launchesForPad = viewModel.allLaunches.filter { $0.launchpad == launchpadID }
                                
                                if launchesForPad.isEmpty {
                                    Text("Ingen launches fra denne launchpad")
                                        .foregroundColor(.white)
                                        .padding()
                                } else {
                                    List {
                                        ForEach(launchesForPad) { launch in
                                            NavigationLink {
                                                LaunchDetailView(launch: launch)
                                            } label: {
                                                VStack(alignment: .leading) {
                                                    Text(launch.name)
                                                        .font(.headline)
                                                    if let launchDate = launch.date_utc {
                                                        Text("Dato: \(launchDate, formatter: dateFormatter)")
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                .padding(.vertical, 4)
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 300)
                                    // Skjul standard listebaggrund
                                    .scrollContentBackground(.hidden)
                                }
                            } else {
                                Text("Tryk på en launchpad for at se launches")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    case .failed(let error):
                        VStack {
                            Text("Fejl ved hentning af launchpads:")
                                .font(.headline)
                            Text(error.localizedDescription)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
            }
        }
        // Hent alle launchpads fra API
        .task {
            await viewModel.getAllLaunchpads()
        }
    }
}

// Formatter til at vise dato
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
