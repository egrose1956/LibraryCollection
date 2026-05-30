//
//  NarratorListView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 2/9/23.
//

import SwiftUI
import SwiftData

struct NarratorListView: View {
    
    @Environment(\.managedObjectContext) var moc
            
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.narratorLastName)
        ]
    )
    var narrators: FetchedResults<Narrator>
    
    //For sending the selected narrator for editing
    @State var narrator: FetchedResults<Narrator>.Element?
    
    @State var titleIdString: String = ""
    @State var titleName: String = ""
    @State var narratorListForTitle: [String] = []
    @State var narratorTitles: [String] = []
    @State var nameFormatter = NameFormatter()
    @State var narratorIdString: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if narrators.isEmpty {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView {
                            Image(systemName: "person.slash")
                                .font(.largeTitle)
                        } description: {
                            VStack(alignment: .center) {
                                Text("No Narrators Created.")
                                Text("Narrators are created from the Title details screen.")
                            }
                        }
                    } else {
                        VStack(alignment: .center) {
                            Image(systemName: "person.slash")
                                .font(.largeTitle)
                            Text("No Narrators Created.")
                            Text("Narrators are created from the Title details screen.")
                        }
                    }
                } else {
                    Text("Narrators")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
    
                    List(narrators, id: \.narratorId) { selectedNarrator in

                        NavigationLink { 
                            NarratorsWorksView(narratorIdString: selectedNarrator.narratorId.uuidString, displayName: nameFormatter.ConcatenateNameFields(
                                    lastName: selectedNarrator.narratorLastName,
                                    firstName: selectedNarrator.wrappedNarratorFirstName,
                                    middleName: selectedNarrator.wrappedNarratorMiddleName))
                        } label: {
                            Text(nameFormatter.ConcatenateNameFields(lastName: selectedNarrator.narratorLastName,
                                                                     firstName: selectedNarrator.wrappedNarratorFirstName,
                                                                     middleName: selectedNarrator.wrappedNarratorMiddleName))
                            .font(.subheadline)
                            .accessibilityLabel("Proceeding to edit \(selectedNarrator.wrappedNarratorFirstName) \(selectedNarrator.narratorLastName)")
                        }
                        .onTapGesture {
                            narratorIdString = selectedNarrator.narratorId.uuidString
                        }
                    }
                }
            }
            .onAppear {
                if !titleIdString.isEmpty {
                    NarratorFilteredForTitle()
                }
            }
            .foregroundColor(Color.accentColor)
        }
    }
}
