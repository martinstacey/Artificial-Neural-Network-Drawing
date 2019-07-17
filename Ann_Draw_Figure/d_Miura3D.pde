Miura mi= new Miura ();
void setupmi() {
  mi.setCells(nCells[0], nCells[1]);
  hslv=mi.calculatehslv(a1a2, b1b2, gang, yang); 
  mi.calcpos(miorigin, hslv);
}
void drawmi() {
  hslv=mi.calculatehslv(a1a2, b1b2, gang, yang); 
  mi.calcpos(miorigin, hslv);
  //mi.showvalues(mi.cpoints());
  mi.display();
  mi.edge();
  //mi.shadow(startheight);
  //mi.discpoints();
}
class Miura {
  int nCellsX, nCellsY;
  int nPointsU, nPointsV; 
  float a1, a2, b1, b2, ga, ya, h1, s1, l1, v1, h2, s2, l2, v2;
  PVector [][] origin;
  PVector [][][][] pos;
  PVector [][][] tpos;

  Miura() {
  }
  void setCells(int _nCellsX, int _nCellsY) {
    nCellsX=_nCellsX;
    nCellsY=_nCellsY;
    nPointsU= 3;
    nPointsV= 3;
    origin = new PVector [nCellsX][nCellsY];
    pos=new PVector [nCellsX][nCellsY][nPointsU][nPointsV];
    tpos = new PVector [nCellsX][nCellsY][nPointsV];
  }

