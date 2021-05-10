//
//  UserSettings.swift
//  Cards
//
//  Created by Linda Zungu on 2021/05/09.
//

import Foundation
import Combine

class UserSettings: ObservableObject{
    @Published var sortByAscension: Bool{
        didSet{
            UserDefaults.standard.set(sortByAscension, forKey: "sortByAscension")
        }
    }
    
    @Published var changeContentView : Bool{
        didSet{
            UserDefaults.standard.set(changeContentView, forKey: "changeContentView")
        }
    }
    
    init() {
        self.sortByAscension = UserDefaults.standard.bool(forKey: "sortByAscension")
        self.changeContentView = UserDefaults.standard.bool(forKey: "changeContentView")
    }
}
