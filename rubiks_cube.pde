/*
  Rubik's Cube
  Ben Tufano
*/

// Import Section
import peasy.*;
import java.util.ArrayList;

// Declaration
PeasyCam camera;
int[][][] cube = new int[6][3][3];
int[] tempRow = new int[3], lastAlgo = new int[16];
int scrambleCount = 20, lastAlgoLength;
String movementCodes[] = new String[18];
ArrayList<String> moveQueue = new ArrayList<String>();
ArrayList<String> curCommand = new ArrayList<String>();
boolean isCommanding = false, isAlgoing = false;

// Setup Method
void setup() {
  // General
  size(800, 800, P3D);
  background(0);
  rectMode(CENTER);
  
  // Initialize Cube
  for(int i = 0; i < cube.length; i++)
    for(int j = 0; j < cube[i].length; j++)
      for(int k = 0; k < cube[i][j].length; k++)
        cube[i][j][k] = i;
        
  // Initialize Movement Codes
  initCodes(movementCodes);
  
  // View Camera
  camera = new PeasyCam(this, 0, 0, 0, 150);
}

// Draw Method (Frame)
void draw() {
  // Reset Image
  background(0);
  
  // Do next Move
  if(moveQueue.size() > 0 && frameCount % 15 == 0)
    move(moveQueue.remove(0));

  // Draw Cube
  renderCube();
}

// Key Pressed
void keyPressed() {
  if(!isCommanding && !isAlgoing) {
    switch(key) {
      case 's': case 'S': randomScramble(scrambleCount); break;
      case 'c': case 'C': isCommanding = true; print("Command: "); curCommand.clear(); break;
      case 'a': case 'A': isAlgoing = true; print("Algorithm: "); curCommand.clear(); break;
      case 'u': case 'U':
        undoAlgo();
        println("Undoing last Algorithm...");
        break;
      case 'r': case 'R': 
        for(int i = 0; i < lastAlgoLength; i++) moveQueue.add(movementCodes[lastAlgo[i]]);
        println("Repeating last Algorithm...");
        break;
    }
  } else if(isCommanding) {
    if(key == 'c' || key == 'C') {
      String cmd = "";
      
      for(int i = 0; i < curCommand.size(); i++)
        cmd = cmd + curCommand.get(i);
      
      if(move(cmd)) {
        println(cmd);
      } else {
        println("Invalid");
      }
      
      isCommanding = false;
    } else {
      switch(key) {
        case 'r': case 'R': curCommand.add("R"); break;
        case 'l': case 'L': curCommand.add("L"); break;
        case 'f': case 'F': curCommand.add("F"); break;
        case 'b': case 'B': curCommand.add("B"); break;
        case 'u': case 'U': curCommand.add("U"); break;
        case 'd': case 'D': curCommand.add("D"); break;
        case 50: case 64: curCommand.add("2"); break;
        case '\'': case '\"': curCommand.add("\'"); break;
      }
    }
  } else if(isAlgoing) {
    if(key == 'a' || key == 'A') {
      String cmd = "";
      lastAlgo = new int[16];
      int c = 0;
      
      for(int i = 0; i < curCommand.size(); i++) {
        
        if(isLetter(curCommand.get(i)) && cmd.compareTo("") != 0) {
          if(getCmdInt(cmd) != -1) {
            print(cmd + " ");
            moveQueue.add(cmd);
            lastAlgo[c++] = getCmdInt(cmd);
            cmd = "";
          } else print("Invalid ");
        }
        
        if(c > 15) break;
        
        cmd = cmd + curCommand.get(i);
      }
      
      if(getCmdInt(cmd) != -1) {
        println(cmd + " ");
        moveQueue.add(cmd);
        lastAlgo[c++] = getCmdInt(cmd);
        cmd = "";
      } else println("Invalid ");
      
      lastAlgoLength = c;
      isAlgoing = false;
    } else {
      switch(key) {
        case 'r': case 'R': curCommand.add("R"); break;
        case 'l': case 'L': curCommand.add("L"); break;
        case 'f': case 'F': curCommand.add("F"); break;
        case 'b': case 'B': curCommand.add("B"); break;
        case 'u': case 'U': curCommand.add("U"); break;
        case 'd': case 'D': curCommand.add("D"); break;
        case 50: case 64: curCommand.add("2"); break;
        case '\'': case '\"': curCommand.add("\'"); break;
      }
    }
  }
}

