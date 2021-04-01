//
//  ContentView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isModal = false
    @State var cardNumber = ""
    @State var cardHolder = ""
    @State var cvvNumber = ""
    @State var expiryDate = ""
    
    var banks = ["Choose Bank",
                 "Absa Bank",
                 "African Bank",
                 "Bidvest Bank",
                 "Capitec Bank",
                 "Discovery",
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
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.name, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationView{
            List{
                ForEach(cards){ card in
                    NavigationLink(destination: CardInfoView(cardNumber: card.cardNumber ?? "Card Number", cardHolder: card.cardHolder ?? "unknown", cvvNumber: card.cvvNumber ?? "---", selectedBank: card.name ?? "Unknown", expiryDate: card.expiryDate ?? "mm/yy", isNotTapped: isNotTapped)){
                        CardRowView(cardName: card.name ?? "Unknown", cardNumber: card.cardNumber ?? "Card Number", expiryDate: card.expiryDate ?? "mm/yy", cardType: card.cardType ?? "")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(InsetGroupedListStyle())
            
        
            .navigationBarItems(trailing:
                Button(action: {
                    isModal = true
                }, label: {
                    Text("Add Card")
                        .font(.body)
                        .sheet(isPresented: $isModal, onDismiss: {isNotTapped = true}){
                            NavigationView{
                                ZStack{
                                    ScrollView{
                                        VStack{
                                            CardDetailsView(cardNumber: $cardNumber, cardHolder: $cardHolder, cvvNumber: $cvvNumber, expiryDate: $expiryDate, selectedBank: $selectedBank, isNotTapped: $isNotTapped, isTapped: $isTapped)
                                                .padding(.top, 290)
                                            
                                            Spacer()
                                        }
                                    }
                                    VStack{
                                        CardView(isNotTapped: isNotTapped, isTapped: isTapped, cvvNumber: cvvNumber, cardNumber: cardNumber, expiryDate: expiryDate, selectedBank: selectedBank, cardHolder: cardHolder)
                                        
                                        Spacer()
                                    }
                                }
                                
                                .navigationBarItems(leading:
                                    Button(action: {
                                        isModal = false
                                        isTapped = true
                                        isNotTapped = true
                                        
                                        cardNumber = ""
                                        cardHolder = ""
                                        cvvNumber = ""
                                        expiryDate = ""
                                        selectedBank = banks[0]
                                    }, label: {
                                        Text("Cancel")
                                    }), trailing:
                                        Button(action: {
                                            if(selectedBank != banks[0] && cardNumber != "" && cardHolder != "" &&
                                                cvvNumber != "" && expiryDate != ""){
                                                addCard()
                                                isModal = false
                                                isTapped = true
                                                isNotTapped = true

                                                cardNumber = ""
                                                cardHolder = ""
                                                cvvNumber = ""
                                                expiryDate = ""
                                                selectedBank = banks[0]
                                            }
                                        }, label: {
                                            Text("+ Save")
                                                .foregroundColor(selectedBank != banks[0] && (checkTextField(number: cardNumber))  && cardHolder != "" && cvvNumber.count == 3  && expiryDate != "" ? .blue : .gray)
                                        })
                                        .disabled(selectedBank != banks[0] && (checkTextField(number: cardNumber))  && cardHolder != "" && cvvNumber.count == 3  && expiryDate != "" ? false : true)
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
