//
//  TabViews.swift
//  tests
//
//  Created by 안병욱 on 2023/08/17.
//

import SwiftUI

struct TabViews: View {
    
    @StateObject var store = Store()
    
    var body: some View {
        
        TabView {
            ChairModel(store: store)
                .tabItem {
                    Image(systemName: "chair")
                    Text("의자")
                }
            FavoriteView(store: store)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("하트")
                }
            profileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("프로필")
                }
            
        }
        .tint(.red)
    }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}
