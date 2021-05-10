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
    
    @State var isViewList = UserSettings().changeContentView
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Card.name, ascending: UserSettings().sortByAscension)], animation: .default)
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationView{
            if(self.isUnlocked){
                if(!isViewList){
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
                            addCardButton
                    )
                    .navigationTitle("Cards")
                }
                else{
                    ScrollView{
                        ForEach(cards){ card in
                            NavigationLink(destination: CardInfoView(cardNumber: card.cardNumber ?? "Card Number", cardHolder: card.cardHolder ?? "unknown", cvvNumber: card.cvvNumber ?? "---", selectedBank: card.name ?? "Unknown", expiryDate: card.expiryDate ?? "mm/yy", isNotTapped: isNotTapped)){
                                CardView(isNotTapped: isNotTapped, isTapped: isTapped, cvvNumber: card.cvvNumber ?? "---", cardNumber: card.cardNumber ?? "Card Number", expiryDate: card.expiryDate ?? "mm/yy", selectedBank: card.name ?? "Unknown", cardHolder: card.cardHolder ?? "")
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
                            addCardButton
                    )
                    .navigationTitle("Cards")
                }
            }
            else{
                VStack{
                    Text("CARDS")
                        .tracking(10)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 40)

                    Image(systemName: "lock.fill")
                        .padding(.bottom, 50)
                        .font(.system(size: 30))

                    LockScreenCardsView()

                    Spacer()

                    Button(action: {
                        authenticate()
                    }, label: {
                        VStack{
                            Text("Use Biometric")
                                .foregroundColor(.primary)
                                .font(.subheadline)
                                .kerning(2)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                        .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(Color.primary.opacity(0.3))
                                )
                        }
                    })
                    .padding(30)
                }
            }
        }
        .onAppear{
            authenticate()
        }
        
    }
    var GuidanceModalSheet : some View{
        BlurView(style: .systemUltraThinMaterial)
            .mask(
                RoundedRectangle(cornerRadius: 44, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            )
            .overlay(
                ZStack{
                    cvvGuidanceCard
                    hideModalSheetButton
                }
            )
            .shadow(radius: 90, y: 67)
            .padding(5)
            .offset(x: 0, y: isCvvGuideShown ? viewState.height : 400)
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
            .animation(Animation.spring().speed(1.5))
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: 370, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
    }
    
    var cvvGuidanceCard : some View {
        ZStack{
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .stroke(colorScheme == .light ? Color.white.opacity(0.8) : Color.init(UIColor.secondarySystemFill), lineWidth: 1)
                .foregroundColor(.white)
            
            VStack{
                Group{
                    Text("Quick Tip")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .foregroundColor(.primary)
                        .padding()
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .frame(width: 150, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                        .shadow(radius: 10, y: 10)
                        .overlay(
                            guidanceCvvCardStrip
                        )
                        .foregroundColor(Color.init(.quaternaryLabel))
                        
                    Text("You can find the CVV number on the back of the bank card, on the left of the bank card strip.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                }
                .padding()
                Spacer()
            }
        }
    }
    
    var addCardButton : some View {
        Button(action: {
            isModal = true
        }, label: {
            Image(systemName: "plus")
                .font(.system(size: 23))
                .sheet(isPresented: $isModal, onDismiss: {
                    isNotTapped = true
                    isCvvGuideShown = false
                }){
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
                                Group{
                                    colorScheme == .light ? LinearGradient(gradient: Gradient(colors: [Color.white, Color.init(.displayP3, white: 1, opacity: 1), Color.init(.displayP3, white: 1, opacity: 0)]), startPoint: .top, endPoint: .bottom) :
                                        LinearGradient(gradient: Gradient(colors: [Color.init(.displayP3, white: 0, opacity: 2), Color.init(.displayP3, white: 0, opacity: 0.7), Color.clear]), startPoint: .top, endPoint: .bottom)
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Spacer()
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
        )
    }
    
    var guidanceCvvCardStrip : some View {
        Rectangle()
            .frame(width: 150, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color.white.opacity(0.6))
            .offset(x: 0, y: 10)
            .overlay(
                Rectangle()
                    .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .frame(width: 40, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.red)
                    .offset(x: 40, y: 10)
                    .overlay(
                        Text("000")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .offset(x: 40, y: 10)
                    )
            )
    }
    
    var hideModalSheetButton : some View {
        Button(action: {
            isCvvGuideShown.toggle()
        }, label: {
            Rectangle()
                .mask(Circle())
                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    Image(systemName: "multiply")
                        .font(.headline)
                        .foregroundColor(Color.init(.tertiaryLabel))
                )
                .foregroundColor(Color.init(.tertiarySystemFill))
        })
        .offset(x: 150, y: -160)
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
            .colorScheme(.dark)
    }
}
