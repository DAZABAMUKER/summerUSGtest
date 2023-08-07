//
//  Profile.swift
//  tests
//
//  Created by 안병욱 on 2023/08/07.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var profile: ProfileInfo
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        
        VStack{
            TextField("이름 입력", text: $profile.name)
            TextField("설명 입력", text: $profile.description)
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
            .buttonStyle(.borderedProminent)

        }
        .padding()
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMain()
    }
}

struct ProfileInfo {
    var name: String
    var description: String
}

struct ProfileMain: View {
    
    @State var profile = ProfileInfo(name: "", description: "")
    @State var modals = false
    
    var body: some View {
        VStack{
            HStack{
                Text("이름: ")
                Text(profile.name)
                Spacer()
            }
            HStack{
                Text("설명: ")
                Text(profile.description)
                Spacer()
            }
            Button {
                self.modals.toggle()
            } label: {
                Text("입력")
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $modals) {
                ProfileView(profile: $profile)
            }

        }
        .padding()
        
    }
}
