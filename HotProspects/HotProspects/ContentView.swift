//
//  ContentView.swift
//  HotProspects
//
//  Created by Angel Vázquez on 10/12/19.
//  Copyright © 2019 Ángel Vázquez. All rights reserved.
//

import SwiftUI

class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

class DelayedUpdater: ObservableObject {

    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

// MARK: - Views
struct ContentView: View {
    
    @ObservedObject var updater = DelayedUpdater()
    
    var body: some View {
        Image("example")
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}


// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
