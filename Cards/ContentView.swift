//
//  ContentView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isUnlocked = false
    
    @State var isModal = false
    @State var cardNumber = ""
    @State var cardHolder = ""
    @State var cvvNumber = ""
    @State var expiryDate = ""
    
    var banks = ["Absa Bank",
                 "African Bank",
                 "Bidvest Bank",
                 "Capitec Bank",
                 "Discovery",
                 "Choose Bank",
                 "First National Bank",
                 "FirstRand Bank",
                 "Investec Bank ",
                 "Nedbank",
                 "Standard Bank",
                 "TymeBank"
    ]
    @State var selectedBank = "Choose Bank"
    
    @State var isNotTapped = true
    @State var isTapped = true
    @State var isCvvGuideShown = false
    @State var viewState = CGSize.zero
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.name, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationView{
//            if(self.isUnlocked){
                List{
                    ForEach(cards){ card in
                        NavigationLink(destination: CardInfoView(cardNumber: card.cardNumber ?? "Card Number", cardHolder: card.cardHolder ?? "unknown", cvvNumber: card.cvvNumber ?? "---", selectedBank: card.name ?? "Unknown", expiryDate: card.expiryDate ?? "mm/yy", isNotTapped: isNotTapped)){
                            CardRowView(cardName: card.name ?? "Unknown", cardNumber: card.cardNumber ?? "Card Number", expiryDate: card.expiryDate ?? "mm/yy", cardType: card.cardType ?? "")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(InsetGroupedListStyle())
                
                .navigationBarItems(leading:
                    NavigationLink(destination: SettingsView()){
                        Image(systemName: "gear")
                            .font(.system(size: 23))
                    },
                    trailing:
                Button(action: {
                    isModal = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 23))
                        .sheet(isPresented: $isModal, onDismiss: {isNotTapped = true}){
                            NavigationView{
                                ZStack{
                                    ScrollView{
                                        VStack{
                                            CardDetailsView(cardNumber: $cardNumber, cardHolder: $cardHolder, cvvNumber: $cvvNumber, expiryDate: $expiryDate, selectedBank: $selectedBank, isNotTapped: $isNotTapped, isTapped: $isTapped, isCvvGuideShown: $isCvvGuideShown)
                                                .padding(.top, 290)

                                            Spacer()
                                        }
                                    }
                                    VStack{
                                        CardView(isNotTapped: isNotTapped, isTapped: isTapped, cvvNumber: cvvNumber, cardNumber: cardNumber, expiryDate: expiryDate, selectedBank: selectedBank, cardHolder: cardHolder)

                                        Spacer()
                                    }
                                    
                                    VStack{
                                        Spacer()
                                        GuidanceModalSheet
                                    }
                                }

                                .navigationBarItems(leading:
                                    Button(action: {
                                        isModal = false
                                        isTapped = true
                                        isNotTapped = true
                                        isCvvGuideShown = false

                                        cardNumber = ""
                                        cardHolder = ""
                                        cvvNumber = ""
                                        expiryDate = ""
                                        selectedBank = banks[5]
                                    }, label: {
                                        Text("Cancel")
                                    }), trailing:
                                        Button(action: {
                                            if(selectedBank != banks[5] && cardNumber != "" && cardHolder != "" &&
                                                cvvNumber != "" && expiryDate != ""){
                                                addCard()
                                                isModal = false
                                                isTapped = true
                                                isNotTapped = true
                                                isCvvGuideShown = false

                                                cardNumber = ""
                                                cardHolder = ""
                                                cvvNumber = ""
                                                expiryDate = ""
                                                selectedBank = banks[5]
                                            }
                                        }, label: {
                                            Text("+ Save")
                                                .foregroundColor(selectedBank != banks[5] && (checkTextField(number: cardNumber))  && cardHolder != "" && cvvNumber.count == 3  && expiryDate != "" ? .blue : .gray)
                                        })
                                        .disabled(selectedBank != banks[5] && (checkTextField(number: cardNumber))  && cardHolder != "" && cvvNumber.count == 3  && expiryDate != "" ? false : true)
                                )
                                .navigationTitle("Add Card")
                                .navigationBarTitleDisplayMode(.inline)
                            }
                        }
                        .font(.none)
                    }
                ))
                .navigationTitle("Cards")
            }
//            else{
//                VStack{
//                    Text("CARDS")
//                        .tracking(10)
//                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                        .padding(.bottom, 40)
//
//                    Image(systemName: "lock.fill")
//                        .padding(.bottom, 50)
//                        .font(.system(size: 30))
//
//                    LockScreenCardsView()
//
//                    Spacer()
//
//                    Button(action: {
//                        authenticate()
//                    }, label: {
//                        VStack{
//                            Text("Use Biometric")
//                                .foregroundColor(.primary)
//                                .font(.subheadline)
//                                .kerning(2)
//                                .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 15, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
//                                        .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                        .foregroundColor(Color.primary.opacity(0.3))
//                                )
//                        }
//                    })
//                    .padding(30)
//                }
//            }
//        }
//        .onAppear{
//            authenticate()
//        }
        
    }
    var GuidanceModalSheet : some View{
        BlurView(style: .systemUltraThinMaterial)
            .mask(
                RoundedRectangle(cornerRadius: 35, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .stroke(colorScheme == .light ? Color.white.opacity(0.8) : Color.init(UIColor.secondarySystemFill), lineWidth: 1)
                    .foregroundColor(.white)
            )
            .shadow(radius: 90, y: 67)
            .padding(17)
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .offset(x: 0, y: isCvvGuideShown ? viewState.height*1.5 : 380)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        viewState = value.translation
                    }
                    .onEnded { value in
                        if (self.viewState.height) > 100{
                            isCvvGuideShown.toggle()
                        }
                        viewState = .zero
                    }
            )
            .animation(Animation.spring())
            
    }
    
    private func addCard(){
        withAnimation{
            let card = Card(context: viewContext)
            card.name = self.selectedBank
            card.id = UUID()
            card.cardNumber = self.cardNumber
            card.cvvNumber = self.cvvNumber
            card.expiryDate = self.expiryDate
            card.cardHolder = self.cardHolder
            card.cardType = getCardType(number: cardNumber)
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func getCardType(number : String) -> String{
        let num = Array(number)
        if(num[0] == "5" && num.count == 16){
            return colorScheme == .dark ? "MasterCard_Light" : "MasterCard_Dark"
        }
        else if(num[0] == "4" && (num.count == 16 || num.count == 13)){
            return "Visa"
        }
        else{
            return "NoImage"
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { cards[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func checkTextField(number : String) -> Bool{
        let num = Array(number)
        return ((num.count == 13 || num.count == 16) && num[0] == "4") || (num.count == 16 && num[0] == "5")
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Passcode required to gain access to your data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                        print("Biometric failed")
                        
                    }
                }
            }
        } else {
            // no biometrics allowed: Fix this!
            print("No biometrics allowed")
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "") { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .colorScheme(.dark)
    }
}
