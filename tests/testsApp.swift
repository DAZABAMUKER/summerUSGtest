//
//  testsApp.swift
//  tests
//
//  Created by 안병욱 on 2023/04/20.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        return true
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct testsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authView = AuthenticationView()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authView)
        }
    }
}
