//
//  CardDetailsView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/21.
//

import SwiftUI
import Combine

struct CardDetailsView: View {
    
    @Binding var cardNumber : String
    @Binding var cardHolder : String
    @Binding var cvvNumber : String
    @Binding var expiryDate : String
    
    var banks = ["Choose Bank",
                 "Absa Bank",
                 "African Bank",
                 "Bidvest Bank",
                 "Capitec Bank",
                 "Discovery",
                 "First National Bank",
                 "FirstRand Bank",
                 "Investec Bank ",
                 "Nedbank",
                 "Standard Bank",
                 "TymeBank"
    ]
    
    @Binding var selectedBank : String
    @Binding var isNotTapped : Bool
    @Binding var isTapped : Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("Card Details")
                    .padding()
                    .foregroundColor(.primary)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            Divider()
                .padding(.horizontal)
            
            Group{
                Group{
                    HStack{
                        DoneTextField(placeholder: "Card Number", text: $cardNumber, keyBoardType: .default)
                            .keyboardType(.numberPad)
                            .onReceive(Just(3)) { inputValue in
                                // With a little help from https://bit.ly/2W1Ljzp
                                if cardNumber.count > 16 {
                                    self.cardNumber.removeLast()
                                }
                            }
                        Spacer()
                        VerifiedView(cardNumber: cardNumber)
                    }                    
                        
                    DoneTextField(placeholder: "Card Holder Name", text: $cardHolder, keyBoardType: .default)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    isNotTapped = true
                    isTapped = false
                })
                    
                HStack{
                    DoneTextField(placeholder: "CVV Number", text: $cvvNumber, keyBoardType: .numberPad)
                        .simultaneousGesture(TapGesture().onEnded{
                            isNotTapped = false
                            isTapped = true
                        })
                        .onReceive(Just(3)) { inputValue in
                            if cvvNumber.count > 3 {
                                self.cvvNumber.removeLast()
                            }
                        }
                        
                    Spacer()
                    Image(systemName: "creditcard")
                        .font(.system(size: 25))
                }
                
                DoneTextField(placeholder: "Expiry Date", text: $expiryDate, keyBoardType: .default)
                    .simultaneousGesture(TapGesture().onEnded{
                        isNotTapped = true
                        isTapped = false
                    })
                    .onReceive(Just(3)) { inputValue in
                        if expiryDate.count > 5 {
                            self.expiryDate.removeLast()
                        }
                    }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .foregroundColor(.primary)
            
            Divider()
                .padding(.horizontal)
            
            Text("Pick Your Bank")
                .font(.headline)
                .foregroundColor(.gray)
            
            Picker("Pick Your Bank", selection: $selectedBank){
                ForEach(banks, id: \.self){
                    Text($0)
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsView(cardNumber: Binding.constant(""), cardHolder: Binding.constant(""), cvvNumber: Binding.constant(""), expiryDate: Binding.constant(""), selectedBank: Binding.constant(""), isNotTapped: Binding.constant(true), isTapped: Binding.constant(true))
    }
}
