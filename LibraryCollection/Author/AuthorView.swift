//
//  AuthorView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 2/1/24.
//

import SwiftUI
import CoreData
import os

struct AuthorView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var beginningAuthorLastName: String = ""
    @State var beginningAuthorFirstName: String = ""
    @State var beginningAuthorMiddleName: String = ""
    
    @State var authorLastName: String = ""
    @State var authorFirstName: String = ""
    @State var authorMiddleName:  String = ""
    @State var authorIdString: String = ""

    @State var inputTitle = ""
    @State var titleIdString = ""
    @State var existingTitleIdString = ""
    @State var existingAuthorLastName: String = ""
    @State var existingAuthorFirstName: String = ""
    
    @State var lastNameWarning: Bool = false
    @State var saveIsComplete: Bool = false
    @State var unSavedWarning: Bool = false
    @State var recordHasChanges: Bool = false
    
    enum Field {
        case authorFirstName
        case authorMiddleName
        case authorLastName
        case addTitle
    }
    @FocusState private var focusedField: Field?
    
    @State var addingCoAuthor: Bool = false
    @State var authorTitles: [String] = []
        
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    
                    Text("First Name: ")
                        .foregroundStyle(Color.accentColor)
                        .font(.subheadline)
                    TextField("Author First Name", text: $authorFirstName)
                        .focused($focusedField, equals: .authorFirstName)
                        .font(.subheadline)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .accessibilityLabel("Author First Name")
                    
                    Divider()
                    
                    Text("Middle Name: ")
                        .foregroundStyle(Color.accentColor)
                        .font(.subheadline)
                    TextField("Author Middle Name", text: $authorMiddleName)
                        .focused($focusedField, equals: .authorMiddleName)
                        .font(.subheadline)
                        .textContentType(.middleName)
                        .submitLabel(.next)
                        .accessibilityLabel("Author Middle Name")
                    
                    Divider()
                    
                    Text("Last Name: ")
                        .foregroundStyle(Color.accentColor)
                        .font(.subheadline)
                    TextField("Author Last Name", text: $authorLastName)
                        .font(.subheadline)
                        .focused($focusedField, equals: .authorLastName)
                        .textContentType(.familyName)
                        .submitLabel(.next)
                        .accessibilityLabel("Author Last Name")
                }
                .onSubmit {
                    switch focusedField {
                    case .authorFirstName:
                        focusedField = .authorMiddleName
                    case .authorMiddleName:
                        focusedField = .authorLastName
                    case .authorLastName:
                        focusedField = .addTitle
                        if authorLastName.count < 2 {
                            lastNameWarning = true
                        }
                        CheckFormForChanges()   //to see if we must save
                        if recordHasChanges && !saveIsComplete {
                            PerformValidateAndSave()
                        }
                    default:
#if DEBUG
                        let logger = appLogger()
                        logger.log(level: .info, message: "Case default has been reached.")
#endif
                    }
                       
                    CheckFormForChanges()   //to see if we must save
                    if recordHasChanges && !saveIsComplete {
                        PerformValidateAndSave()
                    }
                }
                if !addingCoAuthor {
                    NavigationLink {
                        TitleDetailsView(authorIdString: authorIdString,
                                         titleIdString: titleIdString,
                                         newRecord: true,
                                         authorLastName: authorLastName,
                                         authorFirstName: authorFirstName,
                                         authorMiddleName: authorMiddleName)
                    } label: {
                        Text("If you are adding a co-Author for an existing title, pleasse use the title details screen - Additional Actions menu item. Otherwise, add a new Title for this Author by selecting this link.")
                            .font(.subheadline)
                            //.foregroundStyle(Color.accentColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                            .padding(.bottom)
                    }
                }
                if authorTitles.count > 0 {
                    AuthorsWorksView(filteredTitles: authorTitles, authorIdString: authorIdString)
                        .onTapGesture {
                            CheckFormForChanges()   //to see if we must save
                            if recordHasChanges && !saveIsComplete {
                                    unSavedWarning = true
                            }
                        }
                }
                
            } //should be form
            .onAppear {
                focusedField = .authorFirstName
                LoadValues()
                if !addingCoAuthor {
                    GetAllTitlesByAuthor(authorIdString: authorIdString)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        CheckFormForChanges()
                        if recordHasChanges {
                            PerformValidateAndSave()
                            if addingCoAuthor {
                                if !titleIdString.isEmpty {
                                    AddTitleAuthorOnly(title: titleIdString, author: authorIdString)
                                }
                            }
                            //then reset the beginning values to what has
                            //just been saved
                            ResetValues()
                        }
                        saveIsComplete = true
                        recordHasChanges = false
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink("Return to Main Screen") {
                        ContentView(returning: true)
                    }

                }
            }
            .alert(isPresented: $lastNameWarning) {
                Alert(
                    title: Text("Last Name Validation"),
                    message: Text("Last Name is required and must be longer than one character."),
                    primaryButton: .default(Text("OK")) {
                        lastNameWarning = false
                        dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(isPresented: $unSavedWarning) {
                Alert(
                    title: Text("Save Warning"),
                    message: Text("Any changes made to the author's name have not been saved. Save now?"),
                    primaryButton: .default(Text("OK")) {
                        
                        if recordHasChanges {
                            PerformValidateAndSave()
                            saveIsComplete = true
                            unSavedWarning = false
                            //then reset the beginning values to what has
                            //just been saved
                            ResetValues()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .safeAreaPadding()
    }
    
    func CheckFormForChanges() {
        
        //if we compare what is in the field at the time
        //of a save request or the form disappearance, we can determine
        //if there have been any changes.
        if ((authorLastName != beginningAuthorLastName) || (authorFirstName != beginningAuthorFirstName) || (authorMiddleName != beginningAuthorMiddleName)) {
            
            recordHasChanges = true
        }
    }
    
    func LoadValues() {
        
        //for established records, this would be the database
        //values currently
        authorLastName = beginningAuthorLastName
        authorFirstName = beginningAuthorFirstName
        authorMiddleName = beginningAuthorMiddleName
    }
    
    func ResetValues() {
        beginningAuthorLastName = authorLastName
        beginningAuthorFirstName = authorFirstName
        beginningAuthorMiddleName = authorMiddleName
    }
}
