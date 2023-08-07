//
//  Item.swift
//  tests
//
//  Created by 안병욱 on 2023/08/07.
//

import Foundation

struct Item: Identifiable {
    var id = UUID()
    let name: String
    let image: [String]
    let price: Int
    let brand: String = "이케아"
    let date: String = "2021년 1월 13일"
}

let itemSample: [Item] = [
    Item(name: "Aleby", image: ["aleby_1", "aleby_2", "aleby_3", "aleby_4"], price: 50000),
    Item(name: "Brommo", image: ["brommo"], price: 40000),
    Item(name: "Ekedalen", image: ["ekedalen"], price: 30000),
    Item(name: "Aleby", image: ["image"], price: 20000),
    Item(name: "Markus", image: ["markus_1"], price: 10000)
]
