//import nervoussystem.obj.*;                                                         //MARTIN STACEY WIKINURBS 2017
boolean record = false;                                                            

void setup() {                                                                      //All setups are refered to the classes pages
  size(1150, 800, P3D);                                                             //This facilitates file swapping
  //size(1150, 800);
  smooth();
  setuppos();
  setupvar();
  loadfi();
  loadtraind(0, nTotImgs);
  loadtestd(0, nTotImgs);
  setupdr();
  setupnn();
  trainnn(nTotImgs);
  setupft();
  setupsl();
  setupbt();
  setupcb();
  setuprs();
  setupns();
  setupmap();
  setupmi();
}
void draw() {
  background(255);
  //printabs();
  drawdr();
  drawnn();
  drawftb();
  drawdis();
  //drawsl();
  //drawbt();
  //drawcb();
  drawrs();
 //drawmap();
  pushMatrix();
  actpsl(miorigin, misize, 0);
  //if (record) beginRecord("nervoussystem.obj.OBJExport", "mi.obj"); 
  ////drawmi();
  //if (record) {
  //  endRecord();
  //  record = false;
  //}
  popMatrix();
   
  actpsl(nsorigin, nssize, 1);
  drawns();
  
  //saveFrame("movie/####.png");
}
void keyPressed() {
  if (key == 'd') {
    loaddraw();
    testnnd();
  }
  if (key == 'e') setupdr();
  if (key == 's') {
    record = true;
    print("saved");
  }
  if (key == 'f') fakeresponse++;
}
void mousePressed() {
  presssl();
  pressbt();
  presscb();
  pressrs();
  pressns();
  pressmap();
}
void mouseReleased() {
  releasesl();
  releasers();
  releasemap();
}

void mouseWheel(MouseEvent event) {
  if (event.getCount()==-1) ns.scrollup();
  if (event.getCount()==+1) ns.scrolldown();
}