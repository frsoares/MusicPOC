//
//  AlbumCell.swift
//  MusicPOC
//
//  Created by Francisco Miranda Soares on 28/04/26.
//

import SwiftUI
import MusicKit

struct AlbumCell: View {

    let album: Album

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url:album.artwork?.url(width: 30, height: 30)) { image in
                image.resizable().scaledToFit().frame(width: 30, height: 30)
            } placeholder: {
                ProgressView()
                    .frame(width: 30, height: 30)
            }
            VStack(alignment: .leading) {
                Text(album.title)
                    .multilineTextAlignment(.leading)
                Text(album.artistName)
                    .font(.caption)
            }
            Spacer()
            let yearString = album.releaseDate?.formatted(date: .abbreviated, time: .omitted)
            if let yearString {
                Text("(\(yearString))")
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    AlbumCell()
//}
