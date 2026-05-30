//
//  TitlesView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 1/20/24.
//

import SwiftUI
import CoreData

struct TitlesView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var titles: FetchedResults<Title>
    
    @State var authorIdString: String = ""
    
    @State var resultString: String = ""
    @State var titleIdString: String = ""
    @State var title: String = ""
       
    var body: some View {
        NavigationStack {
            Group {
                if titles.isEmpty {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView {
                            Image(systemName: "books.vertical")
                                .font(.largeTitle)
                        } description: {
                            Text("No Books Available. Add an Author or add a new title to a current author.")
                        } actions: {
                            NavigationLink("Return to Main Screen") {
                                ContentView(returning: true)
                            }
                        }
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "books.vertical")
                                .font(.largeTitle)
                            Text("No Books Available. Add an Author or add a new title to a current author.")
                            NavigationLink("Return to Main Screen") {
                                ContentView(returning: true)
                            }
                        }
                    }
                } else {
                    Text("Titles")
                        .font(.title3)
                        .fontWeight(.bold)                    
                    List {
                        ForEach (titles) { selectedItem in
                            NavigationLink {
                                TitleDetailsView(authorIdString: authorIdString,
                                                 titleIdString: selectedItem.titleId.uuidString,
                                                 newRecord: false)
                            } label: {
                                Text(selectedItem.title.isEmpty ? "" : selectedItem.title)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(Color.accentColor)
        }
    }
}


