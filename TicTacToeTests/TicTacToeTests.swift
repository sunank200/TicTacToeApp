//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Ankit Chaurasia on 17/04/25.
//

@testable import TicTacToe
import XCTest

final class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!

    override func setUp() {
        super.setUp()
        viewModel = GameViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.board, Array(repeating: .none, count: 9))
        XCTAssertEqual(viewModel.currentPlayer, .x)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.winningPattern.isEmpty)
        XCTAssertEqual(viewModel.alertMessage, "")
    }

    func testMultiplayerWin() {
        viewModel.gameMode = .multiplayer
        viewModel.resetGame()
        viewModel.makeMove(at: 0) // X
        viewModel.makeMove(at: 3) // O
        viewModel.makeMove(at: 1) // X
        viewModel.makeMove(at: 4) // O
        viewModel.makeMove(at: 2) // X wins
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "X wins!")
        XCTAssertEqual(viewModel.winningPattern, [0, 1, 2])
    }

    func testDraw() {
        viewModel.gameMode = .multiplayer
        viewModel.resetGame()
        let moves = [0, 1, 2, 4, 3, 5, 7, 6, 8]
        for move in moves {
            viewModel.makeMove(at: move)
        }
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "Draw!")
    }

    func testResetGame() {
        viewModel.showAlert = true
        viewModel.alertMessage = "Something"
        viewModel.winningPattern = [0]
        viewModel.currentPlayer = .o
        viewModel.board = [.x, .o, .x, .o, .x, .o, .x, .o, .x]
        viewModel.resetGame()
        XCTAssertEqual(viewModel.board, Array(repeating: .none, count: 9))
        XCTAssertTrue(viewModel.winningPattern.isEmpty)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "")
        XCTAssertEqual(viewModel.currentPlayer, .x)
    }
}
