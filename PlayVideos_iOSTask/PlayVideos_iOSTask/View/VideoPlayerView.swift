//
//  VideoPlayerView.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    let thumbnailURL: URL
    
    class Coordinator: NSObject {
        var parent: VideoPlayerView
        var player: AVPlayer?
        var playerItem: AVPlayerItem?

        init(parent: VideoPlayerView) {
            self.parent = parent
        }
        
        func playerItemDidPlayToEndTime(notification: Notification) {
            // Handle end time logic here if needed
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = true
        
        if let cachedImage = ImageCacheManager.shared.getCachedImage(for: thumbnailURL) {
            let imageView = UIImageView(image: cachedImage)
            imageView.contentMode = .scaleAspectFill
            playerViewController.contentOverlayView?.addSubview(imageView)
            imageView.frame = playerViewController.contentOverlayView?.bounds ?? .zero
        } else {
            downloadThumbnailImage(for: playerViewController)
        }
        
        loadVideo(for: playerViewController, context: context)
        
        return playerViewController
    }
    
    func updateUIViewController(_ playerViewController: AVPlayerViewController, context: Context) {
        if playerViewController.player == nil {
            loadVideo(for: playerViewController, context: context)
        }
    }
    
    static func dismantleUIViewController(_ playerViewController: AVPlayerViewController, coordinator: Coordinator) {
        playerViewController.player?.pause()
        playerViewController.player = nil
    }
    
    private func loadVideo(for playerViewController: AVPlayerViewController, context: Context) {
        if let cachedData = VideoCacheManager.shared.getCachedData(for: videoURL) {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
            do {
                try cachedData.write(to: tempURL)
                let playerItem = AVPlayerItem(url: tempURL)
                let player = AVPlayer(playerItem: playerItem)
                player.playImmediately(atRate: 2.0) // Set playback rate to 2x
                playerViewController.player = player
            } catch {
                print("Error writing cached video data to temporary file: \(error)")
            }
        } else {
            let player = AVPlayer(url: videoURL)
            player.playImmediately(atRate: 2.0) // Set playback rate to 2x
            playerViewController.player = player
            cacheVideoData(for: player.currentItem)
        }
    }
    
    private func downloadThumbnailImage(for playerViewController: AVPlayerViewController) {
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            ImageCacheManager.shared.cacheImage(image, for: thumbnailURL)
            
            DispatchQueue.main.async {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                playerViewController.contentOverlayView?.addSubview(imageView)
                imageView.frame = playerViewController.contentOverlayView?.bounds ?? .zero
            }
        }.resume()
    }
    
    private func cacheVideoData(for playerItem: AVPlayerItem?) {
        guard let playerItem = playerItem else { return }
        
        playerItem.asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            guard playerItem.asset.statusOfValue(forKey: "playable", error: nil) == .loaded else { return }
            
            let exporter = AVAssetExportSession(asset: playerItem.asset, presetName: AVAssetExportPresetPassthrough)!
            exporter.outputFileType = .mov
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
            exporter.outputURL = tempURL
            
            exporter.exportAsynchronously {
                guard exporter.status == .completed, let outputURL = exporter.outputURL else { return }
                
                do {
                    let data = try Data(contentsOf: outputURL)
                    VideoCacheManager.shared.cacheData(data, for: self.videoURL)
                    try FileManager.default.removeItem(at: outputURL)
                } catch {
                    print("Error caching video data: \(error)")
                }
            }
        }
    }
}





