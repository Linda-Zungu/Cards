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
    @State var cardNumber = "1234567890123456"
    @State var cardHolder = "Mr L Zungu"
    @State var cvvNumber = "123"
    
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
    @State var selectedBank = ""
    
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
                                        BlurView(style: .systemUltraThinMaterial)
                                            .frame(width: UIScreen.main.bounds.width-40, height: 220, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .overlay(
                                                ZStack{
                                                    VStack{
                                                        BlurView(style: .systemChromeMaterial)
                                                            .opacity(isNotTapped ? 0 : 1)
                                                            .frame(width: UIScreen.main.bounds.width-40, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                            .padding(.top, 60)
                                                            .overlay(
                                                                HStack{
                                                                    Text("\(cvvNumber)")
                                                                        .tracking(7)
                                                                        .rotation3DEffect(
                                                                            .degrees(180),
                                                                            axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                                                        .padding(.top, 60)
                                                                        .padding(.horizontal, 50)
                                                                        .foregroundColor(.primary)
                                                                        .font(.headline)
                                                                        .opacity(isNotTapped ? 0 : 1)
                                                                    
                                                                    Spacer()
                                                                }
                                                            )
                                                    }
                                                        
                                                    VStack{
                                                        HStack{
                                                            Text(isNotTapped ? "\(selectedBank)" : "")
                                                                .foregroundColor(.white)
                                                                .font(.title2)
                                                                .bold()
                                                                .padding()
                                                            Spacer()
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text(isNotTapped ? "\(cardNumber)" : "")
                                                            .tracking(7)
                                                            .shadow(radius: 1, y: 2)
                                                            .foregroundColor(.white)
                                                        
                                                        Spacer(minLength: 60)
                                                        HStack{
                                                            Text(isNotTapped ? "\(cardHolder)" : "")
                                                                .tracking(3)
                                                                .shadow(radius: 1, y: 2)
                                                                .foregroundColor(.white)
                                                                .padding()
                                                            
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                                
                                            )
                                            .cornerRadius(15)
                                            .rotation3DEffect(
                                                .degrees(isNotTapped ? 0 : 180),
                                                axis: (x: 0.0, y: 2.0, z: 0.0)
                                                )
                                            .shadow(radius: 10, y: 10)
                                            .padding()
                                            .animation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.2))
                                            

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
                                            .gesture(TapGesture().onEnded{isNotTapped = true})
                                                
                                            HStack{
                                                TextField("CVV Number", text: $cvvNumber)
                                                    .keyboardType(.numberPad)
                                                    .simultaneousGesture(TapGesture().onEnded{isNotTapped = false})
                                                    
                                                Spacer()
                                                Image(systemName: "creditcard")
                                                    .font(.system(size: 25))
                                            }
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
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
