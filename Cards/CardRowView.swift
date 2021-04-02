//
//  CardRowView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI

struct CardRowView: View {
    @Environment(\.colorScheme) var colorScheme
    var cardName : String
    var cardNumber : String
    var expiryDate : String
    var cardType : String
    
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 70, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(
                    getColorForBank(bankName: cardName)
                        .cornerRadius(5)
                )
                .overlay(
                    VStack(alignment: .leading){
                        Group{
                            HStack{
                                Text("\(cardName == "First National Bank" ? "FNB" : cardName)")
                                    .bold()
                                    .padding(.top, 4)
                                    .padding(.bottom, 0.1)
                                    .padding(.leading, 5)
                                    .foregroundColor(/*cardName == "Capitec Bank" ? Color.yellow.opacity(0.8) : */.white)
                                
                                Spacer()
                                
                                Image("\(getCardType(number: cardNumber) == "MasterCard_Dark" ? "MasterCard_Light" : "\(getCardType(number: cardNumber))")")
                                    .resizable()
                                    .clipped()
                                    .scaledToFit()
                                    .frame(width: 11, height: 8, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .padding(.trailing, 3)
                                    .padding(.top, 3)
                            }
                            
                            
                            Text("\(cardNumber)")
                                .tracking(0.5)
                                .padding(.leading, cardNumber.count == 16 ? 5 : 11)
                                .foregroundColor(/*cardName == "Capitec Bank" ? Color.yellow.opacity(0.8) : */.white)
                                
                            Text("\(expiryDate)")
                                .offset(x: 28, y: 2)
                                .padding(.leading, 5)
                                .foregroundColor(/*cardName == "Capitec Bank" ? Color.yellow.opacity(0.8) : */.white)
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 5))
                        .shadow(radius: 1, y: 1)
                        Spacer()
                    }
                    
                )
                .shadow(radius: 5, y: 8)
                .foregroundColor(.clear)
                .padding()
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(cardName)")
                        .padding(.bottom, 1)
                    
                    Spacer()

                    Image("\(getCardType(number: cardNumber))")
                        .resizable()
                        .clipped()
                        .scaledToFit()
                        .frame(width: colorScheme == .dark ? 20 : 20, height: colorScheme == .dark ? 15 : 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
                Text("\(cardNumber)")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            Spacer()
            
            
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
    
    private func getColorForBank(bankName : String) -> LinearGradient{
        if(bankName == "Standard Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.65), Color.init(.displayP3, red: 0, green: 0.25, blue: 0.8, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Absa Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.75), Color.init(.displayP3, red: 0.55, green: 0, blue: 0.37, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "African Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), Color.init(.displayP3, red: 0, green: 0.3, blue: 0, opacity: 1), Color.init(.displayP3, red: 0, green: 0, blue: 0, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Bidvest Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.init(.displayP3, red: 0, green: 0, blue: 0.52, opacity: 1)]), startPoint: .top, endPoint: .bottomLeading)
        }
        else if(bankName == "Capitec Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.black]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Discovery"){
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.black]), startPoint: .top, endPoint: .bottomTrailing)
        }
        else{
            return LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        }
    }
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(cardName: "Discovery", cardNumber: "0001000200030", expiryDate: "08/24", cardType: "MasterCard_Dark")
            .previewLayout(.sizeThatFits)
    }
}
