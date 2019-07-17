Drawit dr;
byte [] bytesOutDrawing;

void setupdr() {
  dr =  new Drawit (nPixelsX, nPixelsY, sPixelsX, sPixelsY, nndrorigin, strokeLin, strokePixel);
}
void drawdr() {
  if (clbState[0]) {
    loaddraw();
    testnnd();
  }
  if (clbState[1]) setupdr();
  dr.display();
  dr.displayline();
  if (mousePressed) if (mouseButton == LEFT)  dr.select();
  if (mousePressed) if (mouseButton == RIGHT) dr.unselect();
  bytesOutDrawing= dr.getBytes();
}

class Drawit {
  int nPixX, nPixY;
  float sPixX, sPixY;
  PVector [][] pos;
  boolean [][] onoff;
  boolean inside;
  PVector origin, size;
  ArrayList<PVector> posLine = new ArrayList<PVector>();
  ArrayList<PVector> pposLine = new ArrayList<PVector>();
  ArrayList<PVector> posDelete = new ArrayList<PVector>();
  ArrayList<PVector> pposDelete = new ArrayList<PVector>();

  float stLine, stPix;

  Drawit(int _nPixX, int _nPixY, float _sPixX, float _sPixY, PVector _origin, float _stLine, float _stPix) {
    nPixX = _nPixX;
    nPixY = _nPixY;
    sPixX = _sPixX;
    sPixY = _sPixY;
    stLine= _stLine;
    stPix=_stPix;
    pos = new PVector [nPixX][nPixY];
    onoff =  new boolean [nPixX][nPixY];
    origin =  _origin;
    size = new PVector (nPixX*sPixX, nPixY*sPixY);
  }
  void display() {
    for (int x=0; x<nPixX; x++)for (int y=0; y<nPixY; y++) {
      pos[x][y] =  new PVector (x*sPixX, y*sPixY);
      pos[x][y].add(origin);
      if (onoff[x][y]) fill (255);                                                       
      else fill(255);
      //stroke(200);
      noStroke();
      rect(pos[x][y].x, pos[x][y].y, sPixX, sPixY);
    }
    stroke(0);
    noFill();
    rect(origin.x, origin.y, size.x, size.y);
  }
  void displayline() {
    if (mouseX>origin.x&&mouseX<origin.x+size.x&&mouseY>origin.y&&mouseY<origin.y+size.y) inside = true;
    else inside =false;
    if (inside) if (mousePressed) {
      posLine.add(new PVector (mouseX, mouseY));
      pposLine.add(new PVector (pmouseX, pmouseY));
    }
    strokeWeight(stLine);
    stroke(0);
    for (int i=0; i<posLine.size(); i++) {
      line(posLine.get(i).x, posLine.get(i).y, pposLine.get(i).x, pposLine.get(i).y);
    }
    if (inside) if (mousePressed) if (mouseButton == RIGHT) {
      posDelete.add(new PVector (mouseX, mouseY));
      pposDelete.add(new PVector (pmouseX, pmouseY));
    }
    strokeWeight(stLine*4);
    stroke(255);
    for (int i=0; i<posDelete.size(); i++) {
      line(posDelete.get(i).x, posDelete.get(i).y, pposDelete.get(i).x, pposDelete.get(i).y);
    }
    strokeWeight(1);
  }
  void select() {
    for (int x=0; x<nPixX; x++)for (int y=0; y<nPixY; y++) {
      if   (mouseX>pos[x][y].x-(sPixX*stPix/2.0)&&mouseX<pos[x][y].x+(sPixX*stPix/2.0)) {
        if (mouseY>pos[x][y].y-(sPixY*stPix/2.0)&&mouseY<pos[x][y].y+(sPixY*stPix/2.0)) {
          onoff[x][y] = true;
        }
      }
    }
  }
  void unselect() {
    for (int x=0; x<nPixX; x++)for (int y=0; y<nPixY; y++) {
      if   (mouseX>pos[x][y].x-(sPixX*stPix/2.0)&&mouseX<pos[x][y].x+(sPixX*stPix/2.0)) {
        if (mouseY>pos[x][y].y-(sPixY*stPix/2.0)&&mouseY<pos[x][y].y+(sPixY*stPix/2.0)) {
          onoff[x][y] = false;
        }
      }
    }
  }
  byte [] getBytes() {
    byte [] r= new byte [nPixX*nPixY];
    for (int x=0; x<nPixX; x++)for (int y=0; y<nPixY; y++) {
      if (onoff[x][y]) r[x+(nPixX*y)] = byte(((2*(0.5-(1.0/255.0)))+1.0)*128.0);
      else  r[x+(nPixX*y)] = byte(0);
    }
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    fill(255);
    byte [] r2= new byte [(nPixX*nPixY)+16];
    for (int i=0; i<16; i++) r2[i]= 0; 
    for (int i=0; i<r2.length-16; i++) r2[i+16]= r[i]; 
    return r2;
  }
}