//
//  CardInfoView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/21.
//

import SwiftUI

struct CardInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var cardNumber : String
    var cardHolder : String
    var cvvNumber : String
    var selectedBank : String
    var expiryDate : String
    var isNotTapped : Bool

    @State var isCardNotTapped = true
    var body: some View {
        ScrollView{
            VStack{
                CardView(isNotTapped: isCardNotTapped, cvvNumber: cvvNumber, cardNumber: cardNumber, expiryDate: expiryDate, selectedBank: selectedBank, cardHolder: cardHolder)
                    .onTapGesture {
                        isCardNotTapped.toggle()
                    }
                    
            }
        }
        .navigationBarTitle("\(selectedBank)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CardInfoView(cardNumber: "4001000200030004", cardHolder: "Mr L Zungu", cvvNumber: "123", selectedBank: "Standard Bank", expiryDate: "11/23", isNotTapped: true)
    }
}
