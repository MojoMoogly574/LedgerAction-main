//
//  MenuModel.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/3/24.
//

import SwiftUI

// Menu Data...

class MenuViewModel: ObservableObject{
    
    //Default...
    @Published var selectedMenu = "Catalogue"
    
    // Show...
    @Published var showDrawer = false
}

