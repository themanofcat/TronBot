import processing.sound.SoundFile;

Cell[][] field;
final color DEFAULT = color(255);
final color RED = color(255, 0, 0);
final color BLUE = color(0, 0, 255);
int fWidth, fHeight;

Player p1, p2;
Player loser;

boolean start = false;
boolean lost = false;

float secCount;

final int R = 0;
final int D = 1;
final int L = 2;
final int U = 3;

SoundFile bgMusic;

void setup() {
  fullScreen();
  background(255);
  stroke(DEFAULT);
  frameRate(60);
  
  fWidth = 151;
  fHeight = 91;
  
  field = new Cell[fWidth][fHeight];
  for(int i = 0; i < fWidth; i++) {
    for(int j = 0; j < fHeight; j++) {
      field[i][j] = new Cell(width/fWidth, height/fHeight);
    }
  }
  
  p1 = new Player(10, fHeight/2 + 1, R, 1);
  p2 = new Bot(fWidth - 10, fHeight/2 + 1, L, 2);
  loser = null;
  
  field[p1.x][p1.y].setColor(BLUE);
  field[p2.x][p2.y].setColor(RED);
  
  bgMusic = new SoundFile(this, "tronbgmusic.wav");
}

void draw() {
  
  if(!lost) {
    fill(DEFAULT);
    for(int i = 0; i < fWidth; i++) {
      for(int j = 0; j < fHeight; j++) {
        Cell c = field[i][j];
        fill(c.getColor());
        stroke(c.getColor());
        rect(i*width/fWidth, j*height/fHeight, width/fWidth, height/fHeight);
      }
    }
  
    if(!start) {
      fill(50);
      rect(0, 0, 450, 100);
      fill(255);
      textSize(16);
      text("WASD to move\nDon't hit yourself, don't hit the bot, don't hit the wall\nClick the screen, then hit any key to start", 10, 25);
    }
  
    if(start) {
    
      try { 
        p1.move();
        field[p1.x][p1.y].setColor(BLUE);
      }
      catch(Exception e) {
        lose(p1);
      }
      try { 
        p2.move();
        field[p2.x][p2.y].setColor(RED);
      }
      catch(Exception e) {
        lose(p2);
      }
    }
  } else {
    lose(loser);
    if(millis() - secCount >= 3000) {
      System.exit(0);
    }
  }
}

public int mod(int a, int b) {
  if(a < 0) {
    return b+(a%b);
  }
  else return a%b;
}

void keyPressed() {
  if(!start) {
    start = true;
    bgMusic.play();
  }
  else if(key == ' ') {
    start = !start;
  }
  
  if(!(p1 instanceof Bot)){
    switch(key) {
      case 'w': p1.setDir(U); break;
      case 'a': p1.setDir(L); break;
      case 's': p1.setDir(D); break;
      case 'd': p1.setDir(R); break;
    }
  }
  
  if(!(p2 instanceof Bot)) {
    switch(keyCode) {
      case UP: p2.setDir(U); break;
      case LEFT: p2.setDir(L); break;
      case DOWN: p2.setDir(D); break;
      case RIGHT: p2.setDir(R); break;
    }
  }
}

void lose(Player p) {
  if(bgMusic.isPlaying()) {
    bgMusic.pause();
  }
  
  if(!lost) {
    secCount = millis();
  }
  
  fill(0);
  stroke(0);
  rect(0, 0, width, height);
  
  fill(255);
  textSize(64);
  String text = (p instanceof Bot) ? "Congrats! You beat the bot" : "Player " + p.pID + " loses";
  if((p == p1 && p2 instanceof Bot) || (p == p2 && p1 instanceof Bot)) {
    text = "The robots win again";
  }
  text(text, width/2 - textWidth(text)/2, height/2);
  noLoop();
  
  lost = true;
  loser = p;
}
