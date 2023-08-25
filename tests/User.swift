//
//  User.swift
//  tests
//
//  Created by 안병욱 on 2023/08/10.
//

import Foundation

class User: Identifiable {
    var id: String
    
    var like: [String]
    var image: String
    
    init(like: [String], image: String, id: String) {
        self.like = like
        self.image = image
        self.id = id
    }
}
