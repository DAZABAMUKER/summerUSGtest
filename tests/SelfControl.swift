//
//  SelfControl.swift
//  tests
//
//  Created by 안병욱 on 2023/07/27.
//

import SwiftUI

struct SelfControl: View {
    
    @State var like: Bool = false
    @State var continueous = false
    @State var imageIndex = 0
    
    @Binding var item: Item
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing: 0){
//                HStack{
//                    Image(systemName: "arrowshape.turn.up.left.fill")
//                        .padding(5)
//                    Text("도서 추천")
//                        .font(.title)
//                        .bold()
//                        .padding(5)
//                    Spacer()
//                }
//                .background(.white)
                
                imageControl
                info
                commentScroll
            }
            .preferredColorScheme(.dark) //다크모드 막음 .dark 이면 다크모드로만 작동
            .navigationTitle("의자 정보")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    VStack(alignment: .trailing){
                        Toggle(isOn: $continueous) {
                            Text("Image Loop")
                        }
                        .toggleStyle(.switch)
                        .scaleEffect(0.8)
                        .tint(.blue)
//                        Text("Image loop")
//                            .foregroundColor(.secondary)
                    }
                }
            }
            //.background(.brown.opacity(0.5))
        }
    }
    
    var imageControl: some View {
        ZStack{
            Image(item.image[self.imageIndex])
                .resizable()
                .frame(height: 230)
                .opacity(0.5)
            Image(item.image[self.imageIndex])
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .shadow(radius: 5)
            HStack{
                Button {
                    if self.imageIndex == 0 {
                        self.imageIndex = item.image.count - 1
                    } else {
                        self.imageIndex -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .scaleEffect(2)
                        .fontWeight(.heavy)
                }
                .disabled(self.continueous ? false : imageIndex == 0)
                Spacer()
                Button {
                    if self.imageIndex == item.image.count - 1 {
                        self.imageIndex = 0
                    } else {
                        self.imageIndex += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .scaleEffect(2)
                        .fontWeight(.heavy)
                }
                .disabled(self.continueous ? false : self.imageIndex == item.image.count - 1)
            }
            .tint(.accentColor)
            .padding()
        }
    }
    var commentScroll: some View {
        ScrollView {
            HStack{
                Spacer()
                Image(systemName: "doc.append.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("리뷰")
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                Spacer()
            }
            ForEach(["다자바", "테드", "누군가", "섬바디"], id: \.self) { user in
                Comment(user: user)
            }
        }
        .background(.gray.opacity(0.2))
    }
    var info: some View {
        VStack(alignment: .leading){
            HStack{
                Text(item.name)
                    .padding(10)
                    .bold()
                    .font(.title)
                Spacer()
                
                Button {
                    item.heart.toggle()
                } label: {
                    Image(systemName: !self.item.heart ? "heart" : "heart.fill")
                        .scaleEffect(1.5)
                        .padding()
                        .foregroundColor(.red)
                }
            }
            HStack{
                Image(item.user)
                    .resizable()
                    //.scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .clipShape(Circle())
                    .padding(.leading)
                    //.border(.red)
                Text(item.user)
                    .bold()
                Spacer()
                NavigationLink(destination: Text("구매하기")) {
                    Text("바로 구매")
                        .foregroundColor(.white)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                        }
                        .padding()
                }

            }
            HStack{
                Text("브랜드: ")
                Text(item.brand)
                Spacer()
                    .frame(width: 30)
            }
            .padding(.leading)
            HStack{
                Text("출시일: ")
                Text(item.date)
            }
            .padding(.leading)
        }
        .padding(.bottom)
    }
}

struct Comment: View {
    @State var user: String = "다자바"
    var body: some View {
        VStack(){
            HStack{
                Text(self.user)
                    .bold()
                    .font(.title3)
                Spacer()
                Image(systemName: "star")
                Text("5.0")
                    .padding(5)
            }
            .padding(.leading)
            .background(.gray)
            .foregroundColor(.white)
            Text("잠 안오시는 분들께 추천")
                .padding(.bottom, 5)
                .foregroundColor(.white)
        }
        .frame(width: 350)
        .frame(minHeight: 50)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.secondary.opacity(0.5))
        }
    }
}

struct SelfControl_Previews: PreviewProvider {
    static var previews: some View {
        SelfControl(item: .constant(itemSample[4]))
    }
}
