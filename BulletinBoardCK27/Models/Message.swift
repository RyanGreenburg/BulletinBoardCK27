//
//  Message.swift
//  BulletinBoardCK27
//
//  Created by RYAN GREENBURG on 7/8/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

class Message {
    
    // Class properties
    let text: String
    let timestamp: Date
    let recordID: CKRecord.ID
    
    // Class initializer
    init(text: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
    }
    
    // Convenience init to pass in CKRecord
    convenience init?(record: CKRecord) {
        guard let text = record[MessageConstants.textKey] as? String,
            let timestamp = record[MessageConstants.timestampKey] as? Date
            else { return nil }
        
        self.init(text: text, timestamp: timestamp, recordID: record.recordID)
        
    }
}

// Extension on CKRecord
extension CKRecord {
    // Init a CKRecord object by passing in our Message object
    convenience init(message: Message) {
        // init type and set the recordID
        self.init(recordType: MessageConstants.typeKey, recordID: message.recordID)
        // Set Key value pairs
        self.setValue(message.text, forKey: MessageConstants.textKey)
        self.setValue(message.timestamp, forKey: MessageConstants.timestampKey)
    }
}
// STEP ONE TO DELETE 
extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

struct MessageConstants {
    // Keys for CloudKit Storage
    static let typeKey = "Message"
    fileprivate static let textKey = "Text"
    fileprivate static let timestampKey = "Timestamp"
}
