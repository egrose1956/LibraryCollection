//
//  NarratorsWorksView.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/16/24.
//

import CoreData
import SwiftUI

struct NarratorsWorksView: View {
        
    @Environment(\.managedObjectContext) var moc
    
    @State var narratorIdString: String
    @State var displayName: String = ""
    @State var titleIdString: String = ""
    @State var narratorTitles: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("\(displayName)'s Works Previously Entered:")
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                        
                ScrollView {
                    ForEach (narratorTitles, id:\.self) { selectedItem in
                        
                        Text("\(selectedItem.components(separatedBy: "*")[0])")

                    }
                }
                .onAppear {
                    moc.refreshAllObjects()
                    GetAllTitlesByNarrator(narratorIdString: narratorIdString)
                }
            }
        }
    }
    
        
//        func GetComponentValues(componentString: String) {
//            titleIdString = componentString.components(separatedBy: "*")[1]
//        }
}

