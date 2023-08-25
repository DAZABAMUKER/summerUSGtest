//
//  profileView.swift
//  tests
//
//  Created by 안병욱 on 2023/08/17.
//

import SwiftUI
import GoogleSignIn

struct profileView: View {
    
    @EnvironmentObject var authView: AuthenticationView
    
    private let user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                AsyncImage(url: user?.profile?.imageURL(withDimension: 100)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .padding(10)
                VStack(alignment: .leading){
                    Text(user?.profile?.name ?? "유저이름")
                        .bold()
                        .font(.title3)
                    Text(user?.profile?.email ?? "유저이름")
                    Button {
                        authView.signOut()
                    } label: {
                        Text("로그아웃")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.trailing, 10)
                Spacer()
            }
            .background(.secondary)
            .cornerRadius(10)
            .padding(10)
            Spacer()
            
        }
    }
}
