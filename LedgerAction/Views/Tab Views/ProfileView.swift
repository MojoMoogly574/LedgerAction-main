//
//  ProfileView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/2/24.
//

import SwiftUI

struct ProfileView: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        NavigationStack {
            ScrollView{
                Text("")
                    .navigationTitle("Profile View")
            }
        }
    }
}
#Preview {
    ProfileView()
}
