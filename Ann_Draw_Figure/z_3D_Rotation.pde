RotSlider rs []= new RotSlider [2];
void setuprs() {
  rs[0] = new RotSlider();
  rs[1] = new RotSlider();
  rs[0].setuprotsl(rsorigin,rssize);
  rs[1].setuprotsl(rsorigin,rssize);
}
void drawrs() {
  rs[0].display();
  rs[1].display();
  rsrot[0] = rs[0].pos();
  rsrot[1] = rs[1].pos();
  
}
void actpsl( PVector origin, PVector size,int rotnum) {
  translate(origin.x+(size.x/2), origin.y+(size.y/2), origin.z+(size.z/2));
  rotateX(radians(rsrot[rotnum][0]));  //
  rotateY(radians(rsrot[rotnum][1])); //
  rotateZ(radians(rsrot[rotnum][2])); //
  translate(-origin.x-(size.x/2), -origin.y-(size.y/2), -origin.z-(size.z/2));
}
void pressrs() {
  rs[0].press();
    rs[1].press();
}
void releasers() {
  rs[0].release();
  rs[1].release();
}
class RotSlider {
  float sCell, sSpace, value;
  PVector posCell, posCell2, posSpace, posLineXY, mouse;
  PVector posLineZ;
  boolean select=false;
  boolean select2=false;
  PVector origin,size;

  RotSlider() {
  }
  void setuprotsl(PVector _origin,PVector _size) {
    origin = _origin;
    size = _size;
    posCell =  new PVector (origin.x+(size.x/4),origin.y);
    posSpace =origin;
    sCell = 15; 
    sSpace = size.x;
    posCell2 =  new PVector(origin.x-(35), origin.y-(60));
  }
  void display() {
    if (select) posCell = new PVector (mouseX, mouseY);
    posLineXY= PVector.sub(posCell, posSpace);
    posLineXY.limit(sSpace/2);

    if (select2) posCell2 = new PVector (mouseX, constrain(mouseY, 0, posSpace.y)); 
    posLineZ= PVector.sub(posCell2, posSpace);
    posLineZ.setMag(sSpace/2+sCell);
    fill(100);
    textSize(13);
    textAlign(RIGHT);
    text("x:"+int(map(posLineXY.x, 0, sSpace/2, 0, 90)), posSpace.x+sSpace/2+40, posSpace.y+sSpace/2-30);
    text("y:"+int(map(posLineXY.y, 0, sSpace/2, 0, 90)), posSpace.x+sSpace/2+40, posSpace.y+sSpace/2-15);
    text("z:"+int(map(posLineZ.x, 0, sSpace/2+sCell, 0, 90)), posSpace.x+sSpace/2+40, posSpace.y+sSpace/2);
    fill(255);
    stroke(200);
    ellipse(posSpace.x, posSpace.y, sSpace+sCell, sSpace+sCell);
    line(posSpace.x, posSpace.y, posSpace.x+posLineXY.x, posSpace.y+posLineXY.y);
    if (select) fill(235);
    else fill(255);
    ellipse(posSpace.x+posLineXY.x, posSpace.y+posLineXY.y, sCell, sCell);
    if (select2) fill(235);
    else fill(255);
    ellipse(posSpace.x+posLineZ.x, posSpace.y+posLineZ.y, sCell, sCell);
  }
  void press() {
    if (mouseX>posCell.x-sCell&&mouseX<posCell.x+sCell&&mouseY>posCell.y-sCell&&mouseY<posCell.y+sCell) select = true;
    if (mouseX>posCell2.x-sCell&&mouseX<posCell2.x+sCell&&mouseY>posCell2.y-sCell&&mouseY<posCell2.y+sCell) select2 = true;
  }
  void release() {
    if (mouseX>posCell.x-sCell&&mouseX<posCell.x+sCell&&mouseY>posCell.y-sCell&&mouseY<posCell.y+sCell) {
      select = false;
      posCell.x= posSpace.x+posLineXY.x;
      posCell.y= posSpace.y+posLineXY.y;
    }
    if (mouseX>posCell2.x-sCell&&mouseX<posCell2.x+sCell&&mouseY>posCell2.y-sCell&&mouseY<posCell2.y+sCell) {
      select2 = false;
      posCell2.x=posSpace.x+posLineZ.x;
      posCell2.y=posSpace.y+posLineZ.y;
    }
  }
  float [] pos (){
    float [] p = new float [3];
    p[0] = int(map(posLineXY.x, 0, sSpace/2, 0, 90));
    p[1] = int(map(posLineXY.y, 0, sSpace/2, 0, 90));
    p[2] = int(map(posLineZ.x, 0, sSpace/2+sCell, 0, 90));
    return p;
    
  }
}