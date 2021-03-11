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
    @State var cardNumber = "6372 2789 2793"
    @State var cardHolder = "Mr L Zungu"
    
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
                    Image(systemName: "plus")
                        .font(.body)
                        .sheet(isPresented: $isModal){
                            NavigationView{
                                ScrollView{
                                    VStack{
                                        Text("Hello World!")
                                    }
                                }
                                .navigationTitle("Add Card")
                                .navigationBarTitleDisplayMode(.inline)
                            }
                            .foregroundColor(.primary)
                        }
                        .font(.none)
                    }
            ))
            .navigationTitle("Cards")
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
