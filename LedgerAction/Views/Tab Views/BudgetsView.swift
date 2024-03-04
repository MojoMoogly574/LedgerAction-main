//
//  BudgetsView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/3/24.
//

import SwiftUI
import SwiftData

struct BudgetsView: View {
    //MARK:  PROPERTIES
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            NavigationStack{
                ZStack{
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                            Section {
                                
                                
                                
                                
                            } header: {
                                HStack(spacing: 10) {
                                    VStack(alignment: .center, spacing: 5){
                                        Text("Welcome!")
                                            .font(.title.bold())
                                        if !userName.isEmpty {
                                            Text(userName)
                                                .font(.callout)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                .visualEffect { content, geometryProxy in
                                    content
                                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .center)
                                }
                                .ignoresSafeArea()
                                .background {
                                    VStack(spacing: 0) {
                                        Rectangle()
                                            .fill(.clear)
                                    }
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .opacity(headerBGOpacity(geometryProxy))
                                    }
                                }
                            }
                            .padding(.top, -(safeArea.top + 15))
                            
                        }
                    }
                }
            }
        }
    }
    //MARK:  FUNCTIONS
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.6
        
        return 1 + scale
    }
}
#Preview {
    BudgetsView()
}
