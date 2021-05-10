//
//  SettingsView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/04/27.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Toggles")){
                    Toggle.init(isOn: $userSettings.sortByAscension, label: {
                        Text("Sort By Ascending")
                    })
                    
                    Toggle.init(isOn: $userSettings.changeContentView, label: {
                        Text("Display Card Style")
                    })
                    
                }
                Section(header: Text("About")){
                    HStack{
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.gray)
                    }
                    
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        label: {
                            Text("The Developer")
                        })
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .colorScheme(.dark)
    }
}