// Scramble Function
void randomScramble(int turns) {
  // Header
  println("Scramble(" + turns + ")\n============================");
  int r;
  
  // Initialize Cube
  for(int i = 0; i < cube.length; i++)
    for(int j = 0; j < cube[i].length; j++)
      for(int k = 0; k < cube[i][j].length; k++)
        cube[i][j][k] = i;
  
  // Scramble Cube
  for(int i = 0; i < turns; i++) {
    moveQueue.add(movementCodes[r = floor(random(0, 18))]);
    println("Move: " + movementCodes[r]);
  }
}

// Movement Functions
void right(boolean prime) {
  if(prime) {
    tempRow[0] = cube[0][2][0];
    tempRow[1] = cube[0][2][1];
    tempRow[2] = cube[0][2][2];
    
    cube[0][2][0] = cube[2][2][0];
    cube[0][2][1] = cube[2][2][1];
    cube[0][2][2] = cube[2][2][2];
    
    cube[2][2][2] = cube[5][2][0];
    cube[2][2][1] = cube[5][2][1];
    cube[2][2][0] = cube[5][2][2];
    
    cube[5][2][0] = cube[4][2][0];
    cube[5][2][1] = cube[4][2][1];
    cube[5][2][2] = cube[4][2][2];
    
    cube[4][2][2] = tempRow[0];
    cube[4][2][1] = tempRow[1];
    cube[4][2][0] = tempRow[2];
    
    rotateFace(3, prime);
    rotateFace(3, prime);
  } else {
    tempRow[0] = cube[0][2][0];
    tempRow[1] = cube[0][2][1];
    tempRow[2] = cube[0][2][2];
    
    cube[0][2][2] = cube[4][2][0];
    cube[0][2][1] = cube[4][2][1];
    cube[0][2][0] = cube[4][2][2];
    
    cube[4][2][0] = cube[5][2][0];
    cube[4][2][1] = cube[5][2][1];
    cube[4][2][2] = cube[5][2][2];
    
    cube[5][2][2] = cube[2][2][0];
    cube[5][2][1] = cube[2][2][1];
    cube[5][2][0] = cube[2][2][2];
    
    cube[2][2][0] = tempRow[0];
    cube[2][2][1] = tempRow[1];
    cube[2][2][2] = tempRow[2];
    
    rotateFace(3, prime);
    rotateFace(3, prime);
  }
}

void left(boolean prime) {
  if(prime) {
    tempRow[0] = cube[0][0][0];
    tempRow[1] = cube[0][0][1];
    tempRow[2] = cube[0][0][2];
    
    cube[0][0][2] = cube[4][0][0];
    cube[0][0][1] = cube[4][0][1];
    cube[0][0][0] = cube[4][0][2];
    
    cube[4][0][0] = cube[5][0][0];
    cube[4][0][1] = cube[5][0][1];
    cube[4][0][2] = cube[5][0][2];
    
    cube[5][0][2] = cube[2][0][0];
    cube[5][0][1] = cube[2][0][1];
    cube[5][0][0] = cube[2][0][2];
    
    cube[2][0][0] = tempRow[0];
    cube[2][0][1] = tempRow[1];
    cube[2][0][2] = tempRow[2];
    
    rotateFace(1, !prime);
    rotateFace(1, !prime);
  } else {
    tempRow[0] = cube[0][0][0];
    tempRow[1] = cube[0][0][1];
    tempRow[2] = cube[0][0][2];
    
    cube[0][0][0] = cube[2][0][0];
    cube[0][0][1] = cube[2][0][1];
    cube[0][0][2] = cube[2][0][2];
    
    cube[2][0][2] = cube[5][0][0];
    cube[2][0][1] = cube[5][0][1];
    cube[2][0][0] = cube[5][0][2];
    
    cube[5][0][0] = cube[4][0][0];
    cube[5][0][1] = cube[4][0][1];
    cube[5][0][2] = cube[4][0][2];
    
    cube[4][0][2] = tempRow[0];
    cube[4][0][1] = tempRow[1];
    cube[4][0][0] = tempRow[2];
    
    rotateFace(1, !prime);
    rotateFace(1, !prime);
  }
}

