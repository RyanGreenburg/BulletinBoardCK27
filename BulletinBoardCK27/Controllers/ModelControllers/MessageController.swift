//
//  MessageController.swift
//  BulletinBoardCK27
//
//  Created by RYAN GREENBURG on 7/8/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    // Shared instance
    static let shared = MessageController()
    
    let messagesWereUpdatedNotification = Notification.Name("messagesWereUpdated")
    
    // Source of Truth
    var messages: [Message] = [] {
        didSet {
            // Post a notification
            NotificationCenter.default.post(name: messagesWereUpdatedNotification, object: nil)
        }
    }
    
    // MARK: - CRUD
    // Create
    func saveMessageRecord(_ text: String) {
        // init a message
        let messageToSave = Message(text: text)
        let record = CKRecord(message: messageToSave)
        // set database
        let database = CloudKitController.shared.publicDatabase
        
        CloudKitController.shared.saveRecordToCloudKit(record: record, database: database) { (success) in
            if success {
                print("WE DID IT")
                self.messages.append(messageToSave)
            }
        }
    }
    
    // Read
    func fetchMessageRecords() {
        
        let database = CloudKitController.shared.publicDatabase
        CloudKitController.shared.fetchRecordsOf(type: MessageConstants.typeKey, database: database) { (records, error) in
            
            // Handle error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
            }
            
            // verify records exist
            guard let foundRecords = records else { return }
            
            // Iterates through foundRecords, init Messages from the values that can init a Message, creating a new array from successes
            let messages = foundRecords.compactMap( {Message(record: $0)} )
            
            // Set source of truth
            self.messages = messages
        }
    }
    
    func delete(_ message: Message) {
        let db = CloudKitController.shared.publicDatabase
        let recordID = message.recordID
        
        CloudKitController.shared.delete(recordID: recordID, database: db) { (success) in
            if success {
                guard let index = self.messages.firstIndex(of: message) else { return }
                self.messages.remove(at: index)
            }
        }
    }
}
