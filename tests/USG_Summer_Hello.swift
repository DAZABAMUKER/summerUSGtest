//
//  USG_Summer_Hello.swift
//  tests
//
//  Created by 안병욱 on 2023/07/24.
//

import SwiftUI

struct USG_Summer_Hello: View {
    var body: some View {
        ZStack{
            Image(systemName: "swift")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .foregroundColor(.black.opacity(0.05))
            VStack{
                Spacer()
                HStack(alignment: .center){
                    Spacer()
//                    Image(systemName: "hand.wave.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100)
                    VStack{
                        Image(systemName: "figure.badminton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                        HStack{
                            Spacer()
                            Rectangle()
                                .frame(width: 200, height: 10)
                        }
                        Text("Hello, Ted!")
                            .bold()
                            .font(.system(size: 50))
                            .padding(20)
                        HStack{
                            Rectangle()
                                .frame(width: 200, height: 10)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "figure.outdoor.cycle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .rotationEffect(Angle(degrees: 180))
                            Spacer()
                                .frame(width: 100)
                        }
                    }
                    Spacer()
                }
                //.rotationEffect(Angle(degrees: -30))
                Spacer()
            }
            
        }
        .foregroundColor(.white)
        .background {
            LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
            
    }
}

struct USG_Summer_Hello_Previews: PreviewProvider {
    static var previews: some View {
        USG_Summer_Hello()
    }
}