void front(boolean prime) {
  if(prime) {
    tempRow[0] = cube[2][0][2];
    tempRow[1] = cube[2][1][2];
    tempRow[2] = cube[2][2][2];
    
    cube[2][0][2] = cube[3][0][0];
    cube[2][1][2] = cube[3][0][1];
    cube[2][2][2] = cube[3][0][2];
    
    cube[3][0][2] = cube[4][0][2];
    cube[3][0][1] = cube[4][1][2];
    cube[3][0][0] = cube[4][2][2];
    
    cube[4][0][2] = cube[1][0][0];
    cube[4][1][2] = cube[1][0][1];
    cube[4][2][2] = cube[1][0][2];
    
    cube[1][0][2] = tempRow[0];
    cube[1][0][1] = tempRow[1];
    cube[1][0][0] = tempRow[2];
    
    rotateFace(0, prime);
    rotateFace(0, prime);
  } else {
    tempRow[0] = cube[2][0][2];
    tempRow[1] = cube[2][1][2];
    tempRow[2] = cube[2][2][2];
    
    cube[2][2][2] = cube[1][0][0];
    cube[2][1][2] = cube[1][0][1];
    cube[2][0][2] = cube[1][0][2];
    
    cube[1][0][0] = cube[4][0][2];
    cube[1][0][1] = cube[4][1][2];
    cube[1][0][2] = cube[4][2][2];
    
    cube[4][2][2] = cube[3][0][0];
    cube[4][1][2] = cube[3][0][1];
    cube[4][0][2] = cube[3][0][2];
    
    cube[3][0][0] = tempRow[0];
    cube[3][0][1] = tempRow[1];
    cube[3][0][2] = tempRow[2];
    
    rotateFace(0, prime);
    rotateFace(0, prime);
  }
}

void back(boolean prime) {
  if(prime) {
    tempRow[0] = cube[2][0][0];
    tempRow[1] = cube[2][1][0];
    tempRow[2] = cube[2][2][0];
    
    cube[2][2][0] = cube[1][2][0];
    cube[2][1][0] = cube[1][2][1];
    cube[2][0][0] = cube[1][2][2];
    
    cube[1][2][0] = cube[4][0][0];
    cube[1][2][1] = cube[4][1][0];
    cube[1][2][2] = cube[4][2][0];
    
    cube[4][2][0] = cube[3][2][0];
    cube[4][1][0] = cube[3][2][1];
    cube[4][0][0] = cube[3][2][2];
    
    cube[3][2][0] = tempRow[0];
    cube[3][2][1] = tempRow[1];
    cube[3][2][2] = tempRow[2];
    
    rotateFace(5, !prime);
    rotateFace(5, !prime);
  } else {
    tempRow[0] = cube[2][0][0];
    tempRow[1] = cube[2][1][0];
    tempRow[2] = cube[2][2][0];
    
    cube[2][0][0] = cube[3][2][0];
    cube[2][1][0] = cube[3][2][1];
    cube[2][2][0] = cube[3][2][2];
    
    cube[3][2][2] = cube[4][0][0];
    cube[3][2][1] = cube[4][1][0];
    cube[3][2][0] = cube[4][2][0];
    
    cube[4][0][0] = cube[1][2][0];
    cube[4][1][0] = cube[1][2][1];
    cube[4][2][0] = cube[1][2][2];
    
    cube[1][2][2] = tempRow[0];
    cube[1][2][1] = tempRow[1];
    cube[1][2][0] = tempRow[2];
    
    rotateFace(5, !prime);
    rotateFace(5, !prime);
  }
}

