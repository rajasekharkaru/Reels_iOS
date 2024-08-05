//
//  ContentView.swift
//  PlayVideos_iOSTask
//
//  Created by karu on 05/08/24.
//


import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var viewModel = VideoViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.arr.chunked(into: 4)) { videoChunk in
                        MyCell(videos: videoChunk.elements)
                            .frame(height: 600)
                            .padding(.vertical, 20)
                    }
                }
                .navigationTitle("Video Grid")
            }
            .onAppear {
                viewModel.fetchVideos()
            }
            
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
}


extension Array {
    func chunked(into size: Int) -> [IdentifiableChunk<Element>] {
        var chunks: [IdentifiableChunk<Element>] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(IdentifiableChunk(id: UUID(), elements: chunk))
        }
        return chunks
    }
}

struct IdentifiableChunk<Element>: Identifiable {
    let id: UUID
    let elements: [Element]
}
extension String: Identifiable {
    public var id: String { self }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
