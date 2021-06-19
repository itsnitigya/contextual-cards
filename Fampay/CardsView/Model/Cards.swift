//
//  Cards.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//

import Foundation

// MARK: - DTOs

struct CardDTO: Codable {
    let name: String
    let design_type: DesignType
    var is_scrollable: Bool = false
}


struct ResultDTO<T: Codable>: Codable {
    let results: [T]
}

public enum DesignType: String, Codable, Hashable {
    // Small display card.
    case HC1
    // Big display card.
    case HC3
    // Center card.
    case HC4
    /// Only image card.
    case HC5
    // Small card with arrow.
    case HC6
}