void top(boolean prime) {
  if(prime) {
    tempRow[0] = cube[1][0][0];
    tempRow[1] = cube[1][1][0];
    tempRow[2] = cube[1][2][0];
    
    cube[1][0][0] = cube[5][0][0];
    cube[1][1][0] = cube[5][1][0];
    cube[1][2][0] = cube[5][2][0];
    
    cube[5][2][0] = cube[3][0][0];
    cube[5][1][0] = cube[3][1][0];
    cube[5][0][0] = cube[3][2][0];
    
    cube[3][0][0] = cube[0][0][0];
    cube[3][1][0] = cube[0][1][0];
    cube[3][2][0] = cube[0][2][0];
    
    cube[0][2][0] = tempRow[0];
    cube[0][1][0] = tempRow[1];
    cube[0][0][0] = tempRow[2];
    
    rotateFace(2, prime);
    rotateFace(2, prime);
  } else {
    tempRow[0] = cube[1][2][0];
    tempRow[1] = cube[1][1][0];
    tempRow[2] = cube[1][0][0];
    
    cube[1][0][0] = cube[0][2][0];
    cube[1][1][0] = cube[0][1][0];
    cube[1][2][0] = cube[0][0][0];
    
    cube[0][2][0] = cube[3][2][0];
    cube[0][1][0] = cube[3][1][0];
    cube[0][0][0] = cube[3][0][0];
    
    cube[3][0][0] = cube[5][2][0];
    cube[3][1][0] = cube[5][1][0];
    cube[3][2][0] = cube[5][0][0];
    
    cube[5][2][0] = tempRow[0];
    cube[5][1][0] = tempRow[1];
    cube[5][0][0] = tempRow[2];
    
    rotateFace(2, prime);
    rotateFace(2, prime);
  }
}

void bottom(boolean prime) {
  if(prime) {
    tempRow[0] = cube[0][0][2];
    tempRow[1] = cube[0][1][2];
    tempRow[2] = cube[0][2][2];
    
    cube[0][0][2] = cube[3][0][2];
    cube[0][1][2] = cube[3][1][2];
    cube[0][2][2] = cube[3][2][2];
    
    cube[3][2][2] = cube[5][0][2];
    cube[3][1][2] = cube[5][1][2];
    cube[3][0][2] = cube[5][2][2];
    
    cube[5][0][2] = cube[1][0][2];
    cube[5][1][2] = cube[1][1][2];
    cube[5][2][2] = cube[1][2][2];
    
    cube[1][2][2] = tempRow[0];
    cube[1][1][2] = tempRow[1];
    cube[1][0][2] = tempRow[2];
    
    rotateFace(4, !prime);
    rotateFace(4, !prime);
  } else {
    tempRow[0] = cube[0][0][2];
    tempRow[1] = cube[0][1][2];
    tempRow[2] = cube[0][2][2];
    
    cube[0][2][2] = cube[1][0][2];
    cube[0][1][2] = cube[1][1][2];
    cube[0][0][2] = cube[1][2][2];
    
    cube[1][0][2] = cube[5][0][2];
    cube[1][1][2] = cube[5][1][2];
    cube[1][2][2] = cube[5][2][2];
    
    cube[5][2][2] = cube[3][0][2];
    cube[5][1][2] = cube[3][1][2];
    cube[5][0][2] = cube[3][2][2];
    
    cube[3][0][2] = tempRow[0];
    cube[3][1][2] = tempRow[1];
    cube[3][2][2] = tempRow[2];
    
    rotateFace(4, !prime);
    rotateFace(4, !prime);
  }
}

void rotateFace(int f, boolean prime) {
  if(prime) {
    int temp = cube[f][0][0];
    cube[f][0][0] = cube[f][1][0];
    cube[f][1][0] = cube[f][2][0];
    cube[f][2][0] = cube[f][2][1];
    cube[f][2][1] = cube[f][2][2];
    cube[f][2][2] = cube[f][1][2];
    cube[f][1][2] = cube[f][0][2];
    cube[f][0][2] = cube[f][0][1];
    cube[f][0][1] = temp;
  } else {
    int temp = cube[f][0][0];
    cube[f][0][0] = cube[f][0][1];
    cube[f][0][1] = cube[f][0][2];
    cube[f][0][2] = cube[f][1][2];
    cube[f][1][2] = cube[f][2][2];
    cube[f][2][2] = cube[f][2][1];
    cube[f][2][1] = cube[f][2][0];
    cube[f][2][0] = cube[f][1][0];
    cube[f][1][0] = temp;
  }
}

