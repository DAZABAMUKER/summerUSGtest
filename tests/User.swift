//
//  User.swift
//  tests
//
//  Created by 안병욱 on 2023/08/10.
//

import Foundation

class User: Identifiable {
    var id = UUID()
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    static let 테드 = User(name: "테드", image: "테드")
    static let 하니 = User(name: "하니", image: "하니")
    static let 잼민 = User(name: "잼민", image: "잼민")
    static let 바기 = User(name: "바기", image: "바기")
    static let 온도 = User(name: "온도", image: "온도")
}
