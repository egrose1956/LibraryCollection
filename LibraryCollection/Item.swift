//
//  Item.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 5/30/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
