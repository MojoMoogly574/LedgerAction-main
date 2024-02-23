//
//  EditTransactionView.swift
//  LedgerAction
//
//  Created by J. DeWeese on 2/21/24.
//

import SwiftUI
import SwiftData
import UserNotifications
import PhotosUI

struct EditTransactionView: View {
    /// Env Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction: Transaction?
    /// Notification Properties
    @AppStorage("enableNotifications") private var enableNotifications: Bool = false
    @AppStorage("notificationAccess") private var isNotificationAccessGiven: NotificationState = .notDetermined
    @State private var addReminder: Bool = false
    @State private var reminderID: String = ""
    /// View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expense
    /// Random Tint
    @State var tint: TintColor = tints.randomElement()!
    ///Receipts
    @State private var selectedReceipt: PhotosPickerItem?
    @State private var selectedReceiptData: Data?
    
    var body: some View {
        
        NavigationStack{
            
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10) {
                        CustomSection("Title", "Bass Pro", value: $title)
                        CustomSection("Remarks", "Sig P229 Legion", value: $remarks)
                        /// Amount & Category Check Box
                        VStack(spacing: 5){
                            Text("Transaction Type")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.colorGrey)
                                .hSpacing(.leading)
                            CategoryCheckBox()
                            Text("Transaction Amount")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.colorGrey)
                                .hSpacing(.leading)
                                .padding(.top, 5)
                            HStack(spacing: 2) {
                                Text(currencySymbol)
                                    .font(.callout.bold())
                                TextField("", value: $amount, formatter: numberFormatter)
                                    .frame(width: 350)
                                    .padding(8)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        Divider()
                        /// Notification View
                        if enableNotifications && isNotificationAccessGiven == .approved {
                            NotificationToggle()
                        }
                        /// Date Picker
                        VStack(alignment: .leading, spacing: 10, content: {
                            Text("Date")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.colorGrey)
                                .hSpacing(.leading)
                            DatePicker("", selection: $dateAdded, displayedComponents: addReminder ? [.date, .hourAndMinute] : [.date])
                                .datePickerStyle(.graphical)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 10))
                        })
                        //Receipts
                        Text("Receipts:  ")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.colorGrey)
                            .hSpacing(.leading)
                        PhotosPicker(
                            selection: $selectedReceipt,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Group {
                                    if let selectedReceiptData,
                                       let uiImage = UIImage(data: selectedReceiptData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .tint(.colorTitanium)
                                    }
                                }
                                .frame(width: 100, height: 200)
                                .overlay(alignment: .topTrailing) {
                                    if selectedReceiptData != nil {
                                        Button {
                                            selectedReceipt = nil
                                            selectedReceiptData = nil
                                        } label: {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                            }
                    }
                }
                .ignoresSafeArea()
                .padding()
                .background(.gray.opacity(0.15))
                .navigationTitle("Edit Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            HapticManager.notification(type: .success)
                            save()
                        }label: {
                            Text("Save")
                        }
                        .buttonStyle(.bordered)
                        .fontWeight(.bold)
                        .foregroundStyle(appTint)
                        .tint(.colorTitanium)
                    }
                })
            
        }
        .onAppear {
            if let editTransaction {
                /// Load All Existing Data from the Transaction
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
                selectedReceiptData = editTransaction.receipt
                addReminder = editTransaction.enableReminder
                reminderID = editTransaction.reminderID
            }
        }
        .task(id: selectedReceipt) {
            if let data = try? await selectedReceipt?.loadTransferable(type: Data.self) {
                selectedReceiptData = data
            }
        }
    }
        /// Saving Data
        func save() {
            Task {
                ///reminder⬇️
                if addReminder {
                    /// Removing Previously Added Reminder
                    if !reminderID.isEmpty {
                        removeReminder()
                    }
                    /// Adding New Notification Reminder
                    let request = setUpReminder()
                    if let _ = try? await UNUserNotificationCenter.current().add(request.0) {
                        reminderID = request.1
                    }
                } else {
                    /// Removing Added Notification Reminder
                    removeReminder()
                }
                ///main properties ⬇️
                await MainActor.run {
                    /// Saving Item to SwiftData
                    if editTransaction != nil {
                        editTransaction?.title = title
                        editTransaction?.remarks = remarks
                        editTransaction?.amount = amount
                        editTransaction?.category = category.rawValue
                        editTransaction?.dateAdded = dateAdded
                        editTransaction?.enableReminder = addReminder
                        editTransaction?.reminderID = reminderID
                        editTransaction?.receipt = selectedReceiptData
                    } else {
                        let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
                        transaction.enableReminder = addReminder
                        transaction.reminderID = reminderID
                        transaction.receipt = selectedReceiptData
                        
                        context.insert(transaction)
                     
                    }
                    /// Dismissing View
                    dismiss()
                    /// Updating Widgets
                    //              WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        @ViewBuilder
        func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
            VStack(alignment: .leading, spacing: 5, content: {
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.colorGrey)
                    .hSpacing(.leading)
                TextField(hint, text: value)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(.background, in: .rect(cornerRadius: 10))
            })
        }
        /// Custom CheckBox
        @ViewBuilder
        func CategoryCheckBox() -> some View {
            HStack(spacing: 10) {
                ForEach(Category.allCases, id: \.rawValue) { category in
                    HStack(spacing: 5) {
                        ZStack {
                            Image(systemName: "circle")
                                .font(.title)
                                .foregroundStyle(appTint)
                            if self.category == category {
                                Image(systemName: "circle.fill")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(appTint)
                            }
                        }
                        Text(category.rawValue)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.colorGrey)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        self.category = category
                    }
                }
            }
        }
        /// Notification Toggle
        @ViewBuilder
        func NotificationToggle() -> some View {
            VStack(alignment: .leading, spacing: 10, content: {
                Text("Reminder")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                Toggle("Enable Monthly Reminder", isOn: $addReminder)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 10))
                    .onChange(of: addReminder) { oldValue, newValue in
                    }
            })
        }
        /// Reminder Notification
        func setUpReminder() -> (UNNotificationRequest, String) {
            /// Notification Content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.subtitle = remarks
            /// Notification Identifier
            let notificationID = UUID().uuidString
            /// Notification Trigger
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.day, .hour, .minute], from: dateAdded)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            /// Notification Request
            let notificationRequest = UNNotificationRequest(identifier: notificationID, content: notificationContent, trigger: trigger)
            return (notificationRequest, notificationID)
        }
        /// Removes Added Remainder Notification
        func removeReminder() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderID])
            reminderID = ""
        }
        /// Number Formatter
        var numberFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            return formatter
        }
    }

#Preview {
    TabBarView()
}
