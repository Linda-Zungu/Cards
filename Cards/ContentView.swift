//
//  ContentView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var isModal = false
    @State var cardNumber = ""
    @State var cardHolder = ""
    
    var banks = ["Absa Group Limited",
                 "African Bank Limited",
                 "Bidvest Bank Limited",
                 "Capitec Bank Limited",
                 "Discovery Limited",
                 "First National Bank",
                 "FirstRand Bank",
                 "Investec Bank Limited",
                 "Nedbank Limited",
                 "Standard Bank of South Africa",
                 "TymeBank"
    ]
    @State var selectedBank = ""
    
    
    
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.name, ascending: true)],
        animation: .default)
    private var cards: FetchedResults<Card>

    var body: some View {
        NavigationView{
            List{
                ForEach(cards){ card in
                    CardRowView(cardName: card.name ?? "Unknown")
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
                                        HStack{
                                            Text("Card Details")
                                                .padding()
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
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
                                        
                                        Divider()
                                            .padding(.horizontal)
                                        
                                        Group{
                                            TextField("Card Number", text: $cardNumber)
                                            TextField("Card Holder Name", text: $cardHolder)
                                            HStack{
                                                TextField("CVV Number", text: .constant("123"))
                                                Spacer()
                                                Image(systemName: "creditcard")
                                                    .font(.system(size: 25))
                                            }
                                        }
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .foregroundColor(.primary)
                                            
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            addCard()
                                            isModal = false
                                        }, label: {
                                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .overlay(Text("Save").foregroundColor(.primary))
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
        let card = Card(context: viewContext)
        card.name = self.selectedBank
        card.id = UUID()
        card.cardNumber = self.cardNumber
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            let cardItem = Card(context: viewContext)
            let cardNames = ["Absa", "Standard Bank", "Nedbank"]
            
            cardItem.id = UUID()
            cardItem.name = "\(cardNames.randomElement()!)"

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