  float [][][]  calculatehslv(float [][][] lista, float [][]listb, float _fold, float _parang) {
    float [][][] hslv = new float [nCellsX][nCellsY][8];    
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      a1= lista[x][y][0];
      b1= listb[x][0];
      a2= lista[x][y][1];
      b2= listb[x][1];
      ga= _fold;
      ya= _parang;
      h1= a1*(sin(radians(ga))*sin(radians(ya)));
      s1= b1*((cos(radians(ga))*tan(radians(ya)))/sqrt(1+sq(cos(radians(ga)))*sq(tan(radians(ya)))));
      l1= a1*(sqrt(1-sq(sin(radians(ga)))*sq(sin(radians(ya)))));
      v1= b1*(1/sqrt(1+sq(cos(radians(ga)))*sq(tan(radians(ya)))));
      h2= a2*(sin(radians(ga))*sin(radians(ya)));
      s2= b2*((cos(radians(ga))*tan(radians(ya)))/sqrt(1+sq(cos(radians(ga)))*sq(tan(radians(ya)))));
      l2= a2*(sqrt(1-sq(sin(radians(ga)))*sq(sin(radians(ya)))));
      v2= b2*(1/sqrt(1+sq(cos(radians(ga)))*sq(tan(radians(ya)))));
      hslv [x][y][0] = h1;
      hslv [x][y][1] = s1;
      hslv [x][y][2] = l1;
      hslv [x][y][3] = v1; 
      hslv [x][y][4] = h2;
      hslv [x][y][5] = s2;
      hslv [x][y][6] = l2;
      hslv [x][y][7] = v2;
    }
    return hslv;
  }
  void calcpos(PVector _origin1, float[][][]  hslv) {
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      pos[x][y][0][0]= new PVector (0, 0, 0);
      pos[x][y][1][0]= new PVector (hslv[x][y][1], hslv[x][y][3], 0);
      pos[x][y][2][0] = new PVector (hslv[x][y][1]+hslv[x][y][5], hslv[x][y][3]-hslv[x][y][7], 0);
      pos[x][y][0][1] = new PVector (0, hslv[x][y][2], hslv[x][y][0]);
      pos[x][y][0][2] = new PVector (0, hslv[x][y][2]+hslv[x][y][6], hslv[x][y][0]-hslv[x][y][4]);
      pos[x][y][1][1] = new PVector (hslv[x][y][1], (hslv[x][y][2]+hslv[x][y][3]), hslv[x][y][0]);   
      pos[x][y][1][2] = new PVector (hslv[x][y][1], ((hslv[x][y][2]+hslv[x][y][6])+hslv[x][y][3]), hslv[x][y][0]-hslv[x][y][4]);     
      pos[x][y][2][1] = new PVector (hslv[x][y][1]+hslv[x][y][5], hslv[x][y][2]+hslv[x][y][3]-hslv[x][y][7], hslv[x][y][0]);
      pos[x][y][2][2] = new PVector (hslv[x][y][1]+hslv[x][y][5], hslv[x][y][2]+hslv[x][y][6]+hslv[x][y][3]-hslv[x][y][7], hslv[x][y][0]-hslv[x][y][4]); 
      if (x==0&&y==0) origin[0][0]=_origin1;
      if (y==0&&x>0) {
        PVector midLength = new PVector(((pos[x-1][y][2][0].x-pos[x-1][y][0][0].x)+(pos[x][y][2][0].x-pos[x][y][0][0].x))/2, 0);               //Adding length to make transition points
        origin[x][y] =  PVector.add(pos[x-1][y][2][0], midLength);
      }
      if (y>0) origin[x][y] =  pos[x][y-1][0][2];
      for (int u=0; u<nPointsU; u++) for (int v=0; v<nPointsV; v++)pos[x][y][u][v].add(origin[x][y]);  
      if (x!=0) for (int v=0; v<nPointsV; v++) {
        tpos [x][y][v] = new PVector((pos[x][y][0][v].x+pos[x-1][y][2][v].x)/2, (pos[x][y][1][v].y+pos[x-1][y][1][v].y)/2, (pos[x][y][1][v].z+pos[x-1][y][1][v].z)/2);
      }
    }
  }
  void display() {
    pushStyle();
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      for (int u=0; u<nPointsU-1; u++) for (int v=0; v<nPointsV-1; v++) {
        strokeWeight(1);
        stroke(200);
        fill(255);
        beginShape();
        vertex(pos[x][y][u][v].x, pos[x][y][u][v].y, pos[x][y][u][v].z);
        vertex(pos[x][y][u+1][v].x, pos[x][y][u+1][v].y, pos[x][y][u+1][v].z);
        vertex(pos[x][y][u+1][v+1].x, pos[x][y][u+1][v+1].y, pos[x][y][u+1][v+1].z);
        vertex(pos[x][y][u][v+1].x, pos[x][y][u][v+1].y, pos[x][y][u][v+1].z);
        endShape(CLOSE);
      }
      for (int v=0; v<nPointsV; v++)  if (x!=0&&v!=0) {
        beginShape();
        vertex(pos[x][y][0][v-1].x, pos[x][y][0][v-1].y, pos[x][y][0][v-1].z);
        vertex(pos[x][y][0][v].x, pos[x][y][0][v].y, pos[x][y][0][v].z);
        vertex(tpos[x][y][v].x, tpos[x][y][v].y, tpos[x][y][v].z);
        vertex(tpos[x][y][v-1].x, tpos[x][y][v-1].y, tpos[x][y][v-1].z);
        endShape(CLOSE);
        beginShape();
        vertex(pos[x-1][y][2][v-1].x, pos[x-1][y][2][v-1].y, pos[x-1][y][2][v-1].z);
        vertex(pos[x-1][y][2][v].x, pos[x-1][y][2][v].y, pos[x-1][y][2][v].z);
        vertex(tpos[x][y][v].x, tpos[x][y][v].y, tpos[x][y][v].z);
        vertex(tpos[x][y][v-1].x, tpos[x][y][v-1].y, tpos[x][y][v-1].z);
        endShape(CLOSE);
      }
    }
    popStyle();
  }
  void edge() {
    pushStyle();
    PVector [] edge1= new PVector [nCellsY*nPointsV];
    PVector [] edge2= new PVector [(nCellsX*(nPointsU+1))-1];
    PVector [] edge3= new PVector [nCellsY*nPointsV];
    PVector [] edge4= new PVector [(nCellsX*(nPointsU+1))-1];
    for (int y=0; y<nCellsY; y++) for (int v=0; v<nPointsV; v++) edge1[(y*nPointsV)+v] = pos[0][y][0][v];
    for (int x=0; x<nCellsX; x++) for (int u=0; u<nPointsV; u++) edge2[(x*(nPointsU+1))+u] = pos[x][0][u][0];
    for (int x=0; x<nCellsX-1; x++) edge2[(x*(nPointsU+1))+3] = tpos[x+1][0][0];
    for (int y=0; y<nCellsY; y++) for (int v=0; v<nPointsV; v++) edge3[(y*nPointsV)+v] = pos[nCellsX-1][y][nPointsU-1][v];
    for (int x=0; x<nCellsX; x++) for (int u=0; u<nPointsV; u++) edge4[(x*(nPointsU+1))+u] = pos[x][nCellsY-1][u][2];
    for (int x=0; x<nCellsX-1; x++) edge4[(x*(nPointsU+1))+3] = tpos[x+1][nCellsY-1][2];
    strokeWeight(3);
    stroke(100);
    for (int i=0; i<edge1.length-1; i++) line(edge1[i].x, edge1[i].y, edge1[i].z, edge1[i+1].x, edge1[i+1].y, edge1[i+1].z);
    for (int i=0; i<edge2.length-1; i++) line(edge2[i].x, edge2[i].y, edge2[i].z, edge2[i+1].x, edge2[i+1].y, edge2[i+1].z);
    for (int i=0; i<edge3.length-1; i++) line(edge3[i].x, edge3[i].y, edge3[i].z, edge3[i+1].x, edge3[i+1].y, edge3[i+1].z);
    for (int i=0; i<edge4.length-1; i++) line(edge4[i].x, edge4[i].y, edge4[i].z, edge4[i+1].x, edge4[i+1].y, edge4[i+1].z);
    popStyle();
  }
  void shadow(float _sheight) {
    float sheight = _sheight;
    pushStyle();
    PVector [] edge1= new PVector [nCellsY*nPointsV];
    PVector [] edge2= new PVector [(nCellsX*(nPointsU+1))-1];
    PVector [] edge3= new PVector [nCellsY*nPointsV];
    PVector [] edge4= new PVector [(nCellsX*(nPointsU+1))-1];
    for (int y=0; y<nCellsY; y++) for (int v=0; v<nPointsV; v++) edge1[(y*nPointsV)+v] = pos[0][y][0][v];
    for (int x=0; x<nCellsX; x++) for (int u=0; u<nPointsV; u++) edge2[(x*(nPointsU+1))+u] = pos[x][0][u][0];
    for (int x=0; x<nCellsX-1; x++) edge2[(x*(nPointsU+1))+3] = tpos[x+1][0][0];
    for (int y=0; y<nCellsY; y++) for (int v=0; v<nPointsV; v++) edge3[(y*nPointsV)+v] = pos[nCellsX-1][y][nPointsU-1][v];
    for (int x=0; x<nCellsX; x++) for (int u=0; u<nPointsV; u++) edge4[(x*(nPointsU+1))+u] = pos[x][nCellsY-1][u][2];
    for (int x=0; x<nCellsX-1; x++) edge4[(x*(nPointsU+1))+3] = tpos[x+1][nCellsY-1][2];
    noStroke();
    fill(200);
    beginShape();
    for (int i=0; i<edge1.length-1; i++) vertex(edge1[i].x, edge1[i].y, -sheight);
    for (int i=0; i<edge4.length; i++) vertex(edge4[i].x, edge4[i].y, -sheight);
    for (int i=0; i<edge2.length-1; i++) vertex(edge2[i].x, edge2[i].y, -sheight);
    for (int i=0; i<edge3.length; i++) vertex(edge3[i].x, edge3[i].y, -sheight);
    endShape(CLOSE);
    popStyle();
  }
  PVector [][] cpoints() {
    PVector [][] cP = new PVector [nCellsX][nCellsY+1];
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      if (y==0) cP[x][y] = pos[x][y][1][0];
      cP[x][y+1]=pos[x][y][1][2];
    }
    return cP;
  }
  void discpoints() {
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      if (y==0) {
        fill(0, 0, 255);
        pushMatrix(); 
        translate(pos[x][y][1][0].x, pos[x][y][1][0].y, pos[x][y][1][0].z);
        box(5);
        popMatrix();
      }
      fill(255, 0, 0);
      pushMatrix(); 
      translate(pos[x][y][1][2].x, pos[x][y][1][2].y, pos[x][y][1][2].z);
      box(5);
      popMatrix();
    }
  }
  void showvalues(PVector [][] dp) {
    PVector [][] ap = dp;
    for (int x=0; x<nCellsX; x++) for (int y=0; y<nCellsY; y++) {
      pushStyle();
      textSize(10);
      text("p"+x+y+"["+ap[x][y]+"]", x*180, 20*y+400);
      popStyle();
    }
  }
}