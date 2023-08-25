//
//  SelfControl.swift
//  tests
//
//  Created by 안병욱 on 2023/07/27.
//

import SwiftUI
import GoogleSignIn
import FirebaseFirestore
import FirebaseStorage

struct SelfControl: View {
    
    @State var like: Bool = false
    @State var continueous = false
    @State var imageIndex = 0
    @State var mycomment = ""
    @Binding var item: ChairInfo
    let storage = Storage.storage()
    let db = Firestore.firestore()
    private let user = GIDSignIn.sharedInstance.currentUser
    @State var imageURL = URL(string: "")
    @State var userImage = URL(string: "")
    @State var meLike: [String] = []
    @State var comments = [CommentModel]()
    @State var rate = 5.0
    @State var showRate = false
    
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
    
    func getUserImage() {
        storage.reference(forURL: "gs://usgsummer.appspot.com/UserImage/\(item.user)").downloadURL { url, error in
            if let error = error {
                print("getting image error", error)
                return
            } else {
                print(url!)
                print("success getting image")
                self.userImage = url
            }
        }
    }
    
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
                if (me.like.contains(item.name)) {
                    print(item.name, me.like.contains(item.name))
                    self.like = true
                }
            }
        }
    }
    
    func getComment() {
        let docRef = db.collection("Chairs").document(item.id).collection("comments")
        docRef.getDocuments{ snapshot, error in
            self.comments = []
            if error == nil && snapshot != nil {
                guard let documents = snapshot?.documents else {
                    return
                }
                for doc in documents {
                    let comment: [String: Any] = doc.data()
                    let item = CommentModel(
                        user: comment["user"] as? String ?? "user",
                        rate: comment["rate"] as? Double ?? 5.0,
                        message: comment["message"] as? String ?? "이미 팔렸나요?"
                    )
                    self.comments.append(item)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                ScrollView {
                    VStack(alignment: .center, spacing: 0){
                        //                HStack{
                        //                    Image(systemName: "arrowshape.turn.up.left.fill")
                        //                        .padding(5)
                        //                    Text("도서 추천")
                        //                        .font(.title)
                        //                        .bold()
                        //                        .padding(5)
                        //                    Spacer()
                        //                }
                        //                .background(.white)
                        
                        imageControl
                            .onAppear(){
                                getImage()
                                getHeart()
                                getUserImage()
                                getComment()
                            }
                        info
                        commentScroll
                    }
                    //.preferredColorScheme(.dark) //다크모드 막음 .dark 이면 다크모드로만 작동
                    //.navigationTitle("의자 정보")
                    //.navigationBarTitleDisplayMode(.large)
                    /*
                     .toolbar {
                     ToolbarItem {
                     VStack(alignment: .trailing){
                     Toggle(isOn: $continueous) {
                     Text("Image Loop")
                     }
                     .toggleStyle(.switch)
                     .scaleEffect(0.8)
                     .tint(.blue)
                     //                        Text("Image loop")
                     //                            .foregroundColor(.secondary)
                     }
                     }
                     }
                     */
                    //.background(.brown.opacity(0.5))
                }
                HStack{
                    TextField("댓글 입력", text: $mycomment)
                        .padding(.horizontal,5)
                    Button{
                        self.showRate.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "star")
                            Text(String(format: "%.1f", rate))
                        }
                    }
                    
                    Button {
                        if !self.mycomment.isEmpty {
                            db.collection("Chairs").document(item.id).collection("comments").document(UUID().uuidString).setData([
                                "user" : user?.profile?.name ?? "user",
                                "rate" : rate,
                                "message" : self.mycomment
                            ])  { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                        self.mycomment = ""
                        self.rate = 5.0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                            getComment()
                        }
                    } label: {
                        Text("등록")
                    }
                    
                    .buttonStyle(.borderedProminent)

                }
                .padding(7)
                .background(.black)
                if showRate{
                    VStack{
                        Text("별점")
                        ZStack{
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.black)
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(Rectangle().size(width: 110,height: 100 - rate * 20)) // 클립 원점이 상단이라 반대로 설정.
                            Image(systemName: "star")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                        HStack{
                            Slider(value: $rate, in: 0...5, step: 0.1)
                            Text("\(rate, specifier: "%.1f")")
                        }
                        .padding()
                        Button {
                            self.showRate.toggle()
                        } label: {
                            Text("확인")
                        }
                    }
                    .frame(width: 200, height: 260)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .offset(x: 0,y: -300)
                }
            }
        }
    }
    
    var imageControl: some View {
        ZStack{
            /*
            Image(item.image[self.imageIndex])
                .resizable()
                .frame(height: 230)
                .opacity(0.5)
            Image(item.image[self.imageIndex])
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .shadow(radius: 5)
             */
            AsyncImage(url: imageURL) { image in
                ZStack{
                image
                    .resizable()
                    .frame(height: 230)
                    .opacity(0.5)
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .shadow(radius: 5)
            }
            } placeholder: {
                Image(systemName: "chair")
                    .resizable()
                    .frame(height: 230)
                    .opacity(0.5)
            }
            HStack{
                Button {
//                    if self.imageIndex == 0 {
//                        self.imageIndex = item.image.count - 1
//                    } else {
//                        self.imageIndex -= 1
//                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .scaleEffect(2)
                        .fontWeight(.heavy)
                }
                .disabled(self.continueous ? false : imageIndex == 0)
                Spacer()
                Button {
//                    if self.imageIndex == item.image.count - 1 {
//                        self.imageIndex = 0
//                    } else {
//                        self.imageIndex += 1
//                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .scaleEffect(2)
                        .fontWeight(.heavy)
                }
                //.disabled(self.continueous ? false : self.imageIndex == item.image.count - 1)
            }
            .tint(.accentColor)
            .padding()
        }
    }
    var commentScroll: some View {
        //ScrollView {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "doc.append.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Text("리뷰")
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                Spacer()
            }
            ForEach(self.comments, id: \.self) { comment in
                Comment(comment: comment)
                    .padding(2)
            }
            Spacer()
        }
