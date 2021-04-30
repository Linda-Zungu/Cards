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
    var isTapped : Bool
    @State var wave = false
    
    var cvvNumber : String
    var cardNumber : String
    var expiryDate : String
    var selectedBank : String
    var cardHolder : String
    
    var body: some View {
        ZStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)//not gradient
                    .foregroundColor(.clear)
                    .background(
                        getColorForLowerCard(bankName: selectedBank)
                            .cornerRadius(5)
                    )
                    .frame(width: 130, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaleEffect(2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .animation(Animation.spring(response: 0.55, dampingFraction: 3.6, blendDuration: 0.9).speed(0.8).delay(0.4))
                    .offset(x: 0, y: 12)
                    .shadow(color: Color.init(.displayP3, white: 0, opacity: 0.25), radius: 5, y: 5)
                    
                RoundedRectangle(cornerRadius: 10)//has gradient
                    .foregroundColor(.clear)
                    .background(
                        getColorForBank(bankName: selectedBank)
                            .cornerRadius(5)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                    )
                    .frame(width: 150, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaleEffect(2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .animation(Animation.spring(response: 0.45, dampingFraction: 2.9, blendDuration: 0.9).speed(1.0).delay(0.3))
                    .offset(x: 0, y: 9)
                    .shadow(color: Color.init(.displayP3, white: 0, opacity: 0.25), radius: 5, y: 5)
            }
            
            BlurView(style: .systemUltraThinMaterial)
                .frame(width: UIScreen.main.bounds.width-40, height: 220, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(colorScheme == .light ? Color.white.opacity(0.75) : Color.init(UIColor.secondarySystemFill), lineWidth: 2)
                        
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
                                    .opacity(isNotTapped ? 0.7 : 0.35)
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
                    .animation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.2))
                    
                )
                .cornerRadius(15)
                .rotation3DEffect(
                    .degrees(isNotTapped ? 0 : 180),
                    axis: (x: 0.0, y: 2.0, z: 0.0)
                    )
                .padding()
                .padding(.horizontal)
                .shadow(color: Color.init(.displayP3, white: 0, opacity: 0.25), radius: 25, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 20)
                .animation(.spring(response: isTapped ? (isNotTapped ? 2.0 : 0.7): (isTapped ? 2.0 : 0.7) , dampingFraction: 0.6, blendDuration: 0.2))
//                .background(
//                    Group{
//                        colorScheme == .light ? LinearGradient(gradient: Gradient(colors: [Color.white, Color.init(.displayP3, white: 1, opacity: 0.8), Color.init(.displayP3, white: 1, opacity: 0)]), startPoint: .top, endPoint: .bottom) :
//                            LinearGradient(gradient: Gradient(colors: [Color.init(.displayP3, white: 0, opacity: 1), Color.clear]), startPoint: .top, endPoint: .bottom)
//                    }
//                    .overlay(
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 10)//not gradient
//                                .foregroundColor(.clear)
//                                .background(
//                                    getColorForLowerCard(bankName: selectedBank)
//                                        .cornerRadius(5)
//                                )
//                                .frame(width: 130, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .scaleEffect(2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .animation(Animation.spring(response: 0.55, dampingFraction: 3.6, blendDuration: 0.9).speed(0.8).delay(0.4))
//                                .offset(x: 0, y: 12)
//                                .shadow(color: Color.init(.displayP3, white: 0, opacity: 0.25), radius: 5, y: 5)
//
//                            RoundedRectangle(cornerRadius: 10)//has gradient
//                                .foregroundColor(.clear)
//                                .background(
//                                    getColorForBank(bankName: selectedBank)
//                                        .cornerRadius(5)
//                                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
//                                )
//                                .frame(width: 150, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .scaleEffect(2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                .animation(Animation.spring(response: 0.45, dampingFraction: 2.9, blendDuration: 0.9).speed(1.0).delay(0.3))
//                                .offset(x: 0, y: 9)
//                                .shadow(color: Color.init(.displayP3, white: 0, opacity: 0.25), radius: 5, y: 5)
//                        }
//                    )
//                )
            
        }
        
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
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.black.opacity(0.6), Color.gray]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Discovery"){
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.black]), startPoint: .top, endPoint: .bottomTrailing)
        }
        else{
            return LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: .leading, endPoint: .trailing)
        }
    }
    
    
    private func getColorForLowerCard(bankName : String) -> LinearGradient{
        if(bankName == "Standard Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.init(.displayP3, red: 0, green: 0, blue: 1, opacity: 0.5)]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Absa Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.75), Color.red]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "African Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), Color.init(.displayP3, red: 0, green: 0.3, blue: 0, opacity: 1), Color.black]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Bidvest Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(1), Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottomLeading)
        }
        else if(bankName == "Capitec Bank"){
            return LinearGradient(gradient: Gradient(colors: [Color.black.opacity(1), Color.gray.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
        }
        else if(bankName == "Discovery"){
            return LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.black]), startPoint: .top, endPoint: .bottomTrailing)
        }
        else{
            return LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: .leading, endPoint: .trailing)
            //Add more banks later!
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(isNotTapped: true, isTapped: false, cvvNumber: "123", cardNumber: "5123456789012345", expiryDate: "11/22", selectedBank: "Absa Bank", cardHolder: "Mr L Zungu")
            .previewLayout(.sizeThatFits)
    }
}
