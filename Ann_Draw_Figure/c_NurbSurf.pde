NurbsSurf ns = new NurbsSurf();
int fakeresponse=0;
void setupns() {
  ns.makeCtrlPts(nSurf[0], nSurf[1], nsorigin, nssize);
  ns.makeKnots(nSurf[2], nSurf[3]);
  ns.sPts(nCells[0]+1, nCells[1]+1);
}
void drawns() {
  //if (lbtOn==0) ns.PerlinCtrlPts();
  if (lbtOn==0) ns.makeCtrlPts(nSurf[0], nSurf[1], nsorigin, nssize);
  
  if (lbtOn==3) ns.makemanualCtrlPts(nSurf[0], nSurf[1], nsorigin, nssize, fakeresponse);
  ns.drawCtrlPts();
  ns.makeKnots(nSurf[2], nSurf[3]);
  ns.sPts(nCells[0]+1, nCells[1]+1);
  ns.drawSurf();
  //if (lbtOn!=1) ns.moveAs(nCells[0],nCells[1],conyang, congang);
  if (lbtOn!=1) a1a2=ns.moveAs(nCells[0], nCells[1], conyang, congang);
  //ns.displayAs(a1a2, nCells[0], nCells[1], conyang, congang);
}

void pressns() {
  ns.pressCtrlPts();
}
void releasens() {
  ns.releaseCtrlPts();
}
class NurbsSurf {
  PVector origin, size; 
  int ncPtsX, ncPtsY;                                               
  float t=0;

  PVector [][] cPts;
  boolean [][] cPtsSelect;
  float scPts = 5;

  int degX, degY;
  float[] knotsU, knotsV;    //Knot Vectors

  int stepsX, stepsY;
  PVector surfPts [][];

  float conYang, conGang;

