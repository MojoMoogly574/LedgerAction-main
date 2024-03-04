//
//  SideMenuView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/3/24.
//

import SwiftUI


struct SideMenuView: View {
    
    // Hiding tab Bar...
    @StateObject var menuData = MenuViewModel()
    
    @Namespace var animation
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        HStack(spacing: 0){
            // Drawer And Main View...
            
            // Drawer...
            Drawer(animation: animation)
            
            // Main View...
            
            TabView(selection: $menuData.selectedMenu){
                
                TransactionsListView()
                    .tag("Transactions")

                ProfileView()
                    .tag("Profile")
                
                DashboardView()
                    .tag("Dashboard")
                
                SearchView()
                    .tag("Search")
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        // Max Frame...
        .frame(width: UIScreen.main.bounds.width)
        // Moving View....
        // 250/2 => 125....
        .offset(x: menuData.showDrawer ? 125 : -125)
//        .overlay(
//                ZStack{
//                   if !menuData.showDrawer{
//                        DrawerCloseButton(animation: animation)
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.white)
//                            .frame(width: 45, height: 45)
//                            .background(appTint.gradient, in: .circle)
//                            .contentShape(.circle)
//                            .padding()
//                            .offset(y: -12.0)
//                    }
//                },
//                alignment: .topLeading
//            )
        .environmentObject(menuData)
    }
}

#Preview {
    SideMenuView()
}
