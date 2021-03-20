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
    @State var cardNumber = "1234567890123456"
    @State var cardHolder = "Mr L Zungu"
    @State var cvvNumber = "123"
    @State var expiryDate = "08/24"
    
    var banks = ["Absa Group",
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
    @State var selectedBank = "Absa Group"
    
    @State var isNotTapped = true
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.name, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationView{
            List{
                ForEach(cards){ card in
                    NavigationLink(destination: CardView(isNotTapped: isNotTapped, cvvNumber: card.cvvNumber ?? "---", cardNumber: card.cardNumber ?? "Card Number", expiryDate: card.expiryDate ?? "mm/yy", selectedBank: card.name ?? "Unknown", cardHolder: card.cardHolder ?? "unknown")){
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
                        .sheet(isPresented: $isModal){
                            NavigationView{
                                ScrollView{
                                    VStack{
//MARK: The Card
                                        CardView(isNotTapped: isNotTapped, cvvNumber: cvvNumber , cardNumber: cardNumber , expiryDate: expiryDate , selectedBank: selectedBank , cardHolder: cardHolder)
//End of "The Card"//

                                        HStack{
                                            Text("Card Details")
                                                .padding()
                                                .foregroundColor(.primary)
                                                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                                            Spacer()
                                        }
                                        Divider()
                                            .padding(.horizontal)
                                        
                                        Group{
                                            Group{
                                                TextField("Card Number", text: $cardNumber)
                                                    .keyboardType(.numberPad)
                                                    
                                                TextField("Card Holder Name", text: $cardHolder)
                                            }
                                            .simultaneousGesture(TapGesture().onEnded{isNotTapped = true})
                                                
                                            HStack{
                                                TextField("CVV Number", text: $cvvNumber)
                                                    .keyboardType(.numberPad)
                                                    .simultaneousGesture(TapGesture().onEnded{isNotTapped = false})
                                                    
                                                Spacer()
                                                Image(systemName: "creditcard")
                                                    .font(.system(size: 25))
                                            }
                                            
                                            TextField("Expiry Date", text: $expiryDate)
                                                .simultaneousGesture(TapGesture().onEnded{isNotTapped = true})
                                        }
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .foregroundColor(.primary)
                                        
                                        Divider()
                                            .padding(.horizontal)
                                        
                                        Text("Pick Your Bank")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                        
                                        Picker("Pick Your Bank", selection: $selectedBank){
                                            ForEach(banks, id: \.self){
                                                Text($0)
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            addCard()
                                            isModal = false
                                            
                                        }, label: {
                                            Text("+ Save")
                                        })
                                    }
                                }
                                .navigationBarItems(trailing:
                                    Button(action: {
                                        isModal = false
                                    }, label: {
                                        Text("Cancel")
                                    })
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
