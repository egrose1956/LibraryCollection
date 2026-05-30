//
//  AuthorsWorksView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/2/23.
//

import SwiftUI
import CoreData

struct AuthorsWorksView: View {
        
    @Environment(\.managedObjectContext) var moc
    
    @State var filteredTitles: [String] = []
    @State var authorIdString: String
    @State var titleIdString: String = ""
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Author's Current Works: ")
                .font(.subheadline)
                .fontWeight(.bold)
            
            NavigationStack {
                ScrollView {
                    ForEach (filteredTitles, id:\.self) { selectedItem in
                        NavigationLink("\(selectedItem.components(separatedBy: "*")[0])",
                                       destination: TitleDetailsView(authorIdString: authorIdString,
                                                                     titleIdString: selectedItem.components(separatedBy: "*")[1]))
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.subheadline)
            }
        }
        .foregroundStyle(Color.accentColor)
        .onAppear {
            GetAllTitlesByAuthor(authorIdString: authorIdString)
        }
    }
}
