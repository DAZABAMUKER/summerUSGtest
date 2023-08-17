//
//  ChairModel.swift
//  tests
//
//  Created by 안병욱 on 2023/08/07.
//

import SwiftUI

struct ChairModel: View {
    
    @ObservedObject var store: Store
    
    var body: some View {
        NavigationStack{
            List($store.products) { $item in
                NavigationLink {
                    SelfControl(item: $item)
                } label: {
                    ItemRow(item: item)
                }
            }
            .navigationTitle("내가 판매중인 상품")
        }
    }
}


struct ItemRow: View {
    
    let item: Item
    
    var body: some View {
        HStack{
            Image(item.image.first!)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            VStack(alignment: .leading){
                Text(item.name)
                Text(item.user)
            }
            Spacer()
            Text("\(item.price)원")
        }
    }
}


struct ChairModel_Previews: PreviewProvider {
    static var previews: some View {
        ChairModel(store: Store())
    }
}
