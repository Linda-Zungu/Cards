//
//  CardRowView.swift
//  Cards
//
//  Created by Linda Zungu on 3/2/21.
//

import SwiftUI

struct CardRowView: View {
    
    var cardName : String
    
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 70, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(radius: 5, y: 8)
                .foregroundColor(.blue)
                .padding()
            Text("\(cardName)")
            Spacer()
        }
    }
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(cardName: "Standard Bank")
            .previewLayout(.sizeThatFits)
    }
}
