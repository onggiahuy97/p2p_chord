//
//  ContentView.swift
//  Chord
//
//  Created by Huy Ong on 11/10/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Node Information")
                    ScrollView {
                        if !viewModel.nodes.isEmpty {
                            Text(viewModel.nodeInfo ?? "")
                               
                        } else {
                            Text("")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.white)
                    .font(.largeTitle)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .font(.largeTitle)
                Divider()
                VStack(spacing: 15) {
                    ChordRingView()
                    Spacer()
                    HStack(spacing: 15) {
                        Button("Updates") {
                            viewModel.fetchNodes()
                        }
                        
                        Button("Add Node") {
                            viewModel.newNode()
                        }
                        
                        if let currentNode = viewModel.currentNode {
                            Button("Remove node \(currentNode.id)") {
                                viewModel.leaveChord(for: currentNode.id)
                            }
                        }
                    }
                    .font(.largeTitle)
                    HStack {
                        TextField("Key", text: $viewModel.key)
                        Button("Insert") {
                            viewModel.insertMessage()   
                        }
                    }
                    .font(.largeTitle)
                    Text("Hashing SHA1 = \(viewModel.hashValue)")
                        .font(.largeTitle)
                }
            }
//            Spacer()
//            HStack {
//                Spacer()
//                ScrollView {
//                    HStack {
//                        Button("Fetch Nodes") {
//                            viewModel.fetchNodes()
//                        }
//                        
//                        Button("New Node") {
//                            viewModel.newNode()
//                        }
//                        
//                        if let currentNode = viewModel.currentNode {
//                            Button("Remove node \(currentNode.id)") {
//                                viewModel.leaveChord(for: currentNode.id)
//                            }
//                        }
//                        Spacer()
//                    }
//                    
//                    HStack {
//                        TextField("Key", text: $viewModel.key)
//                        TextField("Value", text: $viewModel.value)
//                        Button("Insert") {
//                            viewModel.insertMessage()
//                        }
//                    }
//                    
//                }
//                .frame(maxWidth: .infinity)
//            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
