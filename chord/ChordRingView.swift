import SwiftUI
import Foundation



// Single node view component
struct NodeView: View {
    @Binding var node: ChordNode
    let nodeRadius: CGFloat
    
    var body: some View {
        Circle()
            .frame(width: nodeRadius * 2, height: nodeRadius * 2)
            .position(node.position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        node.position = value.location
                    }
            )
    }
}

struct ChordRingView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        CircleWithNodes()
//        VStack {
//            Text("Chord P2P DTH Ring")
//                .font(.title)
//                .padding(.bottom, 40)
//            
//            ZStack {
//                let center = CGPoint(x: viewModel.ringDiameter / 2, y: viewModel.ringDiameter / 2)
//                
//                // Draw circular connections between sorted nodes
//                ForEach(0..<viewModel.nodes.count, id: \.self) { i in
//                    let fromNode = viewModel.nodes[i]
//                    let toNode = viewModel.nodes[(i + 1) % viewModel.nodes.count] // Wrap around to form a ring
//                    CurvedLine(from: fromNode.position, to: toNode.position, center: center)
//                        .stroke(Color.gray, lineWidth: 1)
//                }
//                
//                // Draw nodes
//                ForEach($viewModel.nodes) { $node in
//                    NodeView(node: $node, nodeRadius: viewModel.nodeRadius)
//                        .foregroundStyle(node.id == (viewModel.currentNode?.id ?? -1) ? Color.blue : node.color)
//                        .onTapGesture {
//                            viewModel.fetchNodeInfo(for: node.id)
//                        }
//                }
//                
//                // Labels for each node
//                ForEach(viewModel.nodes) { node in
//                    Text("P\(node.id)")
//                        .font(.system(size: 14, weight: .medium))
//                        .position(x: node.position.x, y: node.position.y - 25)
//                }
//            }
//            .frame(width: viewModel.ringDiameter + 50, height: viewModel.ringDiameter + 50)
//        }
//        .padding()
    }
}

// Curved Line Shape between two points in a circular fashion
struct CurvedLine: Shape {
    var from: CGPoint
    var to: CGPoint
    var center: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        
        // Optional: For smooth curves, uncomment the below control points for an arc-like curve
        // let control1 = CGPoint(x: (from.x + center.x) / 2, y: (from.y + center.y) / 2)
        // let control2 = CGPoint(x: (to.x + center.x) / 2, y: (to.y + center.y) / 2)
        // path.addCurve(to: to, control1: control1, control2: control2)
        
        path.addLine(to: to)
        
        return path
    }
}

#Preview {
    ChordRingView()
}
