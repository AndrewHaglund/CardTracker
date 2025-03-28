//
//  Item.swift
//  CardTracker
//
//  Created by Andrew Haglund on 3/28/25.
//

import Foundation
import SwiftData

@Model
final class Deck {
    var name: String
    var winCount: Int
    var lossCount: Int
    var order: Int
    var note: String
    
    init(name: String, order: Int) {
        self.name = name
        self.winCount = 0
        self.lossCount = 0
        self.order = order
        self.note = ""
    }
    
    var winLossRatio: Double {
        let total = Double(winCount + lossCount)
        guard total > 0 else { return 0 }
        return Double(winCount) / total
    }
}
