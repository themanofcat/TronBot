class Player {
  int x, y, dir;
  int pID;
  public Player(int startX, int startY, int startDir, int playerID) {
    x = startX;
    y = startY;
    dir = startDir;
    pID = playerID;
  }
  
  public boolean notOpposed(int d1, int d2) {
    return !(d1 == U && d2 == D) && !(d1 == R && d2 == L) && !(d1 == D && d2 == U) && !(d1 == L && d2 == R);
  }
  
  public void setDir(int newDir) {
    if(notOpposed(dir, newDir)) {
      dir = newDir;
    }
  }
  
  public void move() {
    switch(dir){
      case U: y--; break;
      case L: x--; break;
      case D: y++; break;
      case R: x++; break;
    }
    
    if(!testPosition(x, y)) {
      throw(new ArrayIndexOutOfBoundsException());
    }
  }
  
  public boolean testPosition(int[] pos) {
    return testPosition(pos[0], pos[1]);
  }
  
  public boolean testPosition(int x, int y) {
    if(x >= fWidth || x < 0) {
      return false;
    }
    if(y >= fHeight || y < 0) {
      return false;
    }
    if(field[x][y].getColor() != DEFAULT) {
      return false;
    }
    
    return true;
  }
}
