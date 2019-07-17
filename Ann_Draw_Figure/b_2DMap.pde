MapMiura map= new MapMiura();                                                             //
void setupmap() {
  map.setCells(nCells[0], nCells[1], mapscale);
  map.calcpos( a1a2, b1b2, yang, mporigin);
}
void drawmap() {
  map.calcpos( a1a2, b1b2, yang, mporigin);
  if (lbtOn==1) a1a2=map.moveallAs(a1a2);
  if (lbtOn==1) b1b2=map.moveallBs(b1b2);
  map.display();
  if (lbtOn==4) map.displayhinges();
}
void pressmap() {
  map.move();
}
void releasemap() {
  map.release();
}
class MapMiura {
  int nCellsX, nCellsY;
  int nPointsU, nPointsV;
  float sPoint;
  PVector [][]origin;
  PVector [][][][] pos;
  PVector [][][] tpos;
  boolean [][][][] move;
  float sc;

  MapMiura () {
  }
  void setCells(int _nCellsX, int _nCellsY, float _sc) {
    nCellsX = _nCellsX;
    nCellsY=_nCellsY;
    nPointsU= 3;
    nPointsV= 3;
    origin = new PVector [nCellsX][nCellsY];
    pos = new PVector [nCellsX][nCellsY][nPointsU][nPointsV];
    tpos = new PVector [nCellsX][nCellsY][nPointsV];
    move = new boolean [nCellsX][nCellsY][nPointsU][nPointsV];
    sPoint=7;
    sc=_sc;
  }
  void calcpos(float [][][]lista, float [][]listb, float listy, PVector _origin1) {
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      pos[x][y][0][0]=new PVector (0, 0, 0);     
      pos[x][y][1][0]=new  PVector (0, listb[x][0], 0);
      pos[x][y][1][0].rotate(radians(-listy));        
      pos[x][y][2][0]= new PVector(0, listb[x][1], 0);
      pos[x][y][2][0].rotate(radians(listy-180));
      pos[x][y][2][0].add(pos[x][y][1][0]);    
      pos[x][y][0][1]=new PVector (0, lista[x][y][0], 0);
      pos[x][y][0][2]=new PVector(0, lista[x][y][0]+lista[x][y][1], 0);
      pos[x][y][1][1]=PVector.add(pos[x][y][0][1], pos[x][y][1][0]);
      pos[x][y][1][2]=PVector.add(pos[x][y][1][0], pos[x][y][0][2]);
      pos[x][y][2][1]= PVector.add(pos[x][y][2][0], pos[x][y][0][1]);
      pos[x][y][2][2]= PVector.add(pos[x][y][2][0], pos[x][y][0][2]);     
      if  (x==0&&y==0) origin[0][0]=_origin1;
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++) pos[x][y][u][v].mult(sc);
      if (y==0&&x>0) {
        PVector midLength = new PVector(((pos[x-1][y][2][0].x-pos[x-1][y][0][0].x)+(pos[x][y][2][0].x-pos[x][y][0][0].x))/2, 0);               //Adding length to make transition points
        origin[x][y] =  PVector.add(pos[x-1][y][2][0], midLength);
      }
      if (y>0) origin[x][y] =  pos[x][y-1][0][2];
      for (int u=0; u<nPointsU; u++) {
        for (int v=0; v<nPointsV; v++) {
          pos[x][y][u][v].add(origin[x][y]);
        }
      }
      if (x!=0) {
        for (int v=0; v<nPointsV; v++) {
          tpos [x][y][v] = new PVector((pos[x][y][0][v].x+pos[x-1][y][2][v].x)/2, (pos[x][y][1][v].y+pos[x-1][y][1][v].y)/2, (pos[x][y][1][v].z+pos[x-1][y][1][v].z)/2);
        }
      }
    }
  }
  float [][][] moveallAs(float [][][]varinb) {
    float [][][] varout = varinb; 
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++) pos[x][y][u][v].sub(origin[x][y]);
      PVector mouse = PVector.sub(new PVector (mouseX, mouseY), origin[x][y]);
      if (move[x][y][0][1]) {
        varout[x][y][0]+=mouse.y-pos[x][y][0][1].y ;
        if (varout[x][y][0]<sPoint) varout[x][y][0]=sPoint;
      }
      if (move[x][y][0][2]) {
        varout[x][y][1]+=mouse.y-pos[x][y][0][2].y ;
        if (varout[x][y][1]<sPoint) varout[x][y][1]=sPoint;
      }
      for (int u=0; u<nPointsU; u++)for (int v=0; v<nPointsV; v++) pos[x][y][u][v].add(origin[x][y]);
    }
    return varout;
  }
  float [][] moveallBs(float [][]varinb) {
    float [][] varout = varinb; 
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++) pos[x][y][u][v].sub(origin[x][y]);
      PVector mouse = PVector.sub(new PVector (mouseX, mouseY), origin[x][y]);
      if (move[x][y][1][0]) {
        varout[x][0]+=(mouse.x-pos[x][y][1][0].x);
        if (varout[x][0]<sPoint) varout[x][0]=sPoint;
      }
      if (move[x][y][2][0]) {
        varout[x][1]+=(mouse.x-pos[x][y][2][0].x) ;    
        if (varout[x][1]<sPoint) varout[x][1]=sPoint;
      }
      for (int u=0; u<nPointsU; u++)for (int v=0; v<nPointsV; v++) pos[x][y][u][v].add(origin[x][y]);
    }
    return varout;
  }
  void display() {
    stroke(200);
    strokeWeight(1);     
    for (int x=0; x<nCellsX; x++)for (int y=0; y<nCellsY; y++) for (int u=0; u<nPointsU; u++)for (int v=0; v<nPointsV; v++) {
      if (u!=nPointsU-1) line(pos[x][y][u][v].x, pos[x][y][u][v].y, pos[x][y][u][v].z, pos[x][y][u+1][v].x, pos[x][y][u+1][v].y, pos[x][y][u+1][v].z);
      if (v!=nPointsV-1) line(pos[x][y][u][v].x, pos[x][y][u][v].y, pos[x][y][u][v].z, pos[x][y][u][v+1].x, pos[x][y][u][v+1].y, pos[x][y][u][v+1].z);
      if (x!=0) line(tpos[x][y][v].x, tpos[x][y][v].y, tpos[x][y][v].z, pos[x][y][0][v].x, pos[x][y][0][v].y, pos[x][y][0][v].z);
      if (x!=0) line(tpos[x][y][v].x, tpos[x][y][v].y, tpos[x][y][v].z, pos[x-1][y][2][v].x, pos[x-1][y][2][v].y, pos[x-1][y][2][v].z);
      if (x!=0&&v!=0) line(tpos[x][y][v].x, tpos[x][y][v].y, tpos[x][y][v].z, tpos[x][y][v-1].x, tpos[x][y][v-1].y, tpos[x][y][v-1].z);
    }
    fill(100);
    for (int x=0; x<nCellsX; x++)for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU; u++)for (int v=0; v<nPointsV; v++) {
        if (lbtOn==1) if ((v==0||u==0)&&!(u==0&&v==0)) {
          //ellipse(pos[x][y][u][v].x, pos[x][y][u][v].y, sPoint, sPoint);
          pushMatrix();
          translate(pos[x][y][u][v].x, pos[x][y][u][v].y, pos[x][y][u][v].z);
          ellipse(0, 0, sPoint, sPoint);
          popMatrix();
        }
      }
    }
  }
  void displayhinges() {
    stroke(200);
    strokeWeight(1);     
    for (int x=0; x<nCellsX; x++)for (int y=0; y<nCellsY; y++) for (int u=0; u<nPointsU; u++)for (int v=0; v<nPointsV; v++) {
      float x1 = 0;
      float x12 = 0;
      float x2 = 0;
      float x22 = 0;
      float y1=0;
      float y2=0;
      float y12=0;
      float y22=0;
      float sX = 15/nCellsX;
      float sY = 15/nCellsY;
      stroke(100);
      if (!(y==0&&v==0)) if (!(nCellsY-1==y&&v==nPointsV-1)) if (u!=nPointsU-1) {
        x1 = ((2*pos[x][y][u][v].x)+pos[x][y][u+1][v].x)/3;
        x12 = ((4*pos[x][y][u][v].x)+pos[x][y][u+1][v].x)/5;
        x2 = ((pos[x][y][u][v].x)+(2*pos[x][y][u+1][v].x))/3;
        x22 = ((pos[x][y][u][v].x)+(4*pos[x][y][u+1][v].x))/5;
        y1 = ((2*pos[x][y][u][v].y)+pos[x][y][u+1][v].y)/3;
        y12 = ((4*pos[x][y][u][v].y)+pos[x][y][u+1][v].y)/5;
        y2 = ((pos[x][y][u][v].y)+(2*pos[x][y][u+1][v].y))/3;
        y22 = ((pos[x][y][u][v].y)+(4*pos[x][y][u+1][v].y))/5;
        line(pos[x][y][u][v].x, pos[x][y][u][v].y+sY, pos[x][y][u][v].z, x1, y1+sY, pos[x][y][u+1][v].z);
        line(pos[x][y][u][v].x, pos[x][y][u][v].y-sY, pos[x][y][u][v].z, x1, y1-sY, pos[x][y][u+1][v].z);
        line(x2, y2+sY, pos[x][y][u][v].z, pos[x][y][u+1][v].x, pos[x][y][u+1][v].y+sY, pos[x][y][u+1][v].z);
        line(x2, y2-sY, pos[x][y][u][v].z, pos[x][y][u+1][v].x, pos[x][y][u+1][v].y-sY, pos[x][y][u+1][v].z);
        line(x22, y22, pos[x][y][u][v].z, x12, y12, pos[x][y][u][v].z);
      }   
      if (!(x==0&&u==0)) if (!(nCellsX-1==x&&u==nPointsU-1)) if (v!=nPointsV-1) {        //LINEAS VERTICALES 
        y1 = ((2*pos[x][y][u][v].y)+pos[x][y][u][v+1].y)/3;
        y2 = ((pos[x][y][u][v].y)+(2*pos[x][y][u][v+1].y))/3;
        y12 = ((4*pos[x][y][u][v].y)+pos[x][y][u][v+1].y)/5;
        y22 = ((pos[x][y][u][v].y)+(4*pos[x][y][u][v+1].y))/5;
        line(pos[x][y][u][v].x+sX, pos[x][y][u][v].y, pos[x][y][u][v].z, pos[x][y][u][v+1].x+sX, y1, pos[x][y][u][v+1].z);  //LINEAS VERTICALES
        line(pos[x][y][u][v].x+sX, y2, pos[x][y][u][v].z, pos[x][y][u][v+1].x+sX, pos[x][y][u][v+1].y, pos[x][y][u][v+1].z);
        line(pos[x][y][u][v].x-sX, pos[x][y][u][v].y, pos[x][y][u][v].z, pos[x][y][u][v+1].x-sX, y1, pos[x][y][u][v+1].z);
        line(pos[x][y][u][v].x-sX, y2, pos[x][y][u][v].z, pos[x][y][u][v+1].x-sX, pos[x][y][u][v+1].y, pos[x][y][u][v+1].z);
        line(pos[x][y][u][v].x, y12, pos[x][y][u][v].z, pos[x][y][u][v+1].x, y22, pos[x][y][u][v+1].z);
        line(pos[x][y][u][v].x+(2*sX), y12, pos[x][y][u][v].z, pos[x][y][u][v+1].x+(2*sX), y22, pos[x][y][u][v+1].z);
        line(pos[x][y][u][v].x-(2*sX), y12, pos[x][y][u][v].z, pos[x][y][u][v+1].x-(2*sX), y22, pos[x][y][u][v+1].z);
      }
      if (!(y==0&&v==0)) if (!(nCellsY-1==y&&v==nPointsV-1)) if (x!=0) {
        x1 = ((2*tpos[x][y][v].x)+ pos[x][y][0][v].x)/3;
        x12 = ((4*tpos[x][y][v].x)+ pos[x][y][0][v].x)/5;
        x2 = ((tpos[x][y][v].x)+(2* pos[x][y][0][v].x))/3;
        x22 = ((tpos[x][y][v].x)+(4* pos[x][y][0][v].x))/5;
        y1 = ((2*tpos[x][y][v].y)+ pos[x][y][0][v].y)/3;
        y12 = ((4*tpos[x][y][v].y)+pos[x][y][0][v].y)/5;
        y2 = ((tpos[x][y][v].y)+(2*pos[x][y][0][v].y))/3;
        y22 = ((tpos[x][y][v].y)+(4*pos[x][y][0][v].y))/5;

        line(tpos[x][y][v].x, tpos[x][y][v].y+sY, tpos[x][y][v].z, x1, y1+sY, pos[x][y][0][v].z);
        line(tpos[x][y][v].x, tpos[x][y][v].y-sY, tpos[x][y][v].z, x1, y1-sY, pos[x][y][0][v].z);
        line(x2, y2+sY, tpos[x][y][v].z, pos[x][y][0][v].x, pos[x][y][0][v].y+sY, pos[x][y][0][v].z);
        line(x2, y2-sY, tpos[x][y][v].z, pos[x][y][0][v].x, pos[x][y][0][v].y-sY, pos[x][y][0][v].z);
        line(x22, y22, tpos[x][y][v].z, x12, y12, pos[x][y][0][v].z);

        x1 = ((2*tpos[x][y][v].x)+ pos[x-1][y][2][v].x)/3;
        x12 = ((4*tpos[x][y][v].x)+ pos[x-1][y][2][v].x)/5;
        x2 = ((tpos[x][y][v].x)+(2* pos[x-1][y][2][v].x))/3;
        x22 = ((tpos[x][y][v].x)+(4* pos[x-1][y][2][v].x))/5;
        y1 = ((2*tpos[x][y][v].y)+ pos[x-1][y][2][v].y)/3;
        y12 = ((4*tpos[x][y][v].y)+pos[x-1][y][2][v].y)/5;
        y2 = ((tpos[x][y][v].y)+(2*pos[x-1][y][2][v].y))/3;
        y22 = ((tpos[x][y][v].y)+(4*pos[x-1][y][2][v].y))/5;

        line(tpos[x][y][v].x, tpos[x][y][v].y+sY, tpos[x][y][v].z, x1, y1+sY, pos[x-1][y][2][v].z);
        line(x2, y2+sY, tpos[x][y][v].z, pos[x-1][y][2][v].x, pos[x-1][y][2][v].y+sY, pos[x-1][y][2][v].z);
        line(tpos[x][y][v].x, tpos[x][y][v].y-sY, tpos[x][y][v].z, x1, y1-sY, pos[x-1][y][2][v].z);
        line(x2, y2-sY, tpos[x][y][v].z, pos[x-1][y][2][v].x, pos[x-1][y][2][v].y-sY, pos[x-1][y][2][v].z);
        line(x22, y22, tpos[x][y][v].z, x12, y12, pos[x-1][y][2][v].z);
      }     
      if (x!=0&&v!=0) {     //LINEAS VERTICALES
        y1 = ((2*tpos[x][y][v].y)+pos[x][y][u][v-1].y)/3;
        y2 = ((tpos[x][y][v].y)+(2*tpos[x][y][v-1].y))/3;
        y12 = ((4*tpos[x][y][v].y)+pos[x][y][u][v-1].y)/5;
        y22 = ((tpos[x][y][v].y)+(4*tpos[x][y][v-1].y))/5;
        line(tpos[x][y][v].x+sX, tpos[x][y][v].y, tpos[x][y][v].z, tpos[x][y][v-1].x+sX, y1, tpos[x][y][v-1].z);
        line(tpos[x][y][v].x+sX, y2, tpos[x][y][v].z, tpos[x][y][v-1].x+sX, tpos[x][y][v-1].y, tpos[x][y][v-1].z);
        line(tpos[x][y][v].x-sX, tpos[x][y][v].y, tpos[x][y][v].z, tpos[x][y][v-1].x-sX, y1, tpos[x][y][v-1].z);
        line(tpos[x][y][v].x-sX, y2, tpos[x][y][v].z, tpos[x][y][v-1].x-sX, tpos[x][y][v-1].y, tpos[x][y][v-1].z);
        line(tpos[x][y][v].x, y22, tpos[x][y][v].z, tpos[x][y][v-1].x, y12, tpos[x][y][v-1].z);
      }
    }
  }
  void move() {
    for (int x=0; x<nCellsX; x++)for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++) {
        if (mouseX>pos[x][y][u][v].x-sPoint&&mouseX<pos[x][y][u][v].x+sPoint&&mouseY>pos[x][y][u][v].y-sPoint&&mouseY<pos[x][y][u][v].y+sPoint) move[x][y][u][v] = true;
      }
    }
  }
  void release() {
    for (int x=0; x<nCellsX; x++)for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++) {
        if (mouseX>pos[x][y][u][v].x-sPoint&&mouseX<pos[x][y][u][v].x+sPoint&&mouseY>pos[x][y][u][v].y-sPoint&&mouseY<pos[x][y][u][v].y+sPoint) move[x][y][u][v] = false;
      }
    }
  }
}