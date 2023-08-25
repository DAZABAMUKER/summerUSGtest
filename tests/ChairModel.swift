//
//  ChairModel.swift
//  tests
//
//  Created by 안병욱 on 2023/08/07.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

struct ChairModel: View {
    
    @ObservedObject var store: Store
    let db = Firestore.firestore()
    @State var chairs: [ChairInfo] = []
    
    func getData() {
        let docRef = db.collection("Chairs")
        docRef.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents {
                    let chair = doc.data()
                    print(chair)
                    let item = ChairInfo(
                        id: doc.documentID, name: chair["name"] as? String ?? "name",
                        price: chair["price"] as? Int ?? 0,
                        brand: chair["brand"] as? String ?? "brand",
                        dateTS: chair["date"] as? Timestamp ?? Timestamp(),
                        user: chair["user"] as? String ?? "user")
                    self.chairs.append(item)
                    print(item)
                }
                print(self.chairs)
                store.products = self.chairs
                self.chairs = []
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                List($store.products, id: \.id) { $item in
                    NavigationLink {
                        SelfControl(item: $item)
                    } label: {
                        ItemRow(item: item)
                    }
                }
                //.border(.red)
                .navigationTitle("판매중인 의자")
                .onAppear(){
                    getData()
                }
                VStack(alignment: .trailing){
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink {
                            SellMyChair()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .padding(10)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .foregroundColor(.red)
                                }
                                .padding(30)
                        }
                    }
                }
            }
        }
    }
}


struct ItemRow: View {
    
    let item: ChairInfo
    let storage = Storage.storage()
    @State var imageURL = URL(string: "")
    
    func getImage() {
        storage.reference(forURL: "gs://usgsummer.appspot.com/images/\(item.name)").downloadURL { url, error in
            if let error = error {
                print("getting image error", error)
                return
            } else {
                print(url!)
                print("success getting image")
                self.imageURL = url
            }
        }
    }
    
    var body: some View {
        HStack{
            AsyncImage(url: self.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            } placeholder: {
                Image(systemName: "chair")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
            }
            

//            Image(item.image.first!)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 80)
            VStack(alignment: .leading){
                Text(item.name)
                    .bold()
                    .font(.title3)
                Text(item.user)
            }
            .onAppear(){
                getImage()
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
