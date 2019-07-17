boolean [] clbState = {false,false};
ClickBut [] clb = new ClickBut [2];
void setupcb(){
    clb [0] = new ClickBut (width-240, 260, 20, "guess drawing", false);
    clb [1] = new ClickBut (width-240, 290, 20, "erase drawing", false);
}
void drawcb(){
    for (int i=0; i<clb.length;i++) clb[i].display();
    for (int i=0; i<clb.length;i++) clbState[i] = clb[i].onoff();
}
void presscb(){
    for (int i=0; i<clb.length;i++) clb[i].press();
}
class ClickBut {
  int x, y, bSize;
  String label;
  boolean state;
  ClickBut(int x, int y, int bSize, String label, boolean state) {
    this.x = x;
    this.y = y;
    this.bSize = bSize;
    this.label = label;
    this.state = state;
  }
  void display() {
    if (frameCount%30==0) state = false;
    pushStyle();
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