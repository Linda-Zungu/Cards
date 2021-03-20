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
                .frame(width: 70, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    VStack(alignment: .leading){
                        Group{
                            HStack{
                                Text("\(cardName == "First National Bank" ? "FNB" : cardName)")
                                    .bold()
                                    .padding(.top, 4)
                                    .padding(.bottom, 0.1)
                                    .padding(.leading, 5)
                                
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
                                .padding(.leading, 5)
                                
                            Text("\(expiryDate)")
                                .offset(x: 28, y: 2)
                                .padding(.leading, 5)
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 5))
                        .shadow(radius: 1, y: 1)
                        Spacer()
                    }
                    
                )
                .shadow(radius: 5, y: 8)
                .foregroundColor(.blue)
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
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(cardName: "Standard Bank", cardNumber: "0001000200030004", expiryDate: "08/24", cardType: "MasterCard_Dark")
            .previewLayout(.sizeThatFits)
        CardRowView(cardName: "Standard Bank", cardNumber: "0001000200030004", expiryDate: "08/24", cardType: "MasterCard_Light")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
