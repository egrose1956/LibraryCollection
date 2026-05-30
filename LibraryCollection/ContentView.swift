//
//  ContentView.swift
//  LibraryUsingSwiftData
//
//  Created by Elizabeth Rose on 8/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var createNewAuthor: Bool = false
    @State var returning: Bool = false
    
    enum FilterOptions {
        case worksTitles, authors, narrators, unknown, aboutView
    }
    @State var filter: FilterOptions = .authors
    
    var body: some View {
        
        if !returning {
            VStack(alignment: .center) {
                Text("LibraryCollection")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        NavigationStack() {
            VStack {
                switch filter {
                case .authors:
                    AuthorsListView()
                case .worksTitles:
                    TitlesView()
                case .narrators:
                    NarratorListView()
                case .aboutView:
                    AboutView()
                default:
                    AuthorsListView()
                }
                Section {
                    Image("oldbigbookshelf")
                        .resizable()
                        .scaledToFit()
                        .accessibilityLabel("Picture of a colorful fantasy bookshelf.")
                        .background(.tertiary)
                        .padding(.bottom, 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Viewing Options", systemImage: "text.justify") {
                        Button("View Titles") { filter = .worksTitles }
                        Button("View Authors") { filter = .authors }
                        Button("View Narrators") { filter = .narrators }
                        Button("About This App") { filter = .aboutView }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Author Actions", systemImage: "pencil") {
                        NavigationLink("Create New Author", destination: AuthorView())
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Image("magnifyingglass")
                            .resizable()
                            .scaledToFit()
                        NavigationLink("Search", destination: Search())
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .safeAreaPadding()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
