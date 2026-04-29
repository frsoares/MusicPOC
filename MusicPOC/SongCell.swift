//
//  SongCell.swift
//  MusicPOC
//
//  Created by Francisco Miranda Soares on 28/04/26.
//

import SwiftUI
import MusicKit
import AVFoundation

struct SongCell: View {

    let song: Song
    
    @Binding var audioControl: (audioPlayer: AVAudioPlayer, songId: Song.ID)?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.title)

                Text(song.artistName)
                    .font(.caption)

            }
            Spacer()
            if let previewAssets = song.previewAssets, !previewAssets.isEmpty {
                if let audioControl, audioControl.songId == song.id, audioControl.audioPlayer.isPlaying {
                    Button {
                        audioControl.audioPlayer.stop()
                        self.audioControl = nil
                    } label: {
                        Image(systemName: "stop.circle.fill")
                    }
                }
                else {
                    Button {
                        if let audioControl, audioControl.songId == song.id {
                            audioControl.audioPlayer.currentTime = 0
                            audioControl.audioPlayer.play()
                        } else {
                            Task {
                                audioControl?.audioPlayer.stop()
                                await configureAudio()
                                audioControl?.audioPlayer.play()
                            }
                        }
                    } label: {
                        Image(systemName: "play.circle.fill")
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }

    func configureAudio() async {
        if let previewAssets = song.previewAssets, !previewAssets.isEmpty {
            if let url = previewAssets.first?.url {
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)

                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        return
                    }
                    try updateAudioPlayer(with: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    @MainActor
    func updateAudioPlayer(with data: Data) throws {
        audioControl = (audioPlayer: try AVAudioPlayer(data: data), songId: song.id)
//        audioPlayer = try AVAudioPlayer(data: data)
        audioControl?.audioPlayer.currentTime = 0
    }
}

//#Preview {
//    SongCell()
//}
