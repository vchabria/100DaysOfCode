//
//  Item.swift
//  RockPaperScissor
//
//  Created by Varnika Chabria on 3/11/24.
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
