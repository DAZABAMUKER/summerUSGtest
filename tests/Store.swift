//
//  Store.swift
//  tests
//
//  Created by 안병욱 on 2023/08/10.
//

import Foundation

class Store: ObservableObject {
    @Published var products: [ChairInfo] = []
}
