//
//  Logger.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//

import SwiftUI
import os

struct appLogger {
    
    let logger = Logger(subsystem: "com.riverthree.LibraryCollection", category: "general")

    func log(level: OSLogType, message: OSLogMessage.StringLiteralType) {
        logger.log(level: level, "\(message)")
    }
}
