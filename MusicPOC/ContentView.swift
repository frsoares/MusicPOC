//
//  ContentView.swift
//  MusicPOC
//
//  Created by Francisco Miranda Soares on 27/04/26.
//

import SwiftUI
import MusicKit

struct ContentView: View {

    @State private var text = ""

    @State private var authorization = MusicAuthorization.currentStatus

    @State private var albums = MusicItemCollection<Album>()
    @State private var songs = MusicItemCollection<Song>()

    var body: some View {
        if authorization == .authorized {
            NavigationStack {
                normalBody
            }
        } else if authorization == .notDetermined {
            undeterminedBody
        } else {
            deniedBody
        }
    }

    var normalBody: some View {
        VStack {
            (Text("Hello, ") + Text(Image(systemName: "applelogo")) + Text("Music!"))
                .font(.largeTitle)
            TextField("Search for a song", text: $text)
                .onSubmit {
                    self.search(for: self.text)
                }
            Button("Search") {
                self.search(for: self.text)
            }
            if !albums.isEmpty {
                Section(header: Text("Albums").font(.headline)) {
                    albumsBody
                }
            }
            if !songs.isEmpty {
                Section(header: Text("Songs").font(.headline)) {
                    songsBody
                }
            }
        }
        .padding()
    }

    var albumsBody: some View {
        List(albums) { album in
            NavigationLink {
                AlbumDetailView(album: album)
            } label: {
                AlbumCell(album: album)
            }
        }
    }

    var songsBody: some View {
        List(songs) { song in
            SongCell(song: song)
        }
    }

    var deniedBody: some View {
        ContentUnavailableView("You don't have permission to use Music. Please allow it in settings", systemImage: "music.note.slash")
    }

    var undeterminedBody: some View {
        VStack {
            Image(systemName: "music.pages.fill")
            Button("Authorize apple music usage", action: authorizeMusic)
                .buttonBorderShape(.roundedRectangle(radius: 16))
                .glassEffect()
        }
    }

    func authorizeMusic ()  {
        let authorization = MusicAuthorization.currentStatus
        switch authorization {
        case .notDetermined:
            Task {
                let status = await MusicAuthorization.request()
                withAnimation {
                    self.authorization = status
                }
            }
        case .denied:
            fatalError("this shouldn't be called while it's denied")
        default:
            print("OK then everything seems to be in order")
        }
    }

    func search(for term: String) {
        var request = MusicCatalogSearchRequest(term: term, types: [Song.self, Album.self])
        request.limit = 5
        Task {
            do {
                let response = try await request.response()
                self.apply(response: response, for: term)
            } catch {
                print(error.localizedDescription)

            }
        }
    }

    @MainActor
    func apply(response: MusicCatalogSearchResponse, for term: String) {
        // não temos atualização se o termo de busca já tiver sido alterado
        if self.text == term {
            withAnimation {
                self.songs = response.songs
                self.albums = response.albums
            }
        }
    }
}

#Preview {
    ContentView()
}
