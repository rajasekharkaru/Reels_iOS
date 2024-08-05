//
//  Model.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import Foundation

struct VideoModel: Decodable {
    let reels: [Reel]
}

// MARK: - Reel
struct Reel: Decodable {
    let arr: [Arr]
}

// MARK: - Arr
struct Arr: Decodable,Identifiable {
    var id:String
    let video: String
    let thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case video, thumbnail
    }
}
