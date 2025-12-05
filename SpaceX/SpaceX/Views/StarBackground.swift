//
//  StarField.swift
//
//  Created by dmu mac 26 on 03/12/2025.
//

import SwiftUI

// Viser et tilfældigt stjernebillede som baggrund
struct StarBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<150, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.2...0.9)))
                        .frame(width: CGFloat.random(in: 1...2.5),
                               height: CGFloat.random(in: 1...2.5))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
}

