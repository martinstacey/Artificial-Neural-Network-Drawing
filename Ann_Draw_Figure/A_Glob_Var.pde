int [] nCells = {5, 10};
PVector mporigin, mpsize;
PVector miorigin, misize;
PVector nsorigin, nssize;
PVector rsorigin, rssize;
PVector rsorigin2, rssize2;
PVector nndrorigin, nnl1origin, nnl2origin, nnl3origin; 
float   mapscale;
float [][][] a1a2;
float [][] b1b2;
float yang, gang;
float conyang, congang;
float [][][] hslv;

float []rotran =  { 0, 0, 0};   //PI/4
int [] nSurf = {6, 6, 5, 5};
float startheight;
int platon;
float [][] rsrot = {{45, 0, -45}, {45, 0, -45}};
PFont regf;
PFont boldf;
int inImgb =   16;
int inLblb =    8;
int tLabels =  7;
int nPixelsX = 25;
int nPixelsY = 20;
int sPixelsX = 12;
int sPixelsY = 12;
int nImgsX =    5;
int nImgsY =    4;
int nCounts =   50;
int n;
int tPixels =nPixelsX*nPixelsY;
int sImgsX = sPixelsX*nPixelsX;
int sImgsY = sPixelsY*nPixelsY;
int nImgsperCount = nImgsX*nImgsY;
int nTotImgs =      nImgsX*nImgsY*nCounts;
float strokeLin = 5;
float strokePixel = 1;


void setuppos() {
  mporigin = new PVector(200, 50, 0); 
  fill(100);

  mpsize = new PVector (500, 600);
  miorigin = new PVector(1000, -100, -600);
  misize = new PVector(600, 600, 20);
  nsorigin = new PVector (200*2, -75, -800*2);
  nssize = new PVector(800, 800, 1200);
  rsorigin = new PVector(width-115, 650);
  rssize = new PVector(100, 100);
  rsorigin2 = new PVector(width-115, 900);
  rssize2 = new PVector(100, 100);
  mapscale = 0.40;
  nndrorigin = new PVector(30, 60*1.5);
  nnl1origin = new PVector (30, 240*1.5);
  nnl2origin = new PVector (30, 420*1.5);
  nnl3origin = new PVector (30, 475*1.5);
}
void setupvar() {
  gang = 75;
  yang = 75;
  congang = 75;
  conyang = 75;
  startheight = 800;
  a1a2 = new float [nCells[0]][nCells[1]][2];
  for (int x=0; x<nCells[0]; x++) {
    for (int y=0; y<nCells[1]; y++) {
      for (int i=0; i<2; i++) {
        a1a2[x][y][i]=mpsize.y/(nCells[1]*2);
      }
    }
  }
  b1b2 = new float [nCells[0]][2];
  for (int x=0; x<nCells[0]; x++) {
    for (int i=0; i<2; i++) {
      b1b2[x][i]=mpsize.x/(sin(radians(yang))*(nCells[0]+nCells[0]-1)*2);
    }
  }
  hslv = new float [nCells[0]][nCells[1]][8];
}
void printabs() {
  for (int x=0; x<nCells[0]; x++) for (int y=0; y<nCells[1]; y++) {
    pushStyle();
    fill(0);
    textSize(10);
    text("c"+x+""+y+" a1:"+nf(a1a2[x][y][0], 0, 2)+" a2:"+nf(a1a2[x][y][1], 0, 2), 40+x*200, height*.6+y*50);
    text("c"+x+""+y+" b1:"+nf(b1b2[x][0], 0, 2)+"b2:"+nf(b1b2[x][1], 0, 2), 40+x*200, height*.6+20+y*50);
    popStyle();
  }
}
void setupft() {
  regf = loadFont("Gadugi.vlw");
  boldf = loadFont("GadugiB.vlw");
}
void drawftr() {
  textFont(regf, 22);
}
void drawftb() {
  textFont(boldf, 22);
}
void drawdis() {
  textAlign(LEFT);
  fill(100);
  textSize(18);
  fill(0);
   text("NEURAL NETWORK:                             DRAW IT 2D GUESS 3D"  , 30,80);
  //text("wikinurbs", 20, 30*2);
  textSize(14);
     
  // text("Neural Network Response:"  , 450,20);
  //text("Draw Panel", width-250, 30*1.6);
  //text("3D Control", width-250, 30*10.5);
  //text("Nurbs Conditions", 20, 30*8);
  //text("Control", 20, 30*11);
  //text("Action", 20, 30*5);
  //text("Nurbs Conditions", 20, 30*8);
  //text("Control", 20, 30*11);
}