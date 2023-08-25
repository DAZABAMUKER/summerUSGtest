//
//  Item.swift
//  tests
//
//  Created by 안병욱 on 2023/08/07.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Item: Identifiable, Equatable {
    var id = UUID()
    let name: String
    let image: [String]
    let price: Int
    let brand: String = "이케아"
    let date: String = "2021년 1월 13일"
    var user: String = "me"
    var heart: Bool = false
}

let itemSample: [Item] = [
    Item(name: "Aleby", image: ["aleby_1", "aleby_2", "aleby_3", "aleby_4"], price: 50000, user: "하니"),
    Item(name: "Brommo", image: ["brommo"], price: 40000, user: "테드"),
    Item(name: "Ekedalen", image: ["ekedalen"], price: 30000, user: "온도"),
    Item(name: "Hattefjall", image: ["image"], price: 20000, user: "바기"),
    Item(name: "Markus", image: ["markus_1"], price: 10000, user: "잼민")
]

struct ChairInfo: Equatable {
    var id: String
    let name: String
    let price: Int
    let brand: String
    let dateTS: Timestamp
    let date: Date
    var user: String
    var heart: Bool = false
    
    init(id: String, name: String, price: Int, brand: String, dateTS: Timestamp, user: String) {
        self.id = id
        self.name = name
        self.price = price
        self.brand = brand
        self.dateTS = dateTS
        self.date = dateTS.dateValue()
        self.user = user
    }
}

struct CommentModel: Equatable, Hashable{
    var user: String
    var rate: Double
    var message: String
}
