//
//  Cards.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//

import Foundation

// MARK: - DTOs

struct ResultDTO<T: Codable>: Codable {
    let results: [T]
}

struct CardDTO: Codable {
    let name: String
    let design_type: DesignType
    let cards: [CardDetailDTO]
    var is_scrollable: Bool = false
}

struct CardDetailDTO : Codable {
    let bg_color: String?
//    let formatted_title: FormattedTitle
//    let cta : [CtaDTO]
}

struct FormattedTitle : Codable {
    let text: String
    let entities: [Entity]?
}

struct Entity : Codable {
    let text: String
    let type: String
    let collor: String
}

struct CtaDTO : Codable {
    let text: String
    let bg_color: String
    let text_color: String
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
