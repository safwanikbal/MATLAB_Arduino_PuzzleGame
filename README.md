# Arduino Escape Room Puzzle – MATLAB Integration
This project is an interactive escape-room style puzzle implemented in MATLAB, integrating an Arduino UNO with a force sensor, light sensor, and LEDs. Players interact with the puzzle to unlock keys and progress through the game. 

## Notice: Partner Contribution
- Keyboard/movement controls (GetKeyboardInput file) provided by existing code from a project partner.
- Puzzle logic, LED's and force sensor integration written in MATLAB (SafwanPuzzle file) by Safwan Ikbal.
  
## Features 
-Puzzle logic written in MATLAB by Safwan Ikbal.
-Force and light sensor integration with Arduino UNO.
-Audio feedback via Arduino speaker.
-Key collection and door unlocking mechanics.
-Custom sprite sheet was used to create the map of the game, characters, and objects.

## Hardware and Software Requirements
-Arduino UNO
-Breadboard, jumper wires, resistors
-Force-sensitive resistor (FSR)
-LED(s)
-Speaker
-MATLAB

## Usage
Move the character with arrow keys, solve the puzzle by pressing the force sensor at the correct locations, collect keys, and unlock doors to progress. Finish the math problem displayed under the correct chest to unlock the key (combind with pressing the force sensor to unlock the chests. Failure to do the problem results in resetting the user's character to the start position.


