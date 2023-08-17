//
//  FavoriteView.swift
//  tests
//
//  Created by 안병욱 on 2023/08/17.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var store: Store
    @State var buyNow: Bool = false
    
    var body: some View {
        NavigationStack {
            List(store.products.filter{$0.heart}) { product in
                ItemRow(item: product)
            }
            .navigationTitle(Text("\(store.products.filter{$0.heart}.count) is selected!"))
            .navigationBarTitleDisplayMode(.inline)
            Divider()
            HStack{
                Text("총액:")
                Text("\(store.products.filter{$0.heart}.map{$0.price}.reduce(0, +)) ￦")
            }
            Button {
                self.buyNow = true
            } label: {
                Text("구매하기")
                    .padding(.horizontal, 30)
            }
            .sheet(isPresented: $buyNow, content: {
                Text("토스")
            })
            .buttonStyle(.borderedProminent)

        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(store: Store())
    }
}
