//
//  CardListViewModel.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//

import Foundation
import Combine

final class CardsListViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    
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
        
        init(card: CardDTO) {
            print(card)
            id = card.name
            name = card.name
            design_type = card.design_type
            is_scrollable = card.is_scrollable
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
