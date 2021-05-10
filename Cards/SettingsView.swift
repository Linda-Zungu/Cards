//
//  SettingsView.swift
//  Cards
//
//  Created by Linda Zungu on 2021/04/27.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var sharedSettings : SharedSettings
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        VStack{
            if(sharedSettings.isUnlocked){
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
            else{
                VStack{
                    Text("CARDS")
                        .tracking(10)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 40)

                    Image(systemName: "lock.fill")
                        .padding(.bottom, 50)
                        .font(.system(size: 30))

                    LockScreenCardsView()

                    Spacer()

                    Button(action: {
                        sharedSettings.authenticate()
                    }, label: {
                        VStack{
                            Text("Use Biometric")
                                .foregroundColor(.primary)
                                .font(.subheadline)
                                .kerning(2)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                        .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(Color.primary.opacity(0.3))
                                )
                        }
                    })
                    .padding(30)
                }
                .onAppear{
                    sharedSettings.authenticate()
                }
            }
            
        }
        .navigationTitle("Settings")
        .onChange(of: scenePhase, perform: { value in
            if(value == .background){
                sharedSettings.isUnlocked = false
            }
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .colorScheme(.dark)
    }
}
