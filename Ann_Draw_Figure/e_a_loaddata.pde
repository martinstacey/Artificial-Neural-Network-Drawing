Datum [] training_set;                                                                          
Datum [] testing_set;                                                                          
Datum draw_set;
byte [] images;
byte [] labels;

void loadfi() {
  //images = loadBytes("t10k-images-14x14.idx3-ubyte");
  //labels = loadBytes("t10k-labels.idx1-ubyte");
  images = loadBytes("n25x20.idx3-ubyte");
  labels = loadBytes("l2.idx3-ubyte");
}
void loadtraind(int origin, int number) {
  training_set = new Datum [number];
  for (int i = 0; i < number; i++) {
    training_set[i] = new Datum(inImgb, tPixels, inLblb, tLabels);
    training_set[i].imageLoad(images, i+origin);
    training_set[i].labelLoad(labels, i+origin);
  }
}
void loadtestd(int origin, int number) {
  testing_set = new Datum [number];
  for (int i = 0; i < number; i++) {
    testing_set[i] = new Datum(inImgb, tPixels, inLblb, tLabels);
    testing_set[i].imageLoad(images, i+origin);                              
    testing_set[i].labelLoad(labels, i+origin);
  }
}
void loaddraw() {
  draw_set = new Datum(inImgb, tPixels, inLblb, tLabels);
  draw_set.imageLoad(bytesOutDrawing, 0);
}
class Datum {                                                                                                                        
  float [] inputs;
  float [] outputs;
  int output;
  int inbytes;
  int bytesperimage;
  int inbyteslab;
  int bytesperlabel;
  Datum(int _inbytes, int _bytesperimage, int _inbyteslab, int _bytesperlabel) {
    inbytes = _inbytes;
    bytesperimage = _bytesperimage;
    bytesperlabel = _bytesperlabel;
    inbyteslab=_inbyteslab;
    inputs = new float [bytesperimage];                                                        
    outputs = new float[bytesperlabel];                                                       
  }
  void imageLoad(byte [] images, int num ) {                                                   
    for (int i = 0; i < tPixels; i++){
      inputs[i] = int(images[i+(inbytes+num*bytesperimage)]) / 128.0 - 1.0;                    
    }
  }
  void labelLoad(byte [] labels, int num) {
    output = int(labels[inbyteslab+num]);                                                      
    for (int i = 0; i < bytesperlabel; i++) {
      if (i == output) outputs[i] = 1.0; 
      else outputs[i] = -1.0;
    }
  }
}