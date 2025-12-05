import SwiftUI

struct VerticalListView: View {
    var launches: [Launch]
    
    var body: some View {
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

            // Liste over launches
            List(
                launches.sorted {
                    ($0.date_utc ?? .distantPast) >
                    ($1.date_utc ?? .distantPast)
                }
            ) { launch in
                NavigationLink {
                    LaunchDetailView(launch: launch)
                } label: {
                    HStack(spacing: 12) {
                        
                        // Mission patch billede
                        AsyncImage(url: launch.links.patch.small) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            case .failure(_):
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }

                        // Launch navn og dato
                        VStack(alignment: .leading, spacing: 4) {
                            Text(launch.name)
                                .font(.headline)
                                .foregroundColor(.white)

                            if let date = launch.date_utc {
                                Text(date.formatted(.dateTime.year().month().day().hour().minute()))
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            } else {
                                Text("Ingen dato")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.black.opacity(0.4))
            }
            .scrollContentBackground(.hidden)
        }
    }
}
