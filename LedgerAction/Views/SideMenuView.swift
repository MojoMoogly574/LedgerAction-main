//
//  SideMenuView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/1/24.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedOption: SideMenuOptionalModel?
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                TabView(selection: $selectedTab) {
                    ProfileView()
                        .tag(0)
                    Text("Dashboards")
                        .tag(1)
                    Text("Transactions")
                        .tag(2)
                    BudgetView()
                        .tag(3)
                    SettingsView()
                        .tag(4)
                }
                Rectangle()
                    .opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                HStack{
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView()
                        VStack{
                            ForEach(SideMenuOptionalModel.allCases) { option in
                                Button(action: {
                                    selectedOption = option
                                    HapticManager.notification(type: .success)
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption )
                                })
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                    Spacer()
                }
            }
        }
    }
}
#Preview {
    SideMenuView(isShowing: .constant(true))
}
