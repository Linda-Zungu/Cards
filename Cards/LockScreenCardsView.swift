//
//  LockScreenCardsView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/04/04.
//

import SwiftUI

struct LockScreenCardsView: View {
    @State private var wave = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        BlurView(style: .systemUltraThinMaterial)
            .cornerRadius(15, antialiased: true)
            .overlay(
                ZStack{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(colorScheme == .light ? Color.white.opacity(0.75) : Color.init(UIColor.secondarySystemFill), lineWidth: 1)
                    Text("Authenticate")
                        .tracking(2)
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
                
                
            )
            .frame(width: 150, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaleEffect(wave ? 2 : 0.5)
                    .opacity(wave ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    .scaleEffect()
                    .onAppear(){
                        self.wave.toggle()
                    }
            )
            .shadow(color: colorScheme == .light ? Color.gray.opacity(0.2) : Color.black, radius: 20, y: 20)
            .foregroundColor(.red)
    }
}

struct LockScreenCardsView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenCardsView()
    }
}
