//
//  SideMenuRowView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/1/24.
//

import SwiftUI

struct SideMenuRowView: View {
    let option: SideMenuOptionalModel
    @Binding var selectedOption: SideMenuOptionalModel?
    
    private var isSelected: Bool {
        return selectedOption == option 
    }
    var body: some View {
        HStack {
            Image(systemName: option.systemImageName)
                .imageScale(.small)
            Text(option.title)
                .font(.subheadline)
            Spacer()
        }
        .padding(.leading)
        .foregroundStyle(isSelected ? .colorBlue : .primary)
        .frame(width: 216, height: 44)
        .background(isSelected ? .colorBlue.opacity(0.15) :  .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#Preview {
    SideMenuRowView(option: .dashboard, selectedOption: .constant(.dashboard))
}
