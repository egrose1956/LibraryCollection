//
//  Searc.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 2/21/23.
//

import SwiftUI
import CoreData

struct Search: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var searchString: String = ""
    @State var filteredTitles: [String] = []
    @State var resultString: [String] = []
    @State var authorIdString: String = ""
    @State var titleIdString: String = ""
    @State var selectedItem: String = ""
       
    @State var authorFirstName: String = ""
    @State var authorLastName: String = ""
    @State var authorName: String = ""
    @State var title: String = ""
    @State var titleDetails: [Title] = []
    
    enum FocusedField {
        case search
    }
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Search for Author or Title", text: $searchString)
                .focused($focusedField, equals: .search)
                .padding(10)
                .frame(width: 320, height: 40, alignment: .center)
                .font(.subheadline)
                .border(Color.accentColor, width: 2)
                .clipShape(Capsule())
                .accessibilityLabel("Search Entry")
                .autocorrectionDisabled(true)
                .submitLabel(.search)
                .onSubmit {
                    guard !searchString.isEmpty else { return }
                    SearchForUserCriteria()
                    //searchString = ""
                    hideKeyboard()
                }
        }
        NavigationStack {
            if resultString.isEmpty {
                Text("Nothing Found")
            } else {
                List {
                    Text("Results: ")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                    
                    ForEach(resultString, id: \.self) { selectedItem in
                        
                        if selectedItem.components(separatedBy: "*").count > 2 {
                            
                            NavigationLink(destination: TitleDetailsView(authorIdString: selectedItem.components(separatedBy: "*")[2],
                                                                         titleIdString: selectedItem.components(separatedBy: "*")[1],
                                                                         title: selectedItem.components(separatedBy: "*")[0],
                                                                         selectedItem: selectedItem)) {
                                
                                
                                Text("Title: \(selectedItem.components(separatedBy: "*")[0]) by author: \(selectedItem.components(separatedBy: "*")[3])")
                                    .accessibilityLabel("Search results for Title: \(selectedItem.components(separatedBy: "*")[0]) by author: \(selectedItem.components(separatedBy: "*")[3])")
                            }
                        } else {
                            
                            NavigationLink(destination: AuthorsWorksView(filteredTitles: filteredTitles, authorIdString: selectedItem.components(separatedBy: "*")[0])) {
                                Text("Author: \(selectedItem.components(separatedBy: "*")[1])")
                                    .accessibilityLabel("Author: \(selectedItem.components(separatedBy: "*")[1])")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            focusedField = .search
            searchString = ""
        }
        .navigationTitle("Search For:  ")
        .keyboardType(.default)
        .autocorrectionDisabled(true)
        //.safeAreaPadding()
    }
}


