//
//  Play_with_mage.swift
//  tests
//
//  Created by 안병욱 on 2023/07/27.
//

import SwiftUI

struct Play_with_mage: View {
    
    @State var love = false
    
    var body: some View {
        ZStack{
            VStack{
                Image("umbba_drawing")
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        self.love.toggle()
                    }
                Text("우리 엄빠")
                    .font(.title)
                    .bold()
            }
            Image("wing")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(radius: 10)
                .overlay {
                    ZStack{
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .foregroundColor(.white)
                            .offset(y: 8)
                            .shadow(radius: 3)
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(.pink)
                            .offset(y: 8)
                    }
                }
                .offset(x: -90, y: love ? -130 : -110)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: self.love)
        }
    }
}

struct Play_with_mage_Previews: PreviewProvider {
    static var previews: some View {
        Play_with_mage()
    }
}
