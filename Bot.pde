class Bot extends Player {
  public Bot(int startX, int startY, int startDir, int playerID) {
    super(startX, startY, startDir, playerID);
  }
  
  @Override
  public void move() {
    int[] justAhead = posInDir(x, y, dir);
    if(!testPosition(justAhead)) {
      saveSelf();
      super.move();
      return;
    }
    
    super.move();
  }
  
  int turn(boolean left, int currDir) {
    return mod(currDir + (left ? -1 : 1), 4);
  }
  
  void saveSelf() {
    int[] turnLeft = posInDir(x, y, turn(true, dir));
    boolean leftSafe = testPosition(turnLeft);
    
    int[] turnRight = posInDir(x, y, turn(false, dir));
    boolean rightSafe = testPosition(turnRight);
    
    if(leftSafe && rightSafe) {
      dir = heuristic();
      //dir = Math.random() < .5 ? turn(false, dir) : turn(true, dir);
      return;
    } else if(leftSafe) {
      dir = turn(true, dir);
      return;
    } else if(rightSafe) {
      dir = turn(false, dir);
      return;
    }
  }
  
  public void printCells(Cell[][] arr) {
    for(int i = 0; i < arr.length; i++) {
      for(int j = 0; j < arr[i].length; i++) {
        Cell c = arr[i][j];
        print(c.toString() + " ");
      }
      println();
    }
  }
  
  public int heuristic() {
    color[][] half1, half2;
    // half1 either top or left so if half1 > turn up/left
    // half2 either bottom or right so if half2 > turn down/right
    
    if(dir == R || dir == L) {
      half1 = new color[fWidth][y];
      for(int col = 0; col < fWidth; col++) {
        for(int row = 0; row < y; row++) {
          half1[col][row] = field[col][row].getColor();
        }
      }
      
      half2 = new color[fWidth][fHeight-y+1];
      for(int col = 0; col < fWidth; col++) {
        for (int row = y + 1; row < fHeight; row++) {
          half2[col][row-y-1] = field[col][row].getColor();
        }
      }
    } else {
      half1 = new color[x][fHeight];
      for(int row = 0; row < fHeight; row++) {
        for(int col = 0; col < x; col++) {
          half1[col][row] = field[col][row].getColor();
        }
      }
      
      half2 = new color[fWidth-x+1][fHeight];
      for(int row = 0; row < fHeight; row++) {
        for (int col = x + 1; col < fWidth; col++) {
          half2[col-x-1][row] = field[col][row].getColor();
        }
      }
    }
    
    int enemy1 = 0;
    int enemy2 = 0;
    color enemyColor = pID == 2 ? BLUE : RED;
    
    for(color[] row : half1) {
      for(color c : row) {
        enemy1 += c == enemyColor ? 1 : 0;
      }
    }
    
    for(int i = 0; i < half1.length; i++) {
      for(int j = 0; j < half1[i].length; j++) {
        if(half1[i][j] == enemyColor) {
          enemy1++;
        }
      }
    }
    
    for(int i = 0; i < half2.length; i++) {
      for(int j = 0; j < half2[i].length; j++) {
        if(half2[i][j] == enemyColor) {
          enemy2++;
        }
      }
    }
    
    if(enemy2 <= enemy1) {
      dir = (dir == R || dir == L) ? D : R;
    } else {
      dir = (dir == R || dir == L) ? U : L;
    }
    
    return dir;
  }
  
  public int[] posInDir(int x, int y, int dir) {
    int newX = x;
    int newY = y;
    if(dir == R || dir == L) {
      newX += dir == R ? 1 : -1;
    }
    else if(dir == U || dir == D) {
      newY += dir == D ? 1 : -1;
    }
    
    return new int[]{newX, newY};
  }
}
