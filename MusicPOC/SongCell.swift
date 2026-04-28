//
//  SongCell.swift
//  MusicPOC
//
//  Created by Francisco Miranda Soares on 28/04/26.
//

import SwiftUI
import MusicKit

struct SongCell: View {
    let song: Song
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.title)

                Text(song.artistName)
                    .font(.caption)

            }
            Spacer() 
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    SongCell()
//}
