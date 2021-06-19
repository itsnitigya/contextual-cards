//
//  CardsListView.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//

import Combine
import SwiftUI

struct CardListView: View {
    @ObservedObject var viewModel: CardsListViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Fampay")
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let cards):
            return list(of: cards).eraseToAnyView()
        }
    }
    
    
    private func list(of cards: [CardsListViewModel.ListItem]) -> some View {
        return List {
            ForEach(cards) { card in
                switch ( card.is_scrollable, card.design_type) {
                case (false, .HC3) :
                    CardBigDisplayView(card: card).frame(width: UIScreen.main.bounds.width, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                case (false, .HC6) :
                    CardSmallArrowView(card: card).frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                case (false, .HC5) :
                    CardImageView(card: card).frame(width: UIScreen.main.bounds.width, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).listRowInsets(EdgeInsets())
                case (false, .HC4) :
                    CardCenterView(card: card).frame(width: UIScreen.main.bounds.width, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                case (false, .HC1) :
                    CardScrollView(card: card).frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                case (true, .HC1) :
                    CardWithoutScrollView(card: card).frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                default :
                    CardScrollView(card: card).frame(width: UIScreen.main.bounds.width, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
    
    struct CardWithoutScrollView : View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            if #available(iOS 14.0, *) {
                HStack() {
                    ZStack () {
                        Color.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                            .frame(maxWidth: UIScreen.main.bounds.width/2 - 20, maxHeight: .infinity)
                            .shadow(radius: 1)
                        
                        HStack(alignment : .center) {
                            
                            Image(uiImage: UIImage.init(named: "profile")!)
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 0))
                            
                            Text("Small card")
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(Font.custom("Roboto-Medium", size: 16))
                                .foregroundColor(Color.init(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 170, height: 16, alignment: .leading)
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                        }
                        .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: UIScreen.main.bounds.width/2 - 20, maxHeight: .infinity, alignment: .leading)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    
                    ZStack () {
                        Color.init(UIColor(red: 0.984, green: 0.686, blue: 0.012, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                            .frame(maxWidth: UIScreen.main.bounds.width/2 - 20, maxHeight: .infinity)
                            .shadow(radius: 1)
                        
                        HStack(alignment : .center, spacing: 10) {
                            
                            Image(uiImage: UIImage.init(named: "arya_dp")!)
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 0))
                            
                            VStack {
                                Text("Small card")
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.custom("Roboto-Medium", size: 12))
                                    .foregroundColor(Color.init(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                    .frame(width: 170, height: 12, alignment: .leading)
                                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                
                                Text("Arya Stark")                                   .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.custom("Roboto-Medium", size: 12))
                                    .foregroundColor(Color.init(UIColor(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.73)))
                                    .frame(width: 170, height: 12, alignment: .leading)
                                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            

                        }
                        .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: UIScreen.main.bounds.width/2 - 20, maxHeight: .infinity, alignment: .leading)
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                }
                
            } else {
            }
            
        }
        
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
    
    struct CardScrollView : View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            if #available(iOS 14.0, *) {
                
                ScrollView (.horizontal, showsIndicators: false) {
                     HStack {
                        ZStack () {
                            Color.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .shadow(radius: 1)
                            
                            HStack(alignment : .center) {
                                
                                Image(uiImage: UIImage.init(named: "profile")!)
                                    .resizable()
                                    .frame(width: 40.0, height: 40.0)
                                    .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 0))
                                
                                Text("Small card with arrow")
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.custom("Roboto-Medium", size: 16))
                                    .foregroundColor(Color.init(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                    .frame(width: 170, height: 16, alignment: .leading)
                                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                
                            }
                            .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                        
                        ZStack () {
                            Color.init(UIColor(red: 0.984, green: 0.686, blue: 0.012, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .shadow(radius: 1)
                            
                            HStack(alignment : .center, spacing: 10) {
                                
                                Image(uiImage: UIImage.init(named: "arya_dp")!)
                                    .resizable()
                                    .frame(width: 40.0, height: 40.0)
                                    .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 0))
                                
                                VStack {
                                    Text("Small display card")
                                        .lineLimit(1)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(Font.custom("Roboto-Medium", size: 12))
                                        .foregroundColor(Color.init(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                                        .frame(width: 170, height: 12, alignment: .leading)
                                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    
                                    Text("Arya Stark")                                   .lineLimit(1)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(Font.custom("Roboto-Medium", size: 12))
                                        .foregroundColor(Color.init(UIColor(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.73)))
                                        .frame(width: 170, height: 12, alignment: .leading)
                                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                                

                            }
                            .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                     }
                }.frame(height: 80)
                
               
                
            } else {
            }
            
        }
        
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
    
    struct CardCenterView : View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            if #available(iOS 14.0, *) {
                ZStack () {
                    Color.init(UIColor(red: 0.984, green: 0.686, blue: 0.012, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
                        
                        .shadow(radius: 10)
                    
                    VStack(alignment : .center) {
                        
                        Image(uiImage: UIImage.init(named: "arya_dp")!)
                            .resizable()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .alignmentGuide(.leading) { _ in CGFloat(33) }
                            .frame(width: 90.0, height: 90.0)
                            .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("Arya Stark")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Medium", size: 14))
                            .foregroundColor(Color.init(UIColor(red: 0.106, green: 0.106, blue: 0.118, alpha: 0.73)))
                            .frame(height: 20, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("Small display card")
                            //.alignmentGuide(.leading) { _ in CGFloat(33) }
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Regular", size: 16))
                            .foregroundColor(.black)
                            .frame(height: 30, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        HStack (spacing: 60) {
                            Text("Action 1")
                                .foregroundColor(Color.white)
                                .font(Font.custom("Roboto-Medium", size: 16))
                                .padding()
                                .frame(width: 150, height: 42, alignment:  .center)
                                .background(Color.black)
                                .cornerRadius(6)
                                .padding(.init(top: 0, leading: 5, bottom: 20, trailing: 5))
                            Text("Action 2")
                                .foregroundColor(Color.white)
                                .font(Font.custom("Roboto-Medium", size: 16))
                                .padding()
                                .frame(width: 150, height: 42, alignment:  .center)
                                .background(Color.black)
                                .cornerRadius(6)
                                .padding(.init(top: 0, leading: -55, bottom: 20, trailing: 0))
                        }
                        //poster
                    }.padding(.init(top: 5, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity, alignment: .center)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                //
            } else {
                // Fallback on earlier versions
            }
            
        }
        
    
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
    
    struct CardImageView: View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            Image(uiImage: UIImage.init(named: "s1 copy")!)
                .resizable()
                .cornerRadius(12).padding(.init(top: 15, leading: 20, bottom: 20, trailing: 15))
                .frame(maxWidth: UIScreen.main.bounds.width - 10, maxHeight: .infinity, alignment: .center)
                .shadow(radius: 10)
        }
        
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
    
    struct CardBigDisplayView : View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            if #available(iOS 14.0, *) {
                ZStack () {
                    Color.init(UIColor(red: 0.27, green: 0.292, blue: 0.652, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
                        .shadow(radius: 10)
                    
                    VStack(alignment : .leading) {
                        
                        Image(uiImage: UIImage.init(named: "Asset 15")!)
                            .resizable()
                            .alignmentGuide(.leading) { _ in CGFloat(33) }
                            .frame(width: 93.0, height: 82.0)
                        
                        Text("Big display card")
                            .alignmentGuide(.leading) { _ in CGFloat(33) }
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Medium", size: 30))
                            .foregroundColor(Color.init(UIColor(red: 0.984, green: 0.686, blue: 0.012, alpha: 1)))
                            .frame(height: 30, alignment: .leading)
                            .padding(.init(top: 0, leading: 66, bottom: 0, trailing: 0))
                        
                        Text("with action")
                            .alignmentGuide(.leading) { _ in CGFloat(33) }
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Medium", size: 30))
                            .foregroundColor(.white)
                            .frame(height: 30, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("This is a sample text for the subtitle that you\ncan add to contextual cards")
                            .alignmentGuide(.leading) { _ in CGFloat(33) }
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.white)
                            .frame(height: 30, alignment: .leading)
                            .padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                        
                        Text("Action")
                            .foregroundColor(Color.white)
                            .font(Font.custom("Roboto-Medium", size: 16))
                            .padding()
                            .frame(width: 128, height: 42, alignment:  .center)
                            .background(Color.black)
                            .cornerRadius(6)
                            .padding(.init(top: 10, leading: -33, bottom: 0, trailing: 0))
                        
                        //poster
                    }
                    .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity, alignment: .leading)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                //
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
    
    struct CardSmallArrowView : View {
        let card: CardsListViewModel.ListItem
        @Environment(\.imageCache) var cache: ImageCache
        
        var body: some View {
            
            if #available(iOS 14.0, *) {
                ZStack () {
                    Color.init(UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor).cornerRadius(12).padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20))
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
                        .shadow(radius: 1)
                    
                    HStack(alignment : .center) {
                        
                        Image(uiImage: UIImage.init(named: "profile")!)
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 0))
                        
                        Text("Small card with arrow")
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Roboto-Medium", size: 16))
                            .foregroundColor(Color.init(UIColor(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 170, height: 16, alignment: .leading)
                            .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 0))
                        
                        Image(uiImage: UIImage.init(systemName: "chevron.forward")!)
                            .resizable()
                            .frame(width: 12.0, height: 16.0)
                            .padding(.init(top: 0, leading: 40, bottom: 0, trailing: 0))
                        
 
                    }
                    .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 20)).frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity, alignment: .leading)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            } else {
            }
            
        }
        
        private var spinner: some View {
            Spinner(isAnimating: true, style: .medium)
        }
    }
}

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}
