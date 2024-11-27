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
            ChordRingView()
            Spacer()
            HStack {
                ScrollView {
                    Text(viewModel.nodeInfo ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.white)
                        .font(.system(size: 18))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity)
                Spacer()
                ScrollView {
                    HStack {
                        Button("Fetch Nodes") {
                            viewModel.fetchNodes()
                        }
                        
                        Button("New Node") {
                            viewModel.newNode()
                        }
                        
                        if let currentNode = viewModel.currentNode {
                            Button("Remove node \(currentNode.id)") {
                                viewModel.leaveChord(for: currentNode.id)
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        TextField("Key", text: $viewModel.key)
                        TextField("Value", text: $viewModel.value)
                        Button("Insert") {
                            viewModel.insertMessage()
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
