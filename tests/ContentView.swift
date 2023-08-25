//
//  ContentView.swift
//  tests
//
//  Created by 안병욱 on 2023/04/20.
//

import SwiftUI
import GoogleSignIn
import FirebaseFirestore



struct ContentView: View {
    @EnvironmentObject var authView: AuthenticationView
    @AppStorage("isLogedIn") var isLogedIn: Bool = false
    
    func checkLogedIn() {
        if self.isLogedIn {
            authView.signIn()
        }
    }
    
    var body: some View {
        switch authView.state {
        case .signedIn:
            TabViews()
        case .signedOut:
            LoginPage()
                .onAppear(){
                    checkLogedIn()
                }
        }
    }
}
