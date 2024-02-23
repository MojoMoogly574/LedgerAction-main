//
//  TransactionsListView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 2/19/24.
//

import SwiftUI
import SwiftData

struct TransactionsListView: View {
    //MARK:  PROPERTIES
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    /// View Properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var showFilterView: Bool = false
    @State private var addTransaction: Bool = false
    @State private var selectedCategory: Category = .expense
    @State private var selectedTransaction: Transaction?
    /// For Animation
    @Namespace private var animation
//    @Query(sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)], animation: .snappy) private var transactions: [Transaction]
    var body: some View {
        GeometryReader{
            let size = $0.size
            NavigationStack{
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        //MARK: BODY
                        Section {
                            /// DATE RANGE FILTER BUTTON
                                Button {
                                    showFilterView = true
                                    HapticManager.notification(type: .success)
                                } label: {
                                    Text("Select Range:   \(format(date: startDate,format: "dd MMM yy"))   -   \(format(date: endDate,format: "dd MMM yy"))")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.colorBlue)
                            }
                                .hSpacing(.leading)
                                .padding(5)
                            .background {///date range button rectangle
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.colorTitanium)
                                    .shadow(color: .colorTitanium, radius: 4, x: 2, y: 2)
                            }
                            
                            FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                                /// HEADER CARD VIEW
                                CardView(income: 2039, expense: 1764)
                                ///  CATEGORY SEGMENTED PICKER
                                Picker("", selection: $selectedCategory) {
                                    ForEach(Category.allCases, id: \.rawValue) { category in
                                        Text("\(category.rawValue)")
                                            .tag(category)
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                            .pickerStyle(.segmented)
                            
                            FilterTransactionsView(startDate: startDate, endDate: endDate, category: selectedCategory) { transactions in
                                ForEach(transactions) { transaction in
                                    TransactionCardView(transaction: transaction)
                                        .onTapGesture {
                                            selectedTransaction = transaction
                                        }
                                }
                            }
                            .animation(.none, value: selectedCategory)
                        } header: {
                            //MARK:  HEADER VIEW
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 5, content: {
                                    Text("Welcome!")
                                        .font(.title.bold())
                                    
                                    if !userName.isEmpty {
                                        Text(userName)
                                            .font(.callout)
                                            .foregroundStyle(.gray)
                                    }
                                })
                                .visualEffect { content, geometryProxy in
                                    content
                                        .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
                                }
                                Spacer(minLength: 0)
                                Button {
                                   addTransaction = true
                                    HapticManager.notification(type: .success)
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .frame(width: 45, height: 45)
                                        .background(appTint.gradient, in: .circle)
                                        .contentShape(.circle)
                                }
                                .sheet(isPresented: $addTransaction) {
                                    AddTransactionView()
                                        .presentationDetents([.large])
                                }
                            }
                            .padding(.bottom, userName.isEmpty ? 10 : 5)
                        }
                        .ignoresSafeArea()
                        .padding(.horizontal)
                        .background {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.clear)
                            }
                            .visualEffect { content, geometryProxy in
                                content
                                    .opacity(headerBGOpacity(geometryProxy))
                            }
                            .padding(.top, -(safeArea.top + 15))
                        }
                    }
                }
                .blur(radius:showFilterView ? 8 : 0)
                .disabled(showFilterView)
                .navigationDestination(item: $selectedTransaction) { transaction in
                    EditTransactionView(editTransaction: transaction)
                }
            }
            .overlay {
                    if showFilterView {
                        DateFilterView(start: startDate, end: endDate, onSubmit: {start, end in
                            startDate = start
                            endDate = end
                            showFilterView = false
                        }, onClose: {
                            showFilterView = false
                        })
                        .transition(.move(edge: .leading))
                    }
                }
                .animation(.snappy, value: showFilterView)
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
    TransactionsListView()
}
