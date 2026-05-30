//
//  NarratorView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/10/24.
//

import SwiftUI
import os

struct NarratorView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.narratorLastName)
        ]
    )
    var narrators: FetchedResults<Narrator>
    
    @State var narrator: FetchedResults<Narrator>.Element?
    
    @State var titleIdString: String = ""
    @State var titleName: String = ""
    
    @State var filteredNarrators: [String] = []
    
    //for holding the bound values
    @State var narratorIdString: String = ""
    @State var narratorFirstName: String = ""
    @State var narratorMiddleName: String = ""
    @State var narratorLastName: String = ""
    
    //holding the beginningValues to check for changes at save
    @State var beginningNarratorFirstName: String = ""
    @State var beginningNarratorMiddleName: String = ""
    @State var beginningNarratorLastName: String = ""
    
    //item selected by user-is used by parsing function
    @State var tappedItem: String = ""
    @State var arrayID: String = ""
    
    @State var nameFormatter = NameFormatter()
    @State var foundNarratorLastName: String = "" //for edit search for duplicates
    @State var foundNarratorFirstName: String = "" //for edit search for duplicates
    @State var lastNameAlert: Bool = false
    @State var alreadyExists: Bool = false
    @State var formHasChanges: Bool = false
    
    @State var showNarratorsSheet: Bool = false
    
    enum FocusedField {
        case narratorFirstName
        case narratorMiddleName
        case narratorLastName
    }
    @FocusState private var focusedField: FocusedField?
    

    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading) {
                    if !titleName.isEmpty {
                        Text("Add New Narrator for: \(titleName)")
                            .foregroundStyle(Color.accentColor)
                            .accessibilityLabel("Ready to add new narrator.")
                        
                        Divider()
                        
                        Text("First Name: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.subheadline)
                        TextField("Narrator First Name", text: $narratorFirstName)
                            .focused($focusedField, equals: .narratorFirstName)
                            .font(.subheadline)
                            .textContentType(.givenName)
                            .submitLabel(.next)
                            .accessibilityLabel("Enter Narrator First Name")
                        
                        Divider()
                        
                        Text("Middle Name: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.subheadline)
                        TextField("Narrator Middle Name", text: $narratorMiddleName)
                            .focused($focusedField, equals: .narratorMiddleName)
                            .font(.subheadline)
                            .textContentType(.middleName)
                            .submitLabel(.next)
                            .accessibilityLabel("Enter Narrator Middle Name")
                        
                        Divider()
                        
                        Text("Last Name: ")
                            .foregroundStyle(Color.accentColor)
                            .font(.subheadline)
                        TextField("Narrator Last Name", text: $narratorLastName)
                            .focused($focusedField, equals: .narratorLastName)
                            .font(.subheadline)
                            .textContentType(.familyName)
                            .submitLabel(.done)
                            .accessibilityLabel("Enter Narrator Last Name")
                    }
                }
                .onSubmit {
                    switch focusedField {
                    case .narratorFirstName:
                        focusedField = .narratorMiddleName
                    case .narratorMiddleName:
                        focusedField = .narratorLastName
                    case .narratorLastName:
                        guard !narratorLastName.isEmpty else {
                            lastNameAlert = true
                            let logger = appLogger()
                            logger.log(level: .info, message: "Narrator Last Name must not be empty.")
                            return
                        }
                    default:
#if DEBUG
                        let logger = appLogger()
                        logger.log(level: .info, message: "Case default has been reached.")
#endif
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    
                    guard !titleIdString.isEmpty else { return }
                    
                    if !titleIdString.isEmpty && !titleName.isEmpty {
                        GetAllNarratorsForTitle()
                    }
                    if !narratorIdString.isEmpty {
                        narratorIdString = narrator!.narratorId.uuidString
                        focusedField = .narratorFirstName
                    }
                    if !tappedItem.isEmpty {
                        tappedItem  = ""
                    }
                }
                
                Divider()
                    .padding(10)
            }
            if !filteredNarrators.isEmpty {
                VStack(alignment: .center) {
                    if !titleName.isEmpty {
                        Text("Narrator(s) for: \(titleName)")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                        Text("(previously entered)")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                            .accessibilityLabel("Narrators for \(titleName)")
                        
                        ScrollView {
                            ForEach(filteredNarrators, id:\.self) { selectedItem in
                                Text("\(selectedItem)")
                                    .font(.subheadline)
                                    .onTapGesture {
                                        if !selectedItem.isEmpty {
                                            tappedItem = String(selectedItem)
                                            ParseNarratorName()
                                        }
                                    }
                            }
                        }
                    }
                    
                    Divider()
                        .padding(10)
                    
                    if !narrators.isEmpty {
                        Text("All Narrators Currently Entered:")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)
                        
                        ScrollView {
                            
                            ForEach(narrators, id: \.narratorId) { narrator in
                                
                                Text(nameFormatter.ConcatenateNameFields(lastName: narrator.narratorLastName,
                                                                         firstName: narrator.wrappedNarratorFirstName,
                                                                         middleName: narrator.wrappedNarratorMiddleName))
                                .accessibilityLabel("\(narrator.narratorLastName), \(narrator.wrappedNarratorFirstName)")
                                .onTapGesture {
                                    FillNarratorNames(narrator: narrator)
                                }
                            }
                        }
                    }
                }
                    
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            CheckForFormChanges()
                            if formHasChanges {
                                ValidateNarratorAndSave()
                                ResetValues()
                            }
                            hideKeyboard()
                        }
                    }
                    ToolbarItem(id: "home", placement: .bottomBar) {
                        NavigationLink("Return to Main Screen") {
                            ContentView(returning: true)
                        }
                        //.buttonStyle(CustomButtonStyle())
                    }
                }
            
                .alert("Last name is missing or is too short. Must be more than one character.", isPresented: $lastNameAlert) {
                    Button("Ok") {}
                }
                .accessibilityLabel("Last name is missing or is too short.")
                .alert("This narrator is already in our database.", isPresented: $alreadyExists) {
                    Button("Ok") {
                        narratorFirstName = ""
                        narratorMiddleName = ""
                        narratorLastName = ""
                        alreadyExists = false
                    }
                    .accessibilityLabel("Ok")
                }
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                //.safeAreaPadding()
            }
        }
    }
    
    func CheckForFormChanges() {
        
        if beginningNarratorLastName != narratorLastName
            || beginningNarratorFirstName != narratorFirstName
            || beginningNarratorMiddleName != narratorMiddleName {
            
            formHasChanges = true
        }
    }
    
    func ResetValues() {
        
        beginningNarratorLastName = narratorLastName
        beginningNarratorFirstName = narratorFirstName
        beginningNarratorMiddleName = narratorMiddleName
    }
    
    func ParseNarratorName() {
        
        narratorLastName = ""
        narratorFirstName = ""
        narratorMiddleName = ""
        if tappedItem.contains(", ") {
            narratorLastName = tappedItem.components(separatedBy: ", ")[0]
            let firstAndMiddle = tappedItem.components(separatedBy: ", ")[1]
            if firstAndMiddle.components(separatedBy: " ").count > 1 {
                narratorFirstName = firstAndMiddle.components(separatedBy: " ")[0]
                narratorMiddleName = firstAndMiddle.components(separatedBy: " ")[1]
            } else {
                narratorFirstName = firstAndMiddle
            }
        } else {
            narratorLastName = tappedItem
        }
        if tappedItem.contains("#") {
            arrayID = tappedItem.components(separatedBy:"#")[1]
        }
    }
    
    func FillNarratorNames(narrator: Narrator) {
        
        narratorIdString = narrator.narratorId.uuidString
        narratorLastName = narrator.narratorLastName.trimmingCharacters(in: .whitespacesAndNewlines)
        narratorFirstName = narrator.wrappedNarratorFirstName.trimmingCharacters(in: .whitespacesAndNewlines)
        narratorMiddleName = narrator.wrappedNarratorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
