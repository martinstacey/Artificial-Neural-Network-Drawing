Slider sl [] = new Slider [8];                                                             

void setupsl() {                                                                             
  sl[0] = new Slider(20, 30*(6), 150, 1, 89, gang, "fold angle", false);
  sl[1] = new Slider(20, 30*(7), 150, 1, 89, yang, "parallelogram angle", false);
  sl[2] = new Slider(20, 30*(9), 150, 45, 89, congang, "fold condition", false);
  sl[3] = new Slider(20, 30*(10), 150, 45, 89, conyang, "paral. condition", false);

  sl[4] = new Slider(width-210, 30*(16), 150, 2, 15, nSurf[0], "control PtsX", false);
  sl[5] = new Slider(width-210, 30*(17), 150, 2, 15, nSurf[1], "control PtsY", false);
  sl[6] = new Slider(width-210, 30*(18), 150, 1, 15, nSurf[2], "degree X", false);
  sl[7] = new Slider(width-210, 30*(19), 150, 1, 15, nSurf[3], "degree Y", false);


}
void drawsl() {
  for (int i=0; i<sl.length; i++) sl[i].display();
  gang = sl [0].value;
  yang = sl [1].value;
  congang = sl [2].value;
  conyang = sl [3].value;
  for (int i=0; i<nSurf.length; i++) nSurf[i] = int(sl[i+4].value);

}
void presssl() {
  for (int i=0; i<sl.length; i++) if (sl[i].isOver()) sl[i].lock = true;
}
void releasesl() {
  for (int i=0; i<sl.length; i++) sl[i].lock = false;
}
class Slider {
  float x, y, minX, maxX, value;
  float  minV, maxV, inV;
  boolean lock = false;
  boolean flt = false;
  int bsize=20; 
  String tittle;
  Slider (float posX, float posY, float maxX, float minV, float maxV, float inV, String tittle, boolean flt) {
    this.minX = posX;
    this.x=map(inV, minV, maxV, posX, minX+maxX);
    this.x=map(inV, minV, maxV, posX, minX+maxX);
    this.y=posY;
    this.maxX=maxX;
    this.minV=minV;
    this.maxV=maxV;
    this.inV=inV;
    this.tittle=tittle;
    this.flt = flt;
  }
  void display() {
    pushStyle();
    textSize(13);
    colorMode(RGB, 255);
    if (flt) value = map(x, minX, minX+maxX, minV, maxV);  
    else value = round(map(x, minX, minX+maxX, minV, maxV));      
    float mx = constrain(mouseX, minX, minX+maxX );     
    if (lock) x = mx;
    fill(230);
    rect(minX, y-2.5, x-minX, 5);  
    noFill();
    stroke(200);
    strokeWeight(1);
    rect(minX, y-2.5, maxX, 5);         
    pushMatrix();
    translate(0, 0, 1);
    fill(255);
    ellipse(x, y, bsize, bsize);              
    fill(100);  
    textAlign(LEFT, CENTER);
    text(tittle, minX, y-15);
    textAlign(RIGHT, CENTER);
    if (flt) text( nf(value, 0, 2), minX+maxX, y-15);
    else text( int(value), minX+maxX, y-15); 
    popMatrix();
    popStyle();
  }   
  boolean isOver() {
    return (x+(bsize/2) >= mouseX) && (mouseX >= x-(bsize/2)) && (y+(bsize/2) >= mouseY) && (mouseY >= y-(bsize/2));
  } 
  float flSlider() {
    return value;
  }
}