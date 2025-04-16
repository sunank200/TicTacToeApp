# Tic Tac Toe

**Author:** Ankit Chaurasia ([sunank200](https://github.com/sunank200))  
**Website:** [https://ankitchaurasia.info/](https://ankitchaurasia.info/)

**My First Swift Project**

This is a simple Tic Tac Toe game built with SwiftUI for iOS. It supports:
- **Single Player** mode against a smart AI (using the Minimax algorithm)
- **Local Multiplayer** mode for two players on the same device

## Features
- 3×3 grid board with tap interactions
- Turn indication (X and O)
- Win and draw detection
- Animations for piece placement and win highlighting
- Restart the game at any time

## Requirements
- Xcode 13 or later
- iOS 15.0 or later SDK

## Building and Running
1. **Clone** this repository:
   ```bash
   git clone <repository-url>
   ```
2. **Open** the project:
   - Navigate to the `TicTacToe` folder
   - Open `TicTacToe.xcodeproj` in Xcode
3. **Select** your target device or Simulator
4. **Build & Run**:
   - Press **⌘R** or go to **Product → Run**

## Screenshot
![Game Screenshot](/Users/sunank200/Desktop/tictaktoe.png)

## AI Logic (Minimax Algorithm)
The Single Player mode uses a Minimax algorithm to play optimally:
1. **Minimax Search**: Recursively explore all possible moves
2. **Scoring**:
   - AI win: **+10 − depth**
   - Human win: **depth − 10**
   - Draw: **0**
3. **Choice**: AI selects the move with the highest score, ensuring it never loses.

## Contributing
Contributions are welcome! To contribute:
1. **Fork** the repository
2. **Create** a new branch:
   ```bash
   git checkout -b feature/my-feature
   ```
3. **Commit** your changes:
   ```bash
   git commit -m "Add awesome feature"
   ```
4. **Push** to your fork:
   ```bash
   git push origin feature/my-feature
   ```
5. **Open** a Pull Request

Please follow Swift style guidelines, add tests for new functionality, and update this README if you introduce new features.
  
## Static Analysis and Pre-commit Hooks

We use SwiftFormat and SwiftLint to format and lint Swift code, enforced via pre-commit hooks.

To set up the hooks:
1. Install Homebrew (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. Install SwiftFormat and SwiftLint:
   ```bash
   brew install swiftformat swiftlint
   ```
3. Install pre-commit:
   ```bash
   pip install pre-commit
   ```
4. Enable Git hooks:
   ```bash
   pre-commit install
   ```
5. To run checks on all files:
   ```bash
   pre-commit run --all-files
   ```

The hooks will run SwiftFormat (in lint mode) and SwiftLint on staged Swift files before each commit.

## License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.  
  
---
Happy coding! 🎉