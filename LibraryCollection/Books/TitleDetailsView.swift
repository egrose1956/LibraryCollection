//
//  TitleDetailsView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/9/24.
//

import SwiftUI
import CoreData
import os

struct TitleDetailsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var authorIdString: String
    @State var titleIdString: String = ""
    @State var title: String = ""
    @State var titleDetails: [TitleDetails] = []
    @State var titleDetailsId: String = ""
    @State var narratorListForTitle: [String] = []
    
    //holds the loaded data to compare to the current
    //data at save time to identify any changes
    @State var beginningTitle: String = ""
    @State var beginningSelectedType: String = ""
    @State var beginningEditionNumber: String = ""
    @State var beginningGenre: String = ""
    @State var beginningISBN: String = ""
    @State var beginningPublishingDate: String = ""
    @State var beginningPublishingHouse: String = ""
    @State var formHasChanges: Bool = false
    
    //to populate the picker
    @State var bookTypes: [String] = ["Hardback", "Paperback", "Audio", "eBook"]
    
    //to hold bound data
    @State var selectedType: String = ""
    @State var editionNumber: String = ""
    @State var genre: String = ""
    @State var ISBN: String = ""
    @State var publishingDate: String = ""
    @State var publishingHouse: String = ""
    @State var additionalAuthors: [String] = []
    
    enum Field: String, CaseIterable, Identifiable, Hashable {
            case picker, title, selectedType, editionNumber, genre, ISBN, publishingDate, publishingHouse
            var id: Self { self }
        }
    @FocusState private var focusedField: Field?
    
    @State var titleHasChanged: Bool = false
    @State var newRecord: Bool = false
    
    //coming from the search results
    @State var selectedItem: String = ""
    
    //coming from NewAuthorView
    @State var authorLastName: String = ""
    @State var authorFirstName: String = ""
    @State var authorMiddleName:  String = ""
    
    //coming from NarratorsWorksView
    @State var narratorIdString: String = ""
    
    @State var saveComplete: Bool = false
    @State var unsavedWarning: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Form {
                    
                    Text("Book Type: (select an option) ")
                        .foregroundStyle(Color.accentColor)
                        .font(.caption)
                    
                    Picker("Book Type", selection: $selectedType) {
                        ForEach (bookTypes, id:\.self) { bookType in
                            Text(bookType)
                        }
                    }
                    .pickerStyle(.segmented)
                    //.focusable(interactions: .activate)
                    .focused($focusedField, equals: .selectedType)
                    .accessibilityLabel("Book Type Picker")
                    
                    if !newRecord {
                        HStack {
                            Text("Title: ")
                                .foregroundStyle(Color.accentColor)
                                .font(.subheadline)
                            TextField("Title: \(title)", text: $title)
                                //.focusable(interactions: .edit)
                                .focused($focusedField, equals: .title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .accessibilityLabel("Title Details for \(title)")
                                .onChange(of: title) {
                                    titleHasChanged = true
                                }
                        }
                    } else {
                        HStack {
                            Text("Title: ")
                                .foregroundStyle(Color.accentColor)
                                .font(.subheadline)
                            TextField ("New Title: ", text: $title)
                                //.focusable(interactions: .edit)
                                .focused($focusedField, equals: .title)
                                .font(.subheadline)
                                .submitLabel(.next)
                                .lineLimit(2)
                                .accessibilityLabel("New Title")
                        }
                    }

                    HStack {
                        Text("Edition Number: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.caption)
                        TextField("Edition Number: ", text: $editionNumber)
                            .focused($focusedField, equals: .editionNumber)
                            .font(.subheadline)
                            .textContentType(.none)
                            .submitLabel(.next)
                            .accessibilityLabel("Edition Number")
                    }
                    HStack{
                        Text("Genre: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.caption)
                        TextField("Genre: ", text: $genre)
                            .focused($focusedField, equals: .genre)
                            .font(.subheadline)
                            .textContentType(.none)
                            .submitLabel(.next)
                            .accessibilityLabel("Genre")
                    }
                    HStack {
                        Text("ISBN: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.caption)
                        TextField("ISBN: ", text: $ISBN)
                            .focused($focusedField, equals: .ISBN)
                            .font(.subheadline)
                            .textContentType(.none)
                            .submitLabel(.next)
                            .accessibilityLabel("ISBN")
                    }
                    HStack {
                        Text("Published Date: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.caption)
                        TextField("Published date: ", text: $publishingDate)
                            .focused($focusedField, equals: .publishingDate)
                            .font(.subheadline)
                            .textContentType(.none)
                            .submitLabel(.next)
                            .accessibilityLabel("Published Date")
                    }
                    HStack {
                        Text("Publishing House: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.caption2)
                        TextField("Publisher: ", text: $publishingHouse)
                            .focused($focusedField, equals: .publishingHouse)
                            .font(.subheadline)
                            .textContentType(.none)
                            .submitLabel(.done)
                            .accessibilityLabel("Publishing House")
                    }
                    
                    Button("Cancel Without Saving") { dismiss() }
                        .buttonStyle(.borderedProminent)
                    
                    if !newRecord {
                        if additionalAuthors.count > 0 {
                            HStack(alignment: .top, content: {
                                Text("All Authors: ")
                                    .accessibilityLabel("All authors.")
                                VStack(alignment: .leading, content: {
                                    ForEach(additionalAuthors, id: \.self) { coAuthor in
                                        Text("\(coAuthor)")
                                            .accessibilityValue("\(coAuthor)")
                                    }
                                })
                                .font(.caption)
                            })
                        }
                    }
                    
                    if selectedType == "Audio" {
                        if narratorListForTitle.count > 0 {
                            HStack(alignment: .top, content: {
                                Text("All Narrators: ")
                                    .accessibilityLabel("All narrators.")
                                VStack(alignment: .leading, content: {
                                    ForEach(narratorListForTitle, id: \.self) { narrator in
                                        Text("\(narrator)")
                                            .accessibilityValue("\(narrator)")
                                    }
                                })
                                .font(.caption)
                            })
                        }
                    }
                } //Form
                .onAppear {
                    focusedField = .picker
                    LoadValues()
                }
                .onSubmit {
                    switch focusedField {
                    case .selectedType:
                        focusedField = .title
                    case .title:
                        focusedField = .editionNumber
                    case .editionNumber:
                        focusedField = .genre
                    case .genre:
                        focusedField = .ISBN
                    case .ISBN:
                        focusedField = .publishingDate
                    case .publishingDate:
                        focusedField = .publishingHouse
                    case .publishingHouse:
#if DEBUG
                        let logger = appLogger()
                        logger.log(level: .info, message: "Case publishingHouse has been reached.")
#endif
                    default:
#if DEBUG
                        let logger = appLogger()
                        logger.log(level: .info, message: "Case default has been reached.")
#endif

                    } //switch
                } //onSubmit
                .autocorrectionDisabled(true)

            } //VStack
            .toolbar(id: "return") {
                ToolbarItem(id: "home", placement: .bottomBar) {
                    NavigationLink("Return to Main Screen") {
                        ContentView(returning: true)
                    }
                    //.buttonStyle(CustomButtonStyle())
                }
            }
            .toolbar(id: "mainSave") {
                ToolbarItem(id: "save", placement: .topBarTrailing) {
                    Button("Save") {
                        SaveProcess()
                        hideKeyboard()
                    }
                }
            }
            .toolbar(id: "more") {
                ToolbarItem(id: "additional", placement: .secondaryAction) {
                    Menu("Additional Actions", systemImage: "text.justify") {
                        NavigationLink("Add a Co-Author") {
                            AuthorView(inputTitle: title, titleIdString: titleIdString, addingCoAuthor: true)
                        }
                        if selectedType == "Audio" {
                            if !titleIdString.isEmpty {
                                NavigationLink("Add a Narrator") {
                                    NarratorView(titleIdString: titleIdString, titleName: title)
                                }
                                .onTapGesture {
                                    SaveProcess()
                                }
                            }
                        }
                    }
                }
            }
            .toolbarRole(.automatic)
        } //NavStack
    } //body
    
    func SaveProcess() {
        CheckForFormChanges ()
        if formHasChanges {
            let resultString = SaveTitle()
            if resultString == true {
                try? SaveTitleDetails()
                saveComplete = true
                formHasChanges = false
                ResetValues()
            }
        }
    }
    
    func CheckForFormChanges() {
        if title != beginningTitle
            || selectedType != beginningSelectedType
            || editionNumber != beginningEditionNumber
            || genre != beginningGenre
            || ISBN != beginningISBN
            || publishingDate != beginningPublishingDate
            || publishingHouse != beginningPublishingHouse {
            
            formHasChanges = true
        }
    }
    
    func LoadValues() {
        
        if !newRecord {
            //this brings back title2
            GetTitleById()
            beginningTitle = title
            focusedField = .title
            authorIdString = GetAuthorId(filter: titleIdString)
            GetTitleDetailsById()
            GetCoAuthors()
                        
            if titleDetails.count > 0 {
                titleDetailsId = titleDetails[0].titleDetailsId.uuidString
                titleIdString = titleDetails[0].titleId.uuidString
                selectedType = titleDetails[0].bookType
                editionNumber = titleDetails[0].wrappedEditionNumber
                genre = titleDetails[0].wrappedGenre
                ISBN = titleDetails[0].wrappedISBN
                publishingDate = titleDetails[0].wrappedPublishingDate
                publishingHouse = titleDetails[0].wrappedPublishingHouse
                if selectedType == "Audio" {
                    GetAllNarratorsForTitle()
                }
            }
        } else {
            beginningTitle = ""
            beginningSelectedType = ""
            beginningEditionNumber = ""
            beginningGenre = ""
            beginningISBN = ""
            beginningPublishingDate = ""
            beginningPublishingHouse = ""
        }
    }
            
    func ResetValues() {
        beginningTitle = title
        beginningSelectedType = selectedType
        beginningEditionNumber = editionNumber
        beginningGenre = genre
        beginningISBN = ISBN
        beginningPublishingDate = publishingDate
        beginningPublishingHouse = publishingHouse
    }
} //struct