//        }
      .background(.gray.opacity(0.2))
    }
    var info: some View {
        VStack(alignment: .leading){
            HStack{
                Text(item.name)
                    .padding(10)
                    .bold()
                    .font(.title)
                Spacer()
                
                Button {
                    self.like.toggle()
                    if like {
                        self.meLike.append(item.name)
                    } else {
                        guard let index = meLike.firstIndex(of: item.name) else {
                            print("No chair")
                            return
                        }
                        self.meLike.remove(at: index)
                    }
                    db.collection("User").document(user?.profile?.name ?? "user_name").updateData([
                        "like" : self.meLike])
                } label: {
                    Image(systemName: self.like ? "heart.fill" : "heart")
                        .scaleEffect(1.5)
                        .padding()
                        .foregroundColor(.red)
                }
            }
            HStack{
                AsyncImage(url: userImage) { image in
                    ZStack{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .shadow(radius: 5)
                        .clipped()
                        .clipShape(Circle())
                        .padding(.leading)
                }
                } placeholder: {
                    Image(systemName: "chair")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .opacity(0.5)
                }
                
                Text(item.user)
                    .bold()
                Spacer()
                NavigationLink(destination: Text("구매하기")) {
                    Text("바로 구매")
                        .foregroundColor(.white)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                        }
                        .padding()
                }

            }
            HStack{
                Text("브랜드: ")
                Text(item.brand)
                Spacer()
                    .frame(width: 30)
            }
            .padding(.leading)
            HStack{
                Text("구매일자: ")
                Text(item.date, style: .date)
            }
            .padding(.leading)
        }
        .padding(.bottom)
    }
}

struct Comment: View {
    @State var comment: CommentModel = CommentModel(user: "유저", rate: 5.0, message: "팔렸나요?")
    var body: some View {
        VStack(){
            HStack{
                Text(self.comment.user)
                    .bold()
                    .font(.title3)
                Spacer()
                Image(systemName: "star")
                Text(String(format: "%.1f", comment.rate))
                    .padding(.trailing,10)
                    .padding(5)
            }
            .padding(.leading)
            .background(.gray)
            .cornerRadius(5)
            .foregroundColor(.white)
            HStack{
                Text(comment.message)
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(width: 350)
        .frame(minHeight: 50)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.secondary.opacity(0.5))
        }
    }
}

struct SelfControl_Previews: PreviewProvider {
    static var previews: some View {
        SelfControl(item: .constant(ChairInfo(id: "asdf", name: "Brommo", price: 10, brand: "34", dateTS: Timestamp(), user: "안병욱")))
    }
}
