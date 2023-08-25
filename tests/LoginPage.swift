//
//  LoginPage.swift
//  tests
//
//  Created by 안병욱 on 2023/08/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct LoginPage: View {
    
    @EnvironmentObject var authView: AuthenticationView
    
    @State var userId: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack{
            
            Image("loginBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Color.white
                .opacity(0.7)
                .ignoresSafeArea()
//            Color.black
//                .opacity(0.3)
//                .ignoresSafeArea()
            VStack{
                Text("Old Chair Seller")
                    .bold()
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(100)
                TextField(text: $userId) {
                    Text("아이디")
                }
                .padding(5)
                .background(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                    
                })
                .frame(width: 250)
                SecureField(text: $password) {
                    Text("비밀번호")
                }
                .padding(5)
                .background(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                    
                })
                .frame(width: 250)
                HStack{
                    Button {
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                            Text("로그인")
                                .tint(.white)
                        }
                    }
                    .frame(width: 250,height: 40)
                }
                HStack{
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .cornerRadius(25)
                        .padding(10)
                        .onTapGesture {
                            authView.signIn()
                        }
                }
                Spacer()
                    .frame(height: 100)
            }
        }
        
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
