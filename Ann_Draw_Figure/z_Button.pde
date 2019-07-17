//boolean [] ctMapState = {false, false, false};
//Button ctMap [] = new Button [ctMapState.length];

int lbtOn =3;   //Initial State
Listbt lbt [] = new Listbt [5];
clickB nCellb [] = new clickB [nCells.length];


void setupbt() {
  //ctMap[0] = new Button(30, 30*12, 20, "noise control", ctMapState[0]);
  //ctMap[1] = new Button(30, 30*13, 20, "map control", ctMapState[1]);
  //ctMap[2] = new Button(30, 30*14, 20, "nurbs control", ctMapState[2]);

  nCellb[0] = new clickB(30, 160, 30*3, 20, 0, "cells X");
  nCellb[1] = new clickB(30, 160, 30*4, 20, 1, "cells Y");
  


  lbt[0] = new Listbt(30, 30*12, 20, " perlin movement", 0==lbtOn, 0);                           
  lbt[1] = new Listbt(30, 30*13, 20, " map control", 1==lbtOn, 1); 
  lbt[2] = new Listbt(30, 30*14, 20, " nurbs control", 2==lbtOn, 2);
  lbt[3] = new Listbt(30, 30*15, 20, " drawing control", 3==lbtOn, 3);
  lbt[4] = new Listbt(30, 30*16, 20, " lasercut", 4==lbtOn, 4);
}
void drawbt() {
  //for (int i=0; i<ctMap.length; i++)  ctMap[i].display();
  //for (int i=0; i<ctMap.length; i++)  ctMapState[i]=ctMap[i].onoff();
  for (int i=0; i<lbt.length; i++)  lbt[i].display();

  for (int i=0; i<nCellb.length; i++) nCellb[i].display(nCells[i]);
  for (int i=0; i<nCellb.length; i++) nCells[i]=nCellb[i].value;
  

  
}
void pressbt() {
  //for (int i=0; i<ctMap.length; i++)  ctMap[i].press();
  for (int i=0; i<nCellb.length; i++) nCellb[i].press();
  for (int i=0; i<lbt.length; i++)  lbt[i].press();

}

class Button {
  int x, y, bSize;
  String label;
  boolean state;
  Button(int x, int y, int bSize, String label, boolean state) {
    this.x = x;
    this.y = y;
    this.bSize = bSize;
    this.label = label;
    this.state = state;
  }
  void display() {
    pushStyle();
    textSize(13);
    colorMode(RGB, 255);
    textSize(13);
    stroke(200);
    textAlign(CENTER, CENTER);
    if (state) {
      stroke(200);
      fill(255);
      fill(230);
      ellipse(x, y, bSize, bSize);
    } else {
      fill(255);
      ellipse(x, y, bSize, bSize);
    } 
    fill(100);
    textAlign(LEFT, CENTER);
    text(label, x+bSize, y);
    popStyle();
  }
  void press() {
    if (mouseX > (x - bSize/2) && mouseX < (x + bSize/2)  &&mouseY > (y - bSize/2) && mouseY < (y + bSize/2)) state = !state;
  }
  boolean onoff() {
    return state;
  }
}

class clickB {
  int x, x2, y, bSize, xy;
  String label;
  boolean state1, state2;
  int value;
  float fc1;
  float fc2;
  clickB(int _x, int _x2, int _y, int _bSize, int _xy, String _label) {
    x = _x;
    x2=_x2;
    xy=_xy;
    y = _y;
    bSize = _bSize;
    label = _label;
  }
  void display(int _value) {
    value = _value;
    pushStyle();
    textSize(13);
    colorMode(RGB, 255);
    textSize(13);
    stroke(200);
    textAlign(CENTER, CENTER);
    stroke(200);
    fill(255);

    if (state1) fill(230);
    else  fill(255);
    line( x+(bSize/4), y-(bSize/4), x-(bSize/4), y);
    line( x+(bSize/4), y+(bSize/4), x-(bSize/4), y);
    ellipse(x, y, bSize, bSize);

    if (state2) fill(230);
    else  fill(255);
    line(x2-(bSize/4), y-(bSize/4), x2+(bSize/4), y);
    line(x2-(bSize/4), y+(bSize/4), x2+(bSize/4), y);
    ellipse(x2, y, bSize, bSize);
    fill(100);
    textAlign(LEFT, CENTER);
    text(label, x+bSize, y);
    textAlign(RIGHT, CENTER);
    if (xy==0) text(value+value-1, x2-bSize, y);
    if (xy==1) text(value, x2-bSize, y);
    popStyle();
    if (frameCount==fc1+10)state1=false;
    if (frameCount==fc2+10)state2=false;
  }
  void press() {
    if (mouseX > (x - bSize/2) && mouseX < (x + bSize/2)  &&mouseY > (y - bSize/2) && mouseY < (y + bSize/2)) {   
      state1=true;
      fc1 = frameCount;
      if (nCells[xy]>2) nCells[xy]--;
      setupvar();

      setupmap();
      setupmi();
      setupns();
    }
    if (mouseX > (x2 - bSize/2) && mouseX < (x2 + bSize/2)  &&mouseY > (y - bSize/2) && mouseY < (y + bSize/2)) {
      state2=true;
      nCells[xy]++;
      fc2 = frameCount;
      setupvar();

      setupmap();
      setupmi();
      setupns();
    }
  }
}

class Listbt {
  int x, y, bSize, num;
  String label;
  boolean state;
  Listbt(int _x, int _y, int _bSize, String _label, boolean _state, int _num) {
    x = _x;
    y = _y;
    bSize = _bSize;
    label = _label;
    state = _state;
    num = _num;
  }
  void display() {
    pushStyle();
    colorMode(RGB, 255);
    textSize(13);
    strokeWeight(1);
    stroke(200);
    pushMatrix();
    textAlign(CENTER, CENTER);
    if (lbtOn==num) {
      stroke(200);
      fill(230);
      ellipse(x, y, bSize, bSize);
      fill(100);

      text("", x, y);
    } else {
      fill(255);
      ellipse(x, y, bSize, bSize);
      fill(100);
      text("", x, y);
    } 
    textAlign(LEFT, CENTER);
    text(label, x+bSize, y);
    popStyle();
    popMatrix();
  }
  void press() {
    if (mouseX > (x - bSize/2) && mouseX < (x + bSize/2)  &&mouseY > (y - bSize/2) && mouseY < (y + bSize/2)) lbtOn = num;
  }
  boolean onoff() {
    return state;
  }
}