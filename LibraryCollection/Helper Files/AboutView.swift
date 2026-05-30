//
//  About.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 5/2/23.
//

import SwiftUI

struct AboutView: View {

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
//                Text("LibraryCollection")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(20)
//                    .accessibilityLabel("LibraryCollection")
                Text("Developed By: Elizabeth G. Rose")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(10)
                    .accessibilityLabel("Developed by Elizabeth G. Rose")
                Text("copyright 2023-2026")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .accessibilityLabel("copyright 2023-2026")
                Text("Explore documentation at the website:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(10)
                    .accessibilityLabel("See website:")
                Text("www.librarycollection.riverthree.com")
                    .font(.body)
                    .fontWeight(.medium)
                    .accessibilityValue("www.librarycollection.riverthree.com")
            }
            .foregroundColor(Color.accentColor)
        }
        Spacer()
    }
}
