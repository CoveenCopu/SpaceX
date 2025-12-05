//
//  Login.swift
//  SpaceX
//
//  Created by dmu mac 26 on 03/12/2025.
//

import SwiftUI

struct LoginView: View {
    // ViewModel (via @EnvironmentObject) og inputfelter (via @State) til login, opdateres automatisk i UI
    @EnvironmentObject var vm: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Viser login-formular og håndterer brugerlogin via UserViewModel
    var body: some View {
        NavigationStack {
            Text("Login")
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button {
                        Task {
                            await vm.login(email: email, password: password)
                        }
                    } label: {
                        Text("Log in")
                    }
                    
                }
                Section {
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign up")

                    }
                }
            }
        }
    }
}

