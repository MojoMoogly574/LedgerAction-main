//
//  SearchView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 3/3/24.
//

import SwiftUI
import Combine

struct SearchView: View {
    /// View Properties
    @State private var addBudget: Bool = false
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedTransaction: Transaction?
    let searchPublisher = PassthroughSubject<String, Never>()
    @Namespace private var animation
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                    Section {
                        FilterTransactionsView(category: selectedCategory, searchText: filterText) { transactions in
                            ForEach(transactions) { transaction in
                                TransactionCardView(transaction: transaction, showsCategory: true)
                                    .onTapGesture {
                                        selectedTransaction = transaction
                                    }
                            }
                        }
                    } header: {
                            //MARK:  HEADER VIEW
                            HStack{
                                DrawerCloseButton(animation: animation)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(width: 45, height: 45)
                                    .background(appTint.gradient, in: .circle)
                                    .contentShape(.circle)
                                    .padding()
                                    .offset(x: -25)
                                Spacer()
                    
                                Button {
                                    addBudget = true
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
                                .sheet(isPresented: $addBudget) {
                                    AddTransactionView()
                                        .presentationDetents([.large])
                                }
                            }
                            .padding(.horizontal, 2)
                        
                        }
                        Picker("", selection: $selectedCategory) {
                                        if selectedCategory == nil {
                                            ForEach(Category.allCases, id: \.rawValue) { category in
                                                Text("\(category.rawValue)")
                                                    .tag(category)
                                            }
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                Divider()
                            }
                        }
                        .padding([.horizontal, .bottom], 15)
                    }
                    .navigationDestination(item: $selectedTransaction) { transaction in
                        EditTransactionView(editTransaction: transaction)
                    }
                    .overlay(content: {
                        ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                            .opacity(filterText.isEmpty ? 1 : 0)
                    })
                    .onChange(of: searchText, { oldValue, newValue in
                        if newValue.isEmpty {
                            filterText = ""
                        }
                        searchPublisher.send(newValue)
                    })
                    .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                        filterText = text
                    })
                    .searchable(text: $searchText)
                    .background(.gray.opacity(0.15))
                }
            }
    

#Preview {
   ContentView()
}
