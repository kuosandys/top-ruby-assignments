Objects:
1. Chess board to keep track of game pieces (serializable for save)
  - initializes with pieces in starting positions *test
  - display method: 8 x 8, letters along bottom, x for empty squares *test
  - check condition *test
  - mate condition *test

2. Player with its chess pieces as attributes
  - test

3. Chess pieces with positions attribute and movement rules for each:
  A. pawns, 8 each (white: \u2659, black: \u265F)
    - w: a-h2, b: a-h7
    - if haven't moved, can move 2 forward, else 1
    - takes a piece diagonally (check if occupied, if yes, allow the move)
    - enpassant: right after moving 2 squares, can take an adjacent pawn and move forward diagonally
    - can be promoted if it reaches the end of the board
  B. knights, 2 each (already made) (w: \u2658, b: \u265E)
    - w: b1, g1; b: b8, g8
  C. rooks, 2 each (w: \u2656, B: \u265C)
    - w: a1, h1; n: a8, h8
    - can move vertically or horizontally given all the spaces in between are empty
  D. bishops, 2 each (w: \u2657, b: \u265D)
    - w: c1, f1; b: c8, f8
    - can move diagonally given all the spaces in between are empty
  E. queens, 1 each (w: \u2655, b: \u265B)
    - w: e1; b: e8
    - can move vertically, horizontally, vertically
  F. kings, 1 each (w: \u2654, b: \u265A)
    - w: d1; b: d8
    - can move one square vertically, horizontally, vertically
    - can not move into check
  - for each: check if new location contains another piece, and if it does, take it

