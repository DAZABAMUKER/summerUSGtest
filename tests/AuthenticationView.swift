//
//  AuthenticationView.swift
//  tests
//
//  Created by 안병욱 on 2023/08/25.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn

class AuthenticationView: ObservableObject {
    enum SignInState {
        case signedIn
        case signedOut
    }
    @Published var state: SignInState = .signedOut
    @AppStorage("isLogedIn") var isLogedIn: Bool = false
    let db = Firestore.firestore()
    let user = GIDSignIn.sharedInstance.currentUser
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // 2
        guard let authentication = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication)
        
        // 3
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .signedIn
                self.isLogedIn = true
                guard let name = user?.profile?.name else {
                    return
                }
                db.collection("User").getDocuments { snapshot, error in
                    if error == nil && snapshot != nil {
                        let users = snapshot?.documents.map{$0.documentID}
                        if !(users?.contains(name) ?? false) {
                            self.db.collection("User").document(name).setData([
                                "like" : []
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                        } else {
                            print("old user")
                            return
                        }
                    }
                }
            }
        }
    }
    
    func signIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // 3
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            // 4
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 5
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                authenticateUser(for: result?.user, with: error)
            }
        }
        
        
    }
    func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()
        
        do {
            // 2
            try Auth.auth().signOut()
            
            state = .signedOut
            self.isLogedIn = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


struct GoogleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        return GIDSignInButton()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
