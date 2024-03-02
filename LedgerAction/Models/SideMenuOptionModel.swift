//
//  SideMenuOptionModel.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/1/24.
//

import Foundation


enum SideMenuRowType: Int, CaseIterable {
    
    case profile = 0
    case dashboard
    case transactions
    case budget
    case settings
   
    var title: String {
        switch self {
        case .profile:
            return "Profile"
        case .dashboard:
            return "Dashboards"
        case .transactions:
            return "Transactions"
        case .budget:
            return "Budget"
        case .settings:
            return "Settings"
        }
    }
    var systemImageName:  String {
        switch self {
        case .profile:
            return "person"
        case .dashboard:
            return "chart.bar.doc.horizontal"
        case .transactions:
            return "creditcard.fill"
        case .budget:
            return "filemenu.and.cursorarrow"
        case .settings:
            return "gear"
       
        }
    }
}
extension SideMenuRowType: Identifiable {
    var id: Int { self.rawValue }
}
