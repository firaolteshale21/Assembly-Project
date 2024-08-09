Snake Game in Assembly (EMU 8086)
Overview
This project is a simple Snake Game implemented in assembly language for the EMU 8086 emulator. The player controls a snake that moves around the screen, collects letters, and grows in length. The game ends when the snake collides with itself.

Features
Classic Snake gameplay mechanics
Collectible letters that increase the snake's length
Score tracking
Game over condition when the snake collides with itself
Requirements
EMU 8086 emulator (or any compatible 8086 assembly emulator)
Basic understanding of assembly language and emulators
Getting Started
1. Download the Code
You can clone this repository or download the source code directly:


Copy
git clone https://github.com/firaolteshale21/Assembly-Project.git
2. Open EMU 8086
Launch the EMU 8086 emulator on your computer.
Open the my Snake Game.asm file using the emulator.
3. Assemble the Code
Click on the Assemble button in EMU 8086 to compile the code.
Ensure there are no errors in the assembly process.
4. Run the Game
After assembling, click the Run button to start the game.
Use the following keys to control the snake:
W: Move Up
A: Move Left
S: Move Down
D: Move Right
ESC: Exit the game
5. Game Objective
Navigate the snake to collect letters (*) on the screen.
Each letter collected increases the length of the snake and your score.
Avoid colliding with the snake itself to continue playing.
6. Game Over
The game ends when the snake collides with itself.
A "Game Over" message will be displayed, and you can exit by pressing ESC.
Code Structure
Data Segment: Contains game data such as snake position, collected letters, and scores.
Stack Segment: Allocates stack space for the program.
Code Segment: The main game logic, including input handling, movement, collision detection, and score display.
Contributing
Feel free to fork the repository, make improvements, or report issues. Contributions are welcome!

License
This project is open-source and available for anyone to use or modify under the MIT License.

Acknowledgments
Thanks for checking out the Snake Game! Enjoy revisiting this classic game in assembly
