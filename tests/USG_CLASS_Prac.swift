//
//  USG_CLASS_Prac.swift
//  tests
//
//  Created by 안병욱 on 2023/08/10.
//

import SwiftUI

struct USG_CLASS_Prac: View {
    
    @ObservedObject var byeongUk = Student()
    
    func set_student(who: Student ,name: String, age: Int, major: String, grade: Int) -> Student {
        who.name = name
        who.age = age
        who.major = major
        who.grade = grade
        return who
    }
    var body: some View {
        VStack{
            Button {
                set_student(who: byeongUk, name: "병욱", age: 23, major: "P&P화학공학", grade: 4)
            } label: {
                Text("병욱 설정")
            }
            Text(byeongUk.name)
            Text(String(byeongUk.age))
            Text(byeongUk.major)
            Text(String(byeongUk.grade))
            Text(byeongUk.재학여부 ? "맞음" : "아님")
        }
    }
}

struct USG_CLASS_Prac_Previews: PreviewProvider {
    static var previews: some View {
        USG_CLASS_Prac()
    }
}

class Person {
    var name: String = ""
    var age: Int = 0
}

class Student: Person, ObservableObject {
    @Published var major: String = ""
    var grade: Int = 0
    var 재학여부: Bool {
        return grade > 0 ? true : false
    }
}
