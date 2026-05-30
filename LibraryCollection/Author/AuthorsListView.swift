//
//  AuthorsListView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 1/29/24.
//

import SwiftUI
import CoreData

struct AuthorsListView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.authorLastName)
        ]
    ) var authors: FetchedResults<Author>
    
    @State var authorIdString: String = ""
    
    @State var authorsTitleIdArray: [String] = []
    @State var narratorIdArray: [String] = []
    @State var authorTitles: [String] = []
    
    @State private var authorDeleteWarning: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if authors.isEmpty {
                    if #available(iOS 17.0, *) {
                        // On iOS, this branch runs in versions 17.0 and greater.
                        // On any other OS, this branch runs in any version of that OS.
                        ContentUnavailableView {
                            Image(systemName: "person.slash")
                                .font(.largeTitle)
                        } description: {
                            Text("Add New Author")
                        } actions: {
                            NavigationLink("Create Author") {
                                AuthorView()
                            }
                            //.buttonStyle(CustomButtonStyle())
                        }
                    } else {
                       // This branch runs in earlier iOS versions.
                        VStack(alignment: .center) {
                            Image(systemName: "person.slash")
                                .font(.largeTitle)
                            Text("Add New Author")
                            NavigationLink("Create Author") {
                                AuthorView()
                            }
                        }
                    }
                
                } else {
                    Text("Authors")
                        .font(.title3)
                        .fontWeight(.bold)
                    List {
                        ForEach (authors, id: \.authorId) { author in
                            NavigationLink {
                                
                                AuthorView(beginningAuthorLastName: author.authorLastName,
                                           beginningAuthorFirstName: author.wrappedAuthorFirstName,
                                           beginningAuthorMiddleName: author.wrappedAuthorMiddleName,
                                           authorIdString: author.authorId.uuidString, authorTitles: authorTitles)
                                .font(.subheadline)
                            } label: {
                                
                                let nameFormatter = NameFormatter()
                                let fullNameString = nameFormatter.ConcatenateNameFields(lastName: author.authorLastName,
                                                                                         firstName: author.authorFirstName,
                                                                                         middleName: author.authorMiddleName)
                                
                                Text(fullNameString)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.subheadline)
                                    .accessibilityValue("Author's name is \(fullNameString)")
                                
                            }
                        }  
                    }
                }
            }
            .foregroundColor(Color.accentColor)
        }
    }
}
