import SwiftUI

enum Player: String {
    case x = "X"
    case o = "O"
    case none = ""
}

enum GameMode: String, CaseIterable, Identifiable {
    case single = "Single Player"
    case multiplayer = "Multiplayer"

    var id: String { rawValue }
}

class GameViewModel: ObservableObject {
    @Published var board: [Player] = Array(repeating: .none, count: 9)
    @Published var currentPlayer: Player = .x
    @Published var gameMode: GameMode = .single
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var winningPattern: [Int] = []

    private let winPatterns: [[Int]] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6],
    ]

    private let human: Player = .x
    private let ai: Player = .o

    func resetGame() {
        board = Array(repeating: .none, count: 9)
        currentPlayer = .x
        showAlert = false
        alertMessage = ""
        winningPattern = []
    }

    func makeMove(at index: Int) {
        guard board[index] == .none && !showAlert else { return }
        board[index] = currentPlayer
        if let pattern = findWinPattern(for: currentPlayer, in: board) {
            winningPattern = pattern
            alertMessage = "\(currentPlayer.rawValue) wins!"
            showAlert = true
            return
        } else if board.allSatisfy({ $0 != .none }) {
            alertMessage = "Draw!"
            showAlert = true
            return
        }
        switchMode()
    }

    private func switchMode() {
        if gameMode == .single {
            if currentPlayer == human {
                currentPlayer = ai
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cpuMove()
                }
            } else {
                currentPlayer = human
            }
        } else {
            currentPlayer = (currentPlayer == .x) ? .o : .x
        }
    }

    private func cpuMove() {
        guard let index = bestMove() else { return }
        board[index] = currentPlayer
        if let pattern = findWinPattern(for: currentPlayer, in: board) {
            winningPattern = pattern
            alertMessage = "\(currentPlayer.rawValue) wins!"
            showAlert = true
            return
        } else if board.allSatisfy({ $0 != .none }) {
            alertMessage = "Draw!"
            showAlert = true
            return
        }
        currentPlayer = human
    }

    private func findWinPattern(for player: Player, in board: [Player]) -> [Int]? {
        for pattern in winPatterns {
            if pattern.allSatisfy({ board[$0] == player }) {
                return pattern
            }
        }
        return nil
    }

    private func bestMove() -> Int? {
        var bestScore = Int.min
        var move: Int?
        for i in board.indices where board[i] == .none {
            var tempBoard = board
            tempBoard[i] = ai
            let score = minimax(board: tempBoard, depth: 0, isMaximizing: false)
            if score > bestScore {
                bestScore = score
                move = i
            }
        }
        return move
    }

    private func minimax(board: [Player], depth: Int, isMaximizing: Bool) -> Int {
        if let _ = findWinPattern(for: ai, in: board) {
            return 10 - depth
        }
        if let _ = findWinPattern(for: human, in: board) {
            return depth - 10
        }
        if board.allSatisfy({ $0 != .none }) {
            return 0
        }
        if isMaximizing {
            var bestScore = Int.min
            for i in board.indices where board[i] == .none {
                var newBoard = board
                newBoard[i] = ai
                bestScore = max(bestScore, minimax(board: newBoard, depth: depth + 1, isMaximizing: false))
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for i in board.indices where board[i] == .none {
                var newBoard = board
                newBoard[i] = human
                bestScore = min(bestScore, minimax(board: newBoard, depth: depth + 1, isMaximizing: true))
            }
            return bestScore
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = GameViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)

    var body: some View {
        VStack {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            Picker("Mode", selection: $viewModel.gameMode) {
                ForEach(GameMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Text("Current: \(viewModel.currentPlayer.rawValue)")
                .font(.title2)
                .foregroundColor(viewModel.currentPlayer == .x ? .red : .blue)
                .padding(.bottom)

            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0 ..< 9) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: viewModel.winningPattern.contains(index) ? 5 : 2)
                            .foregroundColor(viewModel.winningPattern.contains(index) ? .green : .primary)
                            .frame(width: 100, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.1))
                            )
                        Text(viewModel.board[index].rawValue)
                            .font(.system(size: 64))
                            .foregroundColor(
                                viewModel.board[index] == .x ? .red : .blue
                            )
                            .scaleEffect(viewModel.board[index] == .none ? 0 : 1)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: viewModel.board[index])
                    }
                    .onTapGesture {
                        viewModel.makeMove(at: index)
                    }
                    .disabled(viewModel.board[index] != .none || viewModel.showAlert)
                }
            }
            .padding()

            Button(action: {
                withAnimation {
                    viewModel.resetGame()
                }
            }) {
                Text("Restart")
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom)
            Spacer()
            Text("Made with love by Ankit")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"), action: {
                    withAnimation {
                        viewModel.resetGame()
                    }
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
