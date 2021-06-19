//
//  CardListViewModel.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class CardsListViewModel: ObservableObject {
    // State of the CardViewModel which can be changed via Events like input or loading data.
    @Published private(set) var state = State.idle
    
    // Store the publishers in a set to persist the publishers.
    private var bag = Set<AnyCancellable>()
    
    // Pass through subject which emits whatever the value it recives.
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    // Deallocate the stored publishers to prevent memory leaks.
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension CardsListViewModel {
    
    enum State {
        case idle
        case loading
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onCardsLoaded([ListItem])
        case onFailedToLoadCards(Error)
    }
    
    struct ListItem: Identifiable {
        let id: String
        let name: String
        let design_type: DesignType
        let is_scrollable: Bool
        let bg_color: UIColor
        
        // Calculate the properties from recieved data.
        // Sample properties for one Card.
        // This is important for MVVM architecture.
        // Separates the PresentationLogic from MainView.
        // Making the code more testable and easy to change the UI as per new requirements.
        let text_color : Color = Color.init(UIColor(red: 0.984, green: 0.686, blue: 0.012, alpha: 1))
        let text_font : Font = Font.custom("Roboto-Medium", size: 30)
        let text_padding : EdgeInsets = EdgeInsets.init(top: 0, leading: 66, bottom: 0, trailing: 0)
        
        init(card: CardDTO) {
            print(card)
            id = card.name
            name = card.name
            design_type = card.design_type
            is_scrollable = card.is_scrollable
            
            
            // calculate these variables for individual card types so it can be used in the view.
            bg_color = hexStringToUIColor(hex: card.cards[0].bg_color ?? "#FFFFFF")
        }
    }
}

// MARK: - State Machine

extension CardsListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadCards(let error):
                return .error(error)
            case .onCardsLoaded(let cards):
                return .loaded(cards)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return CardsAPI.get()
                .map { $0.results.map(ListItem.init) }
                .map(Event.onCardsLoaded)
                .catch { Just(Event.onFailedToLoadCards($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
