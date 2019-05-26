class Cell {
  color clr;
  float w, h;
  public Cell(float w, float h) {
    clr = DEFAULT;
    this.w = w;
    this. h = h;
  }
  
  public color getColor() {
    return clr;
  }
  
  public void setColor(color newColor) {
    clr = newColor;
  }
  
  public String toString() {
    if(clr == BLUE) {
      return "B";
    } else if(clr == RED) {
      return "R";
    } else return "D";
  }
}
