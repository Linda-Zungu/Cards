//
//  CardDetailsView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/21.
//

import SwiftUI

struct CardDetailsView: View {
    
    @Binding var cardNumber : String
    @Binding var cardHolder : String
    @Binding var cvvNumber : String
    @Binding var expiryDate : String
    
    var banks = ["Absa Group",
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
                        TextField("Card Number", text: $cardNumber)
                            .keyboardType(.numberPad)
                        Spacer()
                        VerifiedView(cardNumber: cardNumber)
                    }                    
                        
                    TextField("Card Holder Name", text: $cardHolder)
                }
                .simultaneousGesture(TapGesture().onEnded{
                    isNotTapped = true
                    isTapped = false
                })
                    
                HStack{
                    TextField("CVV Number", text: $cvvNumber)
                        .keyboardType(.numberPad)
                        .simultaneousGesture(TapGesture().onEnded{
                            isNotTapped = false
                            isTapped = true
                        })
                        
                    Spacer()
                    Image(systemName: "creditcard")
                        .font(.system(size: 25))
                }
                
                TextField("Expiry Date", text: $expiryDate)
                    .simultaneousGesture(TapGesture().onEnded{
                        isNotTapped = true
                        isTapped = false
                    })
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
