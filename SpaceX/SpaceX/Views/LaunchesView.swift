//
//  LaunchesView.swift
//
//  Created by dmu mac 26 on 02/12/2025.
//

import SwiftUI

struct LaunchesView: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    // Viser en liste over alle launches fra API
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                switch viewModel.allLaunchesStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(launches: viewModel.allLaunches)
                case .failed(let underlyingError):
                    EmptyView()
                }
            }
            .task {
                await viewModel.getLaunches()
            }
        }
        
    }
}

