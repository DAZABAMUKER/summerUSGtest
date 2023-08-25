//
//  FavoriteView.swift
//  tests
//
//  Created by 안병욱 on 2023/08/17.
//

import SwiftUI
import GoogleSignIn
import FirebaseFirestore
import FirebaseStorage

struct FavoriteView: View {
    
    @ObservedObject var store: Store
    @State var buyNow: Bool = false
    @State var meLike: [String] = []
    @State var item: [ChairInfo] = []
    let storage = Storage.storage()
    let db = Firestore.firestore()
    private let user = GIDSignIn.sharedInstance.currentUser
    
    func getHeart() {
        let docRef = db.collection("User").document(user?.profile?.name ?? "user")
        var users:[User] = []
        docRef.getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                /*
                for doc in snapshot!.documents {
                    let seller = doc.data()
                    let item = User(like: seller["like"] as? [String] ?? [], image: "", id: doc.documentID)
                    users.append(item)
                    //print(item)
                }
                 */
                let meDic: [String: Any] = snapshot?.data() ?? ["key": "value"]
                let me = User(like: meDic["like"] as? [String] ?? [], image: "", id: snapshot?.documentID ?? "1234")
                print(users)
                //let me = users.filter { $0.id == self.user?.profile?.name }.first
                self.meLike = me.like
                print(me.like.count, self.meLike)
                self.item = store.products.filter{ self.meLike.contains($0.name) }
                print(self.item)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Section{
                List(store.products.filter{ self.meLike.contains($0.name) }, id: \.id) { product in
                    ItemRow(item: product)
                        .swipeActions(edge: .trailing) {
                            Button {
                                guard let index = store.products.firstIndex(of: product) else {
                                    print("에러: 그런 의자 없음")
                                    return
                                }
                                self.meLike.remove(at: self.meLike.firstIndex(of: product.name)!)
                                db.collection("User").document(user?.profile?.name ?? "user_name").updateData([
                                    "like" : self.meLike])
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                    getHeart()
                                }
                            } label: {
                                Image(systemName: "trash.fill")
                            }

                        }
                }
            } header: {
                HStack{
                    Text("\(self.item.count) 선택됨!")
                        .padding()
                    Spacer()
                }
            }
            .navigationTitle(Text("내 장바구니 목록"))
            Divider()
            HStack{
                Text("총액:")
                Text("\(self.item.map{$0.price}.reduce(0, +)) ￦")
            }
            .onAppear(){
                getHeart()
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
            .padding(.vertical, 10)

        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(store: Store())
    }
}
