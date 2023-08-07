//
//  ContentView.swift
//  tests
//
//  Created by 안병욱 on 2023/04/20.
//

import SwiftUI
import MultipeerConnectivity


struct ContentView: View {
    var heights = 180.0
    @State var isLandscape = false
    @State var ment = ".."
    @State var isAnimation = false
    @State var dos = 3/5
    //@State var color
    
    @State var cheerColor = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.indigo, Color.purple]
    @State var colorIndex = 0
    
    func chageColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (self.cheerColor.count == colorIndex + 1) {
                self.colorIndex = 0
            } else {
                self.colorIndex += 1
            }
            chageColor()
        }
    }
    
    func rotateLandscape() {
        if !isLandscape {
            if #available(iOS 16.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
                self.isLandscape = true
            } else {
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.isLandscape = true
            }
        } else {
            if #available(iOS 16.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                self.isLandscape = false
            } else {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.isLandscape = false
            }
        }
    }
    var body: some View {
        /*
        VStack(alignment: .center) {
            
             AsyncImage(url: URL(string: "https://i.ytimg.com/vi/pyf8cbqyfPs/hqdefault.jpg")) { image in
             image.image?
             .resizable()
             .frame(width: heights/9*16, height: heights/9*12)
             .clipShape(Rectangle().size(width: heights/9*16, height: heights).offset(x: 0, y: heights/6))
             .frame(width: heights/9*16, height: heights)
             .shadow(color: .black,radius: 20)
             
             }
        }
        .padding()
         */
        ZStack{
            ZStack{
                VStack{
                    Text(String(self.dos))
                    Text(ment)
                        .font(.system(size: 300, weight: .bold))
                        .minimumScaleFactor(0.3)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .foregroundColor(isAnimation ? cheerColor[colorIndex] : .black )
                        .animation(.linear(duration: 1.0), value: self.colorIndex)
                        .onTapGesture {
                            rotateLandscape()
                        }
                    if isAnimation {
                        VStack{}.onAppear(){
                            chageColor()
                        }
                    }
                    if !isLandscape {
                        TextField("여", text: $ment)
                            .padding(.horizontal)
                            .onAppear(){
                                self.isAnimation = false
                            }
                            .onDisappear(){
                                self.isAnimation = true
                            }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
