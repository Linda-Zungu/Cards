//
//  CardView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/20.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var isNotTapped : Bool
    
    var cvvNumber : String
    var cardNumber : String
    var expiryDate : String
    var selectedBank : String
    var cardHolder : String
    
    var body: some View {
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
                            Text("\(selectedBank)")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                                .padding()
                                .opacity(isNotTapped ? 1 : 0.35)
                            Spacer()
                            Image("\(getCardType(number: cardNumber))")
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .opacity(isNotTapped ? 1 : 0.25)
                                .frame(width: 50, height: 50)
                                .padding(.horizontal, 10)
                        }
                        
                        Spacer(minLength: 30)
                        
                        Text("\(cardNumber)")
                            .tracking(7)
                            .shadow(radius: 1, y: 2)
                            .foregroundColor(.white)
                            .opacity(isNotTapped ? 1 : 0.15)
                        
                        Spacer(minLength: 5)

                        Text("\(expiryDate)")
                            .tracking(7)
                            .shadow(radius: 1, y: 2)
                            .foregroundColor(.white)
                            .opacity(isNotTapped ? 1 : 0)
                        
                        Spacer(minLength: 5)
                        HStack{

                            Text("\(cardHolder)")
                                .tracking(3)
                                .shadow(radius: 1, y: 2)
                                .foregroundColor(.white)
                                .padding()
                                .opacity(isNotTapped ? 1 : 0.15)
                            
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
    }
    
    private func getCardType(number : String) -> String{
        let num = Array(number)
        if(num.count > 0){
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
        return "NoImage"
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(isNotTapped: false, cvvNumber: "123", cardNumber: "5123456789012345", expiryDate: "11/22", selectedBank: "Absa Bank", cardHolder: "Mr L Zungu")
            .previewLayout(.sizeThatFits)
    }
}
