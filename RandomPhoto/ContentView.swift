//
//  ContentView.swift
//  RandomPhoto
//
//  Created by Gustavo Sacramento on 17/03/23.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var image: Image?
    
    func fetchNewImage() {
        guard let url = URL(string: "https://random.imagecdn.app/500/500") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, _, _ in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.sync {
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                self.image = Image(uiImage: uiImage)
            }
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                if let image = viewModel.image {
                    ZStack {
                        image
                            .resizable()
                            .foregroundColor(.green)
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.width / 1.2)
                    .background(.pink)
                    .cornerRadius(8)
                    
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.cyan)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.fetchNewImage()
                }, label: {
                    Text("New Image!")
                        .frame(width: 250, height: 55)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                        .padding()
                })
            }
            .navigationTitle("Random Photo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
