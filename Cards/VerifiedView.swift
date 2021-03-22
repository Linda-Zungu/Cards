//
//  VerifiedView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/03/17.
//

import SwiftUI

struct VerifiedView: View {
    @Environment(\.colorScheme) var colorScheme
    var cardNumber : String
    
    var body: some View {
        getVerificationIcon(number: cardNumber)
    }
    
    private func getVerificationIcon(number : String) -> some View{
        let num = Array(number)
        
        if(num.count > 0){
            if(num[0] == "5" && num.count == 16){
                return Circle()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                    )
                    .foregroundColor(.green)
            }
            else if(num[0] == "4" && (num.count == 16 || num.count == 13)){
                return Circle()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                    )
                    .foregroundColor(.green)
            }
            else if(num.count < 13 || (num.count > 13 && num.count < 16)){
                return Circle()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Image(systemName: "minus")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                    )
                    .foregroundColor(.orange)
                
            }
            else{
                return Circle()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Image(systemName: "multiply")
                            .foregroundColor(.white)
                            .font(.system(size: 13))
                    )
                    .foregroundColor(.red)
            }
        }
        return Circle()
            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(
                Image(systemName: "multiply")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
            )
            .foregroundColor(.red)
    }
}

struct VerifiedView_Previews: PreviewProvider {
    static var previews: some View {
        VerifiedView(cardNumber: "5534567890123456").previewLayout(.sizeThatFits)
    }
}
