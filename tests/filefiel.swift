//
//  filefiel.swift
//  tests
//
//  Created by 안병욱 on 2023/08/01.
//

import SwiftUI

struct filefiel: View {
    
    let sportsArray = [
        ("헬스" , "dumbbell.fill"), ("야구" , "baseball"), ("축구" , "soccerball.inverse"), ("농구" , "basketball.fill"), ("골프" , "figure.golf")
    ]
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack(alignment: .leading){
                    HStack{
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: geometry.size.width - 30, height: 30)
                                .foregroundColor(.secondary.opacity(0.5))
                                .shadow(radius: 5)
                            HStack{
                                Image(systemName: "megaphone.fill")
                                Text("공지")
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    Text("추천 게시판")
                        .font(.title)
                        .bold()
                        .padding(10)
                    ScrollView(.horizontal){
                        VStack{
                            HStack(spacing: 10) {
                                ForEach(sportsArray, id: \.0) { (sort,image) in
                                    VStack{
                                        ZStack{
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .foregroundColor(.white)
//                                                .shadow(radius: 5)
                                            Image(systemName: image)
                                                .resizable()
                                                .scaledToFit()
                                                .scaleEffect(0.6)
                                                .foregroundColor(.white)
                                            
                                        }
                                        .frame(width: 100, height: 100)
                                        
                                        .background{
                                            LinearGradient(colors: [.blue, .cyan, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                        .cornerRadius(10)
                                        Text(sort)
                                    }
                                }
                            }
                            .padding(10)
                        }
                    }
                    Text("나의 게시판")
                        .padding()
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        ZStack{
                            Circle()
                                .stroke(lineWidth: 2.0)
                                .scale(1.2)
                                .fill(.black)
                                
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .scaleEffect(0.8)
                                //.brightness(0.3)
                                
                                .shadow(radius: 1)
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Text("#헬스 #야구 # 관광")
                            .foregroundColor(.black)
                            .shadow(radius: 10)
                    }
                    
                }
                .navigationTitle("게시판")
                .navigationBarTitleDisplayMode(.large)
                .background{
                    ZStack{
                        VStack{
                            Image("health")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.6)
                            Spacer()
                        }
                        LinearGradient(colors: [.clear, .white, .white, .white, .white], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                }
            }
        }
        
    }
}

struct filefiel_Previews: PreviewProvider {
    static var previews: some View {
        filefiel()
    }
}
