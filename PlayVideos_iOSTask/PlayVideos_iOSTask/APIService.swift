//
//  APIService.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import Foundation
import AVKit

class VideoService {
    static let shared = VideoService()
       
       func fetchVideos() -> VideoModel? {
           guard let url = Bundle.main.url(forResource: "reels", withExtension: "json") else {
               fatalError("Failed to locate reels.json in bundle.")
           }
           
           guard let data = try? Data(contentsOf: url) else {
               fatalError("Failed to load reels.json from bundle.")
           }
           
           let decoder = JSONDecoder()
           guard let video = try? decoder.decode(VideoModel.self, from: data) else {
               fatalError("Failed to decode reels.json from bundle.")
           }
           
           return video
       }
}

