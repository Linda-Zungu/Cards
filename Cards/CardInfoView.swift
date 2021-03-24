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
    @State var isMapTapped = true
    
    var body: some View {
        ZStack{
            VStack{
                CardView(isNotTapped: isCardNotTapped, isTapped: isTapped, cvvNumber: cvvNumber, cardNumber: cardNumber, expiryDate: expiryDate, selectedBank: selectedBank, cardHolder: cardHolder)
                    .onTapGesture {
                        isCardNotTapped.toggle()
                        isTapped = false
                    }
                Spacer()
            }
            VStack{
                Spacer(minLength: isMapTapped ? 10 : 0)
                
                MapView()
                    .frame(width: UIScreen.main.bounds.width-(isMapTapped ? 40 : 0), height: isMapTapped ? 450 : UIScreen.main.bounds.height+50)
                    .cornerRadius(isMapTapped ? 15 : 0)
                    .padding(.top, isMapTapped ? 270 : 0)
                    .onTapGesture {
                        isMapTapped.toggle()
                    }
                    .shadow(radius: 20, y: 20)
                    .overlay(
                        Button(action: {
                            isMapTapped.toggle()
                        }, label: {
                            BlurView(style: .systemUltraThinMaterial)
                                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .cornerRadius(10)
                                .overlay(
                                    Image(systemName: "rectangle.expand.vertical")
                                        .font(.system(size: 22))
                                        .foregroundColor(.primary)
                                )
                                .shadow(color: .init(.displayP3, white: 0, opacity: 0.2),radius: 10)
                                .padding(.trailing, isMapTapped ? 280 : 320)
                                .padding(.bottom, isMapTapped ? 110 : UIScreen.main.bounds.height-195)
                        })
                        
                    )
                    .animation(.spring())
                    .edgesIgnoringSafeArea(.top)
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