  NurbsSurf() {
  }
  void makeCtrlPts(int _ncPtsX, int _ncPtsY, PVector _origin, PVector _size) {                                    
    origin = _origin;
    size = _size;
    ncPtsX=_ncPtsX;
    ncPtsY=_ncPtsY;

    cPts = new PVector [ncPtsX][ncPtsY];
    cPtsSelect = new boolean [ncPtsX][ncPtsY];

    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      if (y==0) cPts[x][y] = new PVector(x*size.x /(ncPtsX-1), y*size.y /(ncPtsY-1), size.z/2);   
      else cPts[x][y] = new PVector(x*size.x /(ncPtsX-1), y*size.y /(ncPtsY-1), noise(x*2, y*2, t)*size.z);
      cPts[x][y].add(origin);
    }
    t=t+0.005;
  }
  void makemanualCtrlPts(int _ncPtsX, int _ncPtsY, PVector _origin, PVector _size, int response) {  
    origin = _origin;
    size = _size;
    ncPtsX=_ncPtsX;
    ncPtsY=_ncPtsY;
    cPts = new PVector [ncPtsX][ncPtsY];
    cPtsSelect = new boolean [ncPtsX][ncPtsY];
    float zval = 0;
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      //if (y==0) cPts[x][y] = new PVector(x*size.x /(ncPtsX-1), y*size.y /(ncPtsY-1), size.z/2);
      //else{
      if (response==0) zval = size.z/2;
      if (response==1) zval = ((size.z/2)*sin((y/float(ncPtsY))*1.2*PI))+(size.z/2);
      if (response==2) zval = ((size.z/2)*sin((y/float(ncPtsY))*2.5*PI))+(size.z/2);
      if (response==3) zval = ((size.z/2)*cos((y/float(ncPtsY))*2.5*PI))+(size.z/2);
      if (response==4) {
        if (x==0||y==0||x==ncPtsX-1||y==ncPtsY-1) zval = size.z/2;
        else zval = ((size.z/4)*cos((y/float(ncPtsY))*2.5*PI))+((size.z/4)*cos((x/float(ncPtsX))*2.5*PI));
      }


      if (response==5) {
        if (y==0) zval = 0;
        else zval =  ((size.z/4)*-cos((y/float(ncPtsY))*2.5*PI))+(size.z/2)+((size.z/4)*-cos((x/float(ncPtsX))*2.5*PI));
      }
      if (response==6) {
        if (y==0) zval = 0;
        else zval =  ((size.z/4)*-cos((y/float(ncPtsY))*2.5*PI))+(size.z/2)+((size.z/4)*+cos((x/float(ncPtsX))*2.5*PI));
      }
      if (response==8){ zval = ((size.z/2)*atan((y/float(ncPtsY))*1.2*PI))+(size.z/2);          
      }
      if (response==9) {
        if (y==0) zval = 0;
        else zval =  ((size.z/4)*-sin((y/float(ncPtsY))*2.5*PI))+(size.z/2)+((size.z/4)*-sin((x/float(ncPtsX))*2.5*PI));        
      }
      if (y==0) cPts[x][y] = new PVector(x*size.x /(ncPtsX-1), y*size.y /(ncPtsY-1), zval);   
      else cPts[x][y] = new PVector(x*size.x /(ncPtsX-1), y*size.y /(ncPtsY-1), zval);
      cPts[x][y].add(origin);
    }
  }
  void PerlinCtrlPts() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      if (x!=0) cPts[x][y].add(0, 0, map(noise(x*2, y*2, t), 0, 1, -size.z/2, size.z/2));
    }
  }
  void drawCtrlPts() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      pushMatrix();
      if (lbtOn==2&&cPtsSelect[x][y]) fill(100);
      else fill(0);
      translate( cPts[x][y].x, cPts[x][y].y, cPts[x][y].z );
      noStroke();
      //if (lbtOn==2) sphere(scPts);
      //else sphere(scPts/2);
      popMatrix();
    }
  }
  void makeKnots(int _DU, int _DV)
  {
    degX=_DU;
    degY=_DV;
    knotsU = new float [ncPtsX + degX + 1];
    knotsV = new float [ncPtsY + degY + 1];
    float counterU=0;
    float counterV=0;
    float counterMidU=1.0;
    float counterMidV=1.0;
    for (int i = 0; i < knotsU.length; i++) {   
      if (i<degX+1) {  
        knotsU[i]=counterU;
        counterU+=0.001;
      } else if (i>=knotsU.length-(degX+1)) {    
        counterU-=0.001;
        knotsU[i]=1.00-counterU;
      } else {
        knotsU[i] = counterMidU / float(ncPtsX - degX);
        counterMidU+=1.0;
      }
    }
    for (int i = 0; i < knotsV.length; i++) {   
      if (i<degY+1) {  
        knotsV[i]=counterV;
        counterV+=0.001;
      } else if (i>=knotsV.length-(degY+1)) {    
        counterV-=0.001;
        knotsV[i]=1.00-counterV;
      } else {
        knotsV[i] = counterMidV / float(ncPtsY - degY); 
        counterMidV+=1.0;
      }
    }

  }
  float faderU(float u, int k) {  
    return basisn(u, k, degX, knotsU);
  }
  float faderV(float v, int k) { 
    return basisn(v, k, degY, knotsV);
  }
  float basisn(float uv, int k, int d, float [] knots) { 
    if (d == 0) return basis0(uv, k, knots); 
    else return basisn(uv, k, d-1, knots) * (uv - knots[k]) / (knots[k+d] -knots[k]) + basisn(uv, k+1, d-1, knots) * (knots[k+d+1] - uv) / (knots[k+d+1]- knots[k+1]);
  }
  float basis0(float uv, int k, float [] knots) {
    if (uv >= knots[k] && uv < knots[k+1]) return 1;
    else return 0;
  }
  PVector surfPos(float u, float v) {  
    PVector pt = new PVector();
    for (int i=0; i<ncPtsX; i++)  for (int j=0; j<ncPtsY; j++) {   
      PVector pt_k = new PVector(cPts[i][j].x, cPts[i][j].y, cPts[i][j].z);  //for surfaces multiply faderU*faderV
      pt_k.mult(faderU(u, i)*faderV(v, j));  
      pt.add(pt_k);
    }
    return pt;
  }
  void sPts(int _stepsX, int _stepsY) {
    stepsX = _stepsX;
    stepsY = _stepsY;
    surfPts = new PVector [stepsX][stepsY];
    for (int x = 0; x<stepsX; x++) for (int y = 0; y<stepsY; y++) {  
      float u =map(x, 0, stepsX-1, knotsU[degX], knotsU[knotsU.length-degX-1]);
      float v =map(y, 0, stepsY-1, knotsV[degY], knotsV[knotsV.length-degY-1]);
      surfPts[x][y] = surfPos(u, v);
      pushMatrix();
      translate(surfPts[x][y].x, surfPts[x][y].y, surfPts[x][y].z);     
      noStroke();
      fill(0, map(surfPts[x][y].z-origin.z, 0, size.z, 0, 255), map(surfPts[x][y].z-origin.z, 0, size.z, 255, 0));
      box(8);
      popMatrix();
    }
  }
  void drawSurf() {
    stroke(230);
    fill(255, 200);
    for (int x = 0; x<stepsX; x++) for (int y = 0; y<stepsY; y++) {  
      if (x!=0&&y!=0) {
        beginShape();
        vertex(surfPts[x][y].x, surfPts[x][y].y, surfPts[x][y].z); 
        vertex(surfPts[x-1][y].x, surfPts[x-1][y].y, surfPts[x-1][y].z);
        vertex(surfPts[x-1][y-1].x, surfPts[x-1][y-1].y, surfPts[x-1][y-1].z);
        vertex(surfPts[x][y-1].x, surfPts[x][y-1].y, surfPts[x][y-1].z);
        endShape(CLOSE);
      }
    }
  }
  float [][][] moveAs( int _nCellsX, int _nCellsY, float _conYang, float _conGang) {
    float conYang = _conYang;
    float conGang = _conGang;
    int nCellsX = _nCellsX;
    int nCellsY = _nCellsY;
    PVector [][] diff =  new PVector [nCellsX] [nCellsY];
    float varout [][][] =  new float [nCellsX] [nCellsY][2];


    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) diff[x][y] = PVector.sub(surfPts[x][y+1], surfPts[x][y]);
    float cC= (sin(radians(conGang))*sin(radians(conYang)));
    float cD = (sqrt(1-(sq(sin(radians(conGang)))*sq(sin(radians(conYang))))));
    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) varout[x][y][0]=(diff[x][y].y/(2*cD))+(diff[x][y].z/(2*cC));
    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) varout[x][y][1]=(diff[x][y].y/(2*cD))-(diff[x][y].z/(2*cC));
    return  varout;
  }
  void displayAs(float [][][] as, int _nCellsX, int _nCellsY, float _conYang, float _conGang) {
    float conYang = _conYang;
    float conGang = _conGang;
    int nCellsX = _nCellsX;
    int nCellsY = _nCellsY;
    float cC= (sin(radians(conGang))*sin(radians(conYang)));
    float cD = (sqrt(1-(sq(sin(radians(conGang)))*sq(sin(radians(conYang))))));
    stroke(0);
    float [][] h1 = new float [nCellsX][nCellsY];
    float [][] l1 = new float [nCellsX][nCellsY];
    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) h1[x][y] = as[x][y][0] * cC;
    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) l1[x][y] = as[x][y][1] * cD;
    for (int x = 0; x < nCellsX; x++) for (int y = 0; y < nCellsY; y++) {
      line(surfPts[x][y].x, surfPts[x][y].y, surfPts[x][y].z, surfPts[x][y].x, surfPts[x][y].y+l1[x][y], surfPts[x][y].z+h1[x][y]);
      line(surfPts[x][y+1].x, surfPts[x][y+1].y, surfPts[x][y+1].z, surfPts[x][y+1].x, surfPts[x][y].y+l1[x][y], surfPts[x][y].z+h1[x][y]);
    }
  }
  void pressCtrlPts() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      float pointX = screenX(cPts[x][y].x, cPts[x][y].y, cPts[x][y].z);
      float pointY = screenY(cPts[x][y].x, cPts[x][y].y, cPts[x][y].z);
      if (mouseX>(pointX-scPts)&&mouseX<(pointX+scPts)&&mouseY>(pointY-scPts)&&mouseY<(pointY+scPts)) cPtsSelect[x][y]= !cPtsSelect[x][y];
    }
  }
  void releaseCtrlPts() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) {
      float pointX = screenX(cPts[x][y].x, cPts[x][y].y, cPts[x][y].z);
      float pointY = screenY(cPts[x][y].x, cPts[x][y].y, cPts[x][y].z);
      if (mouseX>pointX-scPts&&mouseX<pointX+scPts&&mouseY>pointY-scPts&&mouseY<pointY) cPtsSelect[x][y]=false;
    }
  }
  void scrollup() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) if (cPtsSelect[x][y]) cPts[x][y].z +=5;
  }
  void scrolldown() {
    for (int x = 0; x < ncPtsX; x++) for (int y = 0; y < ncPtsY; y++) if (cPtsSelect[x][y]) cPts[x][y].z -=5;
  }
}