//
//  SideMenuHeaderView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/2/24.
//

import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack {
            Image( systemName: "person.circle.fill")
                .resizable()
                .padding(7)
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(appTint)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack (alignment: .leading, spacing: 6)  {
                Text("Joseph W DeWeese")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text("carzyDev@icloud.com")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
