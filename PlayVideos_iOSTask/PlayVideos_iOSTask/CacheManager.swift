//
//  CacheManager.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import Foundation
import SwiftUI


//class CacheManager {
//    static let shared = CacheManager()
//    private let cache = NSCache<NSString, UIImage>()
//    private let cacheVideoData = NSCache<NSString, NSData>()
//
//    private init() {}
//    
//    func getCachedImage(for url: URL) -> UIImage? {
//        return cache.object(forKey: url.absoluteString as NSString)
//    }
//    
//    func cacheImage(_ image: UIImage, for url: URL) {
//        cache.setObject(image, forKey: url.absoluteString as NSString)
//    }
//    
//    func getVideoCachedData(for url: URL) -> Data? {
//        return cacheVideoData.object(forKey: url.absoluteString as NSString) as Data?
//    }
//    
//    func cacheVideoData(_ data: Data, for url: URL) {
//        cacheVideoData.setObject(data as NSData, forKey: url.absoluteString as NSString)
//    }
//}



class VideoCacheManager {
    static let shared = VideoCacheManager()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getCachedData(for url: URL) -> Data? {
        return cache.object(forKey: url.absoluteString as NSString) as Data?
    }
    
    func cacheData(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
    }
}

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getCachedImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }
    
    func cacheImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
