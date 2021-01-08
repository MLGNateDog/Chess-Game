//black

import processing.net.*;

Client myClient;

color pink = #ED16B8;
color lblue = #16E4ED;
color gold = #CEA61F;
color grey = #B7B7B7;
color purp = #404B83;
color cream = #E8D9A6;
color walnut  = #553A26;
color teal = #386457;
color lblue2 = #7FA4BC;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick, yourTurn, canTakeBack, enemyTakeBack, opponentTakeBack, pawnPromotion, opponentPromotion;
boolean ukey, qkey, kkey, bkey, rkey;
int row1, col1, row2, col2;
int light, dark;
float rn;
String yourPieces = "PRBNQK";
char lastPieceTaken, enemyLastPieceTaken;


char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);

  myClient = new Client(this, "127.0.0.1", 1234);

  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");

  yourTurn = false;
  canTakeBack = false;
  ukey = false;
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();
  highlightedSquare();
  takeBack();
  promotion();
  enemyPromotion();
}

void receiveMove() {
  if (myClient.available() > 0) {
    String incoming = myClient.readString();
    int r1 = int(incoming.substring(0, 1));
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    int id = int(incoming.substring(8, 9));
    int pp = int(incoming.substring(10, 11));

    if (id == 0) {
      enemyLastPieceTaken = grid[r2][c2];
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      canTakeBack = false;
      firstClick = true;
    } else if (id == 1) {
      yourTurn = false;
      canTakeBack = false;
      println(grid[r2][c2]);
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = enemyLastPieceTaken;
    }

    if (id == 0 && pp == 0) {
      yourTurn = true;
    }

    if (pp == 1) {
      yourTurn = false;
      opponentPromotion = true;
    }

    if (pp == 2) {
      yourTurn = true;
      grid[r2][c2] = 'q';
      opponentPromotion = false;
    }

    if (pp == 3) {
      yourTurn = true;
      grid[r2][c2] = 'n';
      opponentPromotion = false;
    }

    if (pp == 4) {
      yourTurn = true;
      grid[r2][c2] = 'b';
      opponentPromotion = false;
    }

    if (pp == 5) {
      yourTurn = true;
      grid[r2][c2] = 'r';
      opponentPromotion = false;
    }
  }
}

void drawBoard() {
  noStroke();
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 

      if (rn < 0.20) { //gold & grey
        if ( (r%2) == (c%2) ) {
          light = grey;
        } else { 
          dark = gold;
        }
        rect(c*100, r*100, 100, 100);
      } else if (rn > 0.20 && rn < 0.4) { //walnut & cream
        if ( (r%2) == (c%2) ) {
          light = cream;
        } else { 
          dark = walnut;
        }
        rect(c*100, r*100, 100, 100);
      } else if (rn > 0.4 && rn < 0.6) { //pink & lblue
        if ( (r%2) == (c%2) ) {
          light = lblue;
        } else { 
          dark = pink;
        }
        rect(c*100, r*100, 100, 100);
      } else if (rn > 0.6 && rn < 0.8) { //grey & purp
        if ( (r%2) == (c%2) ) {
          light = grey;
        } else { 
          dark = purp;
        }
        rect(c*100, r*100, 100, 100);
      } else {
        if ( (r%2) == (c%2) ) {
          light = lblue2;
        } else { 
          dark = teal;
        }
        rect(c*100, r*100, 100, 100);
      }

      if ( (r%2) == (c%2) ) {
        fill(light);
      } else { 
        fill(dark);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void highlightedSquare() {
  if (firstClick == false && yourTurn) {
    noFill();
    stroke(#A21540);
    strokeWeight(5);
    rect(col1*100, row1*100, 100, 100);
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void takeBack() {
  if (canTakeBack && yourTurn == false) {
    if (ukey) {
      grid[row1][col1] = grid[row2][col2];
      grid[row2][col2] = lastPieceTaken;
      myClient.write(row2 + "," + col2 + "," + row1 + "," + col1 + "," + 1 + "," + 0);

      ukey = false;
      canTakeBack = false;
      yourTurn = true;
    }
  }
}

void enemyPromotion() {
  if (opponentPromotion) {
    yourTurn = false;
    fill(light);
    stroke(dark);
    strokeWeight(5);
    rect(0, width/4, width, 400);
    textSize(30);
    textAlign(CENTER);
    fill(dark);
    text("Please wait, your opponent is promoting their pawn", width/2, height/2 - 50);
  }
}

void promotion() {
  if (pawnPromotion) {
    canTakeBack = false;
    fill(light);
    stroke(dark);
    strokeWeight(5);
    rect(0, width/4, width, 400);
    textSize(30);
    textAlign(CENTER);
    fill(dark);
    text("Congradulations! You can now promote your pawn!", width/2, height/2 - 50);
    text("Q = Queen, K = Knight, B = Bishop, R = Rook", width/2, height/2 + 50);

    if (qkey) {
      grid[row2][col2] = 'Q';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 2);
      pawnPromotion = false;
      canTakeBack = false;
      qkey = false;
    }

    if (kkey) {
      grid[row2][col2] = 'N';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 3);
      pawnPromotion = false;
      canTakeBack = false;
      kkey = false;
    }

    if (bkey) {
      grid[row2][col2] = 'B';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 4);
      pawnPromotion = false;
      canTakeBack = false;
      bkey = false;
    }

    if (rkey) {
      grid[row2][col2] = 'R';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 5);
      pawnPromotion = false;
      canTakeBack = false;
      rkey = false;
    }


    println("PROMO!!!!!");
    println("row2 = " + row2);
    println("col2 = " + col2);
  }
}

void mouseReleased() {
  if (yourTurn) {
    if (firstClick) {
      row1 = mouseY/100;
      col1 = mouseX/100;
      if ("PRBNQK".contains(""+grid[row1][col1])) {
        firstClick = false;
      }
    } else {
      row2 = mouseY/100;
      col2 = mouseX/100;
      if (!(row2 == row1 && col2 == col1)) {
        lastPieceTaken = grid[row2][col2];
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        if (grid[row2][col2] == 'P' && row2 == 7) {
          pawnPromotion = true;

          myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 1);
        } else {
          myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + 0 + "," + 0);
        }
        firstClick = true;
        yourTurn = false;
        canTakeBack = true;
      }
    }
  }
}

void keyPressed() {
  if (key == 'u' || key == 'U') ukey = true;
  if (key == 'q' || key == 'Q') qkey = true;
  if (key == 'k' || key == 'K') kkey = true;
  if (key == 'b' || key == 'B') bkey = true;
  if (key == 'r' || key == 'R') rkey = true;
}
