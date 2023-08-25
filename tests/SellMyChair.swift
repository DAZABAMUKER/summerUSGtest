//
//  SellMyChair.swift
//  tests
//
//  Created by 안병욱 on 2023/08/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn
import PhotosUI

struct SellMyChair: View {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    private let user = GIDSignIn.sharedInstance.currentUser
    
    @State var selectedItem: PhotosPickerItem? = nil
    @State var imageData: Data? = nil
    @State var name: String = ""
    @State var price: String = ""
    @State var brand: String = ""
    @State var date: Date = Date()
    @State var success: Bool = false
    @State var empty: Bool = false
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    func uploadImage(file_name: String) {
        let data = imageData
        let filePath = "images/\(file_name)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data!, metadata: metaData) { metaData, error in
            if let error = error {
                print("image upload error", error)
                return
            } else {
                print("image upload success")
                self.success = true
            }
        }
    }
    
    func getImage() {
        storage.reference(forURL: "gs://usgsummer.appspot.com/images/stunning_view").downloadURL { url, error in
            if let error = error {
                print("getting image error", error)
                return
            } else {
                //print(url!)
                print("success getting image")
            }
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let imageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                            .padding(100)
                            .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                }
                .onChange(of: selectedItem) { newValue in
                    Task{
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            self.imageData = data
                        }
                    }
                }
                HStack{
                    Text("제품명")
                        .frame(width: 100)
                    TextField(text: $name) {
                        Text("필수항목입니다.")
                    }
                    .padding(8)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray.opacity(0.12))
                        
                    })
                    .frame(width: 250)
                }
                HStack{
                    Text("가격")
                        .frame(width: 100)
                    TextField(text: $price) {
                        Text("필수항목입니다.")
                    }
                    .keyboardType(.numberPad)
                    .padding(8)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray.opacity(0.12))
                        
                    })
                    .frame(width: 250)
                }
                HStack{
                    Text("브핸드")
                        .frame(width: 100)
                    TextField(text: $brand) {
                        Text("필수항목입니다.")
                    }
                    .padding(8)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray.opacity(0.12))
                        
                    })
                    .frame(width: 250)
                }
                HStack{
                    Text("제조일자")
                        .frame(width: 100)
                    DatePicker("", selection: $date, displayedComponents: .date)
                    Spacer()
                    .padding(0)
                }
                
                Button {
                    if !name.isEmpty && !brand.isEmpty && imageData != nil {
                        db.collection("Chairs").document(UUID().uuidString).setData([
                            "user" : user?.profile?.name ?? "이름",
                            "price" : Int(self.price) ?? 0,
                            "name" : self.name,
                            "brand" : self.brand,
                            "date" : self.date
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                        uploadImage(file_name: self.name)
                        //getImage()
                    } else {
                        self.empty = true
                    }
                } label: {
                    Text("등록")
                        .padding()
                }
                .alert(Text("등록 성공"), isPresented: $success) {
                    
                }
                .alert(Text("더 입력해 주세요"), isPresented: $empty) {
                    
                }
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct SellMyChair_Previews: PreviewProvider {
    static var previews: some View {
        SellMyChair()
    }
}
