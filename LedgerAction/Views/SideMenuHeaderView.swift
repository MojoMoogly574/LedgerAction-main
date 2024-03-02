//
//  SideMenuHeaderView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/1/24.
//

import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack (alignment: .leading, spacing: 6)  {
                Text("Placeholder")
                    .font(.subheadline)
                
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
