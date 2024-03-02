//
//  SideMenuView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/2/24.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
  
    
    var body: some View {
        ZStack{
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { isShowing.toggle() }
                
                HStack{
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView()
                        Spacer()
                    }
                    .padding(.horizontal, 7)
                    .frame(width: 275, alignment: .leading)
                    .background(.colorBackground)
                    Spacer()
                }
            }
        }
        }
    }
#Preview {
    SideMenuView(isShowing: .constant(true))
}
