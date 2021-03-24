//
//  CardInfoView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/21.
//

import SwiftUI
import MapKit

struct CardInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var cardNumber : String
    var cardHolder : String
    var cvvNumber : String
    var selectedBank : String
    var expiryDate : String
    var isNotTapped : Bool
    
    @State var isTapped = true

    @State var isCardNotTapped = true
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -34.0999, longitude: 18.4241), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        ScrollView{
            VStack{
                Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: UIScreen.main.bounds.width-40, height: 450, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(15)
                    .padding()
                
                CardView(isNotTapped: isCardNotTapped, isTapped: isTapped, cvvNumber: cvvNumber, cardNumber: cardNumber, expiryDate: expiryDate, selectedBank: selectedBank, cardHolder: cardHolder)
                    .onTapGesture {
                        isCardNotTapped.toggle()
                        isTapped = false
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