//
//  ViewModel.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//

import Foundation
import Combine

class VideoViewModel: ObservableObject {
       @Published var arr: [Arr] = []
       @Published var errorMessage: String?

       func fetchVideos() {
           guard let videoData = VideoService.shared.fetchVideos() else {
                       errorMessage = "Failed to load videos."
                       return
                   }
           self.arr = videoData.reels.flatMap { $0.arr }
       }
}