// Get the Face Color
color getColor(int x) {
  switch(x) {
    case 0: return color(255);         // White
    case 1: return color(0, 0, 255);   // Blue
    case 2: return color(255, 0, 0);   // Red
    case 3: return color(0, 255, 0);   // Green
    case 4: return color(255, 100, 0); // Orange
    case 5: return color(255, 255, 0); // Yellow
  }
  return 0;
}

// Render the Rubik's Cube
void renderCube() {
  pushMatrix();
  translate(0, 0, 30);
  fill(getColor(cube[0][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[0][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[0][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[0][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[0][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[0][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[0][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[0][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[0][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(-30, 0, 0);
  rotateY(PI/2);
  fill(getColor(cube[1][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[1][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[1][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[1][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[1][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[1][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[1][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[1][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[1][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(0, -30, 0);
  rotateX(PI/2);
  fill(getColor(cube[2][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[2][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[2][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[2][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[2][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[2][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[2][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[2][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[2][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(30, 0, 0);
  rotateY(PI/2);
  fill(getColor(cube[3][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[3][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[3][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[3][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[3][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[3][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[3][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[3][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[3][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(0, 30, 0);
  rotateX(PI/2);
  fill(getColor(cube[4][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[4][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[4][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[4][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[4][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[4][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[4][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[4][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[4][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(0, 0, -30);
  fill(getColor(cube[5][0][0]));
  rect(-20, -20, 20, 20);
  fill(getColor(cube[5][1][0]));
  rect(0, -20, 20, 20);
  fill(getColor(cube[5][2][0]));
  rect(20, -20, 20, 20);
  fill(getColor(cube[5][0][1]));
  rect(-20, 0, 20, 20);
  fill(getColor(cube[5][1][1]));
  rect(0, 0, 20, 20);
  fill(getColor(cube[5][2][1]));
  rect(20, 0, 20, 20);
  fill(getColor(cube[5][0][2]));
  rect(-20, 20, 20, 20);
  fill(getColor(cube[5][1][2]));
  rect(0, 20, 20, 20);
  fill(getColor(cube[5][2][2]));
  rect(20, 20, 20, 20);
  popMatrix();
}

// Move Function
void move(int m) {
  switch(m) {
    case 0: right(false); break;
    case 1: right(true); break;
    case 2: right(false); right(false); break;
    case 3: left(false); break;
    case 4: left(true); break;
    case 5: left(false); left(false); break;
    case 6: front(false); break;
    case 7: front(true); break;
    case 8: front(false); front(false); break;
    case 9: back(false); break;
    case 10: back(true); break;
    case 11: back(false); back(false); break;
    case 12: top(false); break;
    case 13: top(true); break;
    case 14: top(false); top(false); break;
    case 15: bottom(false); break;
    case 16: bottom(true); break;
    case 17: bottom(false); bottom(false); break;
  }
}

boolean move(String m) {
  for(int i = 0; i < movementCodes.length; i++)
    if(movementCodes[i].compareTo(m) == 0) {
      move(i);
      return true;
    }
      
  return false;
}

// Movement Codes Initialization
void initCodes(String codes[]) {
  codes[0] = "R";
  codes[1] = "R\'";
  codes[2] = "R2";
  codes[3] = "L";
  codes[4] = "L\'";
  codes[5] = "L2";
  codes[6] = "F";
  codes[7] = "F\'";
  codes[8] = "F2";
  codes[9] = "B";
  codes[10] = "B\'";
  codes[11] = "B2";
  codes[12] = "U";
  codes[13] = "U\'";
  codes[14] = "U2";
  codes[15] = "D";
  codes[16] = "D\'";
  codes[17] = "D2";
}

void undoAlgo() {
  for(int i = lastAlgoLength - 1; i >= 0; i--) moveQueue.add(movementCodes[getOppositeCmd(lastAlgo[i])]);
}

int getOppositeCmd(int cmd) {
  int x = cmd % 3;
  
  if(x == 0) return cmd + 1;
  if(x == 1) return cmd - 1;
  return cmd;
}

int getCmdInt(String s) {
  for(int i = 0; i < movementCodes.length; i++)
    if(movementCodes[i].compareTo(s) == 0)
      return i;
  return -1;
}

boolean isLetter(String s) {
  if(s.charAt(0) > 64 && s.charAt(0) < 91) return true;
  else return false;
}
