//
//  CardRowView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI

struct CardRowView: View {
    
    var cardName : String
    var cardNumber : String
    var expiryDate : String
    
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 70, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    VStack{
                        Group{
                            Text("\(cardNumber)")
                            Text("\(expiryDate)")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 5))
                    }
                    
                )
                .shadow(radius: 5, y: 8)
                .foregroundColor(.blue)
                .padding()
            
            VStack(alignment: .leading){
                Text("\(cardName)")
                    .padding(.bottom, 1)
                Text("\(cardNumber)")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            Spacer()
        }
    }
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(cardName: "Standard Bank", cardNumber: "0001000200030004", expiryDate: "08/24")
            .previewLayout(.sizeThatFits)
    }
}
