//
//  AlbumDetailView.swift
//  MusicPOC
//
//  Created by Francisco Miranda Soares on 28/04/26.
//

import SwiftUI
import MusicKit

struct AlbumDetailView: View {
    let album: Album
    var body: some View {
        Form {
            HStack {
                AsyncImage(url: album.artwork?.url(width: 256, height: 256)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 16)
                } placeholder: {
                    ProgressView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 16)
                }
                Spacer()
                VStack (alignment: .trailing){
                    Text(album.title)
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                    Text(album.artistName)
                        .font(.title)
                        .multilineTextAlignment(.trailing)
                }
            }
            .padding()
            HStack {
                Text("Release Date:")
                Spacer()
                Text("\(album.releaseDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
            }
            .padding()
            if !album.genreNames.isEmpty {
                HStack (alignment: .top) {
                    Text("Genres:")
                    Spacer()
                    VStack (alignment: .trailing) {
                        ForEach(album.genreNames, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                .padding()
            }
            if let tracks = album.tracks {
                List(tracks) { track in
                    Text(track.title)
                }
                .padding()
            }

        }
    }
}
//
//#Preview {
//    AlbumDetailView()
//}
