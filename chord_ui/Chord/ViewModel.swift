//
//  Model.swift
//  Chord
//
//  Created by Huy Ong on 11/10/24.
//

import SwiftUI
import SwiftyJSON

// Node data structure
struct ChordNode: Identifiable {
    let id: Int
    let messagesCount: Int
    var color: Color = .gray
    var position: CGPoint = .zero
}

// Define the Node model based on the JSON structure
struct Node: Decodable {
    let id: Int
    let successor: Int
    let messagesCount: Int
}

struct NodesResponse: Decodable {
    let nodes: [Node]
}

class ViewModel: ObservableObject {
    @Published var nodes: [ChordNode] = []
    @Published var currentNode: ChordNode?
    @Published var nodeInfo: String?
    @Published var key: String = ""
    @Published var value: String = ""

    let nodeRadius: CGFloat = 18
    let ringDiameter: CGFloat = 300
    
    let BASE_URL = "http://127.0.0.1:5000"
    
    init() {
        self.fetchNodes()
    }
    
//    func updateNodes() {
//        let ids = nodes.map(\.id).sorted()
//        var tempNodes: [ChordNode] = []
//        let angleIncrement = 2 * .pi / Double(ids.count)
//        let radius = ringDiameter / 2
//        // Initialize each node's position and color based on its index
//        for (index, id) in ids.enumerated() {
//            let angle = angleIncrement * Double(index)
//            let x = radius + cos(angle) * radius
//            let y = radius + sin(angle) * radius
//            let position = CGPoint(x: x, y: y)
//            let color = Color.gray
//            tempNodes.append(ChordNode(id: id, color: color, position: position))
//        }
//        
//        DispatchQueue.main.async {
//            withAnimation {
//                self.nodes = tempNodes
//            }
//        }
//        
//    }
    
    func leaveChord(for id: Int) {
        guard let url = URL(string: "\(BASE_URL)/leave/\(id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching node info: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.currentNode = nil
                self.fetchNodes()
            }
        }.resume()
    }
    
    func insertMessage() {
        guard let url = URL(string: "\(BASE_URL)/insert") else {
            print("Invalid URL")
            return
        }
        
        guard !key.isEmpty && !value.isEmpty else {
            print("key and value must not be empty")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let payload: [String: String] = [
            "key": self.key,
            "value": self.value
        ]
        do {
            let json = try JSONSerialization.data(withJSONObject: payload)
            request.httpBody = json
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error inserting message: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                self.fetchNodes()
                
            }.resume()
        } catch {
            print("Error creating JSON: \(error)")
        }
        
        self.key.removeAll()
        self.value.removeAll()
        
    }
    
    func fetchNodeInfo(for id: Int) {
        guard let url = URL(string: "\(BASE_URL)/info/\(id)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching node info: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
                DispatchQueue.main.async {
                    self.nodeInfo = String(decoding: jsonData, as: UTF8.self)
                    self.currentNode = self.nodes.first(where: { $0.id == id })
                }
            } else {
                print("json data malformed")
            }
            
            // Convert data to string to see raw JSON
//            if let jsonString = String(data: data, encoding: .utf8) {
//                
//                
//                
//                DispatchQueue.main.async {
//                    self.nodeInfo = jsonString
//                    self.currentNode = self.nodes.first(where: { $0.id == id })
//                }
//            } else {
//                print("Could not convert data to string")
//            }
        }.resume()
    }
    
    func newNode() {
        guard let url = URL(string: "\(BASE_URL)/join") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating new node: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("New node created:", jsonString)
                }
            } else {
                print("Could not convert data to string")
            }
            
            self.fetchNodes()
        }.resume()
    }
    
    func fetchNodes() {
        guard let url = URL(string: "\(BASE_URL)/nodes") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching nodes: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(NodesResponse.self, from: data)
                
                // Update the nodes on the main thread
                DispatchQueue.main.async {
                    withAnimation {
                        self.nodes = decodedResponse.nodes.map(\.id).sorted().map { i in
                            let index = decodedResponse.nodes.firstIndex(where: { $0.id == i})!
                            return ChordNode(id: i, messagesCount: decodedResponse.nodes[index].messagesCount)
                        }
                    }
//                    self.updateNodes()
                    self.currentNode = self.nodes.sorted(by: { $0.id < $1.id}).first
                    if let id = self.currentNode?.id {
                        self.fetchNodeInfo(for: id)
                    }
                }
            } catch {
                print("Error decoding nodes: \(error)")
            }
        }.resume()
    }

}
