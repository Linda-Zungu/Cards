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
                Spacer(minLength: isMapTapped ? CGFloat(10) : 0)
                MapView(nameOfBank: selectedBank)
                    .frame(width: UIScreen.main.bounds.width-(isMapTapped ? 40 : 0), height: isMapTapped ? 450 : UIScreen.main.bounds.height+50)
                    .cornerRadius(isMapTapped ? 15 : 0)
                    .shadow(radius: 5, y: 6)
                    .overlay(
                        VStack{
                            HStack(alignment: .top){
                                Button(action: {
                                    isMapTapped.toggle()
                                }, label: {
                                        BlurView(style: .systemUltraThinMaterial)
                                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                                    .stroke(colorScheme == .light ? Color.white.opacity(0.8) : Color.init(UIColor.secondarySystemFill), lineWidth: 0.5)
                                                    .overlay(
                                                        Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
                                                            .font(.system(size: 27))
                                                            .foregroundColor(.primary)
                                                    )

                                            )
                                            .shadow(color: .init(.displayP3, white: 0, opacity: 0.2),radius: 10)
                                            .padding(isMapTapped ? 8 : 0)
                                            .padding(.top, isMapTapped ? CGFloat(0) : 100)
                                            .padding(.leading, isMapTapped ? CGFloat(0) : 8)
                                    })
                                Spacer()
                            }
                            Spacer()
                        }
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4))
                    .edgesIgnoringSafeArea(.top)
            }
        }
        .navigationBarTitle("\(selectedBank)")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarHidden(isMapTapped ? false : true)
    }
}

struct CardInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CardInfoView(cardNumber: "4001000200030004", cardHolder: "Mr L Zungu", cvvNumber: "123", selectedBank: "Standard Bank", expiryDate: "11/23", isNotTapped: true)
    }
}
