//
//  MainView.swift
//  tests
//
//  Created by 안병욱 on 2023/08/04.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Text("프포필")
                .tabItem {
                    VStack{
                        Image(systemName: "person.crop.circle.fill")
                        Text("프포필")
                    }
                }
            Text("채팅")
                .tabItem {
                    VStack{
                        Image(systemName: "message.fill")
                        Text("채팅")
                    }
                }
            filefiel()
                .tabItem {
                    VStack{
                        Image(systemName: "newspaper.fill")
                        Text("게시판")
                    }
                }
            Text("예약")
                .tabItem {
                    VStack{
                        Image(systemName: "creditcard")
                        Text("예약")
                    }
                }
            SelfControl(item: itemSample.first!)
                .tabItem {
                    VStack{
                        Image(systemName: "gear")
                        Text("설정")
                    }
                }
            
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
