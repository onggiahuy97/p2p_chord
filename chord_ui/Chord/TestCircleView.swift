import SwiftUI

struct TestCircleView: View {
    var body: some View {
        CircleWithNodes()
    }
}

struct CircleWithNodes: View {
    @EnvironmentObject var viewModel: ViewModel
    @Namespace private var namespace
    
    let radius: CGFloat = 250
    let rotationOffset: CGFloat = .pi / 5
    // Calculate positions for nodes
    private func nodePosition(for index: Int) -> CGPoint {
            // Start from top (0, -1) and go clockwise
            // Added rotationOffset to shift all nodes
            let angle = 2 * .pi * CGFloat(index) / CGFloat(viewModel.nodes.count) - .pi / 2 + rotationOffset
            return CGPoint(
                x: radius * cos(angle),
                y: radius * sin(angle)
            )
        }
    
    var body: some View {
        VStack {
            Text("Chord Finger Table")
                .font(.title)
                .padding()
            ZStack {
                // Main circle
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
                
                // Nodes
//                ForEach(Array(viewModel.nodes.map(\.id).enumerated()), id: \.0) { index, value in
                ForEach(viewModel.nodes, id: \.id) { node in
                    let index = viewModel.nodes.firstIndex(where: { $0.id == node.id}) ?? -1
                    let position = nodePosition(for: index)
                    Circle()
                        .fill(node.id == (viewModel.currentNode?.id ?? -1) ? Color.blue : Color.gray)
                        .overlay(Text("\(node.id)").foregroundStyle(.white), alignment: .center)
                        .overlay(Text("\(node.messagesCount) keys").bold().position(x: 75, y:0))
                        .frame(width: 50, height: 50)
                        .position(
                            x: position.x + radius,
                            y: position.y + radius
                        )
                        .matchedGeometryEffect(id: node.id, in: namespace)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: index)
                        .onTapGesture {
                            viewModel.fetchNodeInfo(for: node.id)
                        }
                        .onTapGesture {
                            viewModel.fetchNodeInfo(for: node.id)
                        }
                }
            }
            .frame(width: radius * 2, height: radius * 2)
            .padding()
        }
        .padding(20)
    }
}

#Preview {
    TestCircleView()
}
