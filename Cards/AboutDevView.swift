//
//  AboutDevView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/05/11.
//

import SwiftUI

struct AboutDevView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Hey, my name is Linda Zungu and I'm a Software Engineer/Developer studying at the University of Cape Town.\n\nThe programming languages I code in are:")
                    .padding()
                
                Group{
                    Text("Swift")
                    Text("Java")
                    Text("Python")
                    Text("HTML")
                    Text("CSS")
                    Text("JavaScript")
                    Text("SQL")
                    Text("Bash Scripting")
                }
                .padding(.horizontal,24)
                .padding(8)
                
                Divider()
                    .padding()
                
                Text("GitHub")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding()
                
                Text("https://github.com/Linda-Zungu")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
        }
            .navigationBarTitle("Developer", displayMode: .inline)
    }
}

struct AboutDevView_Previews: PreviewProvider {
    static var previews: some View {
        AboutDevView()
    }
}
