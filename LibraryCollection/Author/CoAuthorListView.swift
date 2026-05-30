//
//  CoAuthorListView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/16/23.
//

import SwiftUI
import CoreData

struct CoAuthorListView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var titleIdString: String
    @State var titleName: String
    @State var authorFirstName:String = ""
    @State var authorMiddleName: String = ""
    @State var authorLastName: String = ""
    @State var authorIdString:String = ""
    @State var resultString: [String] = []
    
    enum Field {
        case authorFirstName
        case authorMiddleName
        case authorLastName
    }
    @FocusState private var focusedField: Field?
    
    @State var nameFormatter = NameFormatter()
    @State var lastNameAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("Authors(s) for: \(titleName)")
                    .foregroundStyle(Color.accentColor)
                    .accessibilityLabel("Authors for: \(titleName)")
                    .padding(.leading)
                    .disabled(true)
                List {
                    ForEach(resultString, id: \.self) { selectedItem in
                        Text("\(selectedItem)")
                            .accessibilityLabel("\(selectedItem)")
                            .onTapGesture {
                                authorLastName = ""
                                authorFirstName = ""
                                authorMiddleName = ""
                                if !selectedItem.isEmpty {
                                    if selectedItem.contains(", ") {
                                        authorLastName = selectedItem.components(separatedBy: ", ")[0]
                                        let firstAndMiddle = selectedItem.components(separatedBy: ", ")[1]
                                        if firstAndMiddle.components(separatedBy: " ").count > 1 {
                                            authorFirstName = firstAndMiddle.components(separatedBy: " ")[0]
                                            authorMiddleName = firstAndMiddle.components(separatedBy: " ")[1]
                                        } else {
                                            authorFirstName = firstAndMiddle
                                        }
                                    } else {
                                        authorLastName = selectedItem
                                    }
                                }
                            }
                            .accessibilityValue("\(selectedItem)")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                
                Text("Adding a Co-Author for \(titleName)")
                    .padding(5)
                    .foregroundStyle(Color.accentColor)
                    .accessibilityLabel("Ready to add")
                    .padding(.leading)
                    .disabled(true)
            }
            .onAppear {
                focusedField = .authorFirstName
                GetAllAuthorsByTitleId()
                moc.refreshAllObjects()
            }
                
            AuthorView(titleIdString: titleIdString, addingCoAuthor: true)
                            
        } //NavStack
        .navigationBarTitleDisplayMode(.inline)
        .autocorrectionDisabled(true)
        .safeAreaPadding()
    }
}

