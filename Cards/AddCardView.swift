//
//  AddCardView.swift
//  Cards
//
//  Created by Linda Zungu on 3/4/21.
//

import SwiftUI

struct AddCardView: View {
    var body: some View {
        NavigationView{
            Text("Hello")
                .navigationTitle("Add Card")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView()
    }
}
