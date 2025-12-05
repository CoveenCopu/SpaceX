//
//  Login.swift
//  SpaceX
//
//  Created by dmu mac 26 on 03/12/2025.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm: UserViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Viser formular til oprettelse af bruger og håndterer signup via UserViewModel
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button {
                        Task {
                            let success = await vm.signUp(email: email, password: password)
                            
                            if success {
                                dismiss()   
                            }
                        }
                    } label: {
                        Text("Sign up")
                    }
                }
            }
            .navigationTitle("Sign Up")
        }
    }
}


