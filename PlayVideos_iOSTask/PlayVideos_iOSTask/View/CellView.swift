//
//  CellView.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import SwiftUI

struct MyCell: View {
    let videos: [Arr]
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 10) {
                ForEach(videos) { video in
                  //  VideoPlayerView(url: URL(string: video.video)!)
                    VideoPlayerView(videoURL: URL(string:video.video)!, thumbnailURL: URL(string:video.thumbnail)!)
                        .frame(width: geometry.size.width / 2 - 5, height: geometry.size.height / 2 - 5)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
    }
}
