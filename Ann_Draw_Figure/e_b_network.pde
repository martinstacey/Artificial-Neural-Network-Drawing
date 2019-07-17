Network nn;                                                                                                    
int response, actual;                                                                                           

void setupnn() {
  nn = new Network(tPixels, tPixels/4, tLabels, nPixelsX, nPixelsY, sPixelsX, sPixelsY);
}
void trainnn(float trains) {
  for (int i = 0; i < trains; i++) {                                                                            
    int randomnet = int(random(0, training_set.length));                                                       
    response = nn.netrespond(training_set[randomnet].inputs);
    actual = training_set[randomnet].output;
    nn.train(training_set[randomnet].outputs);
  }
}
void testnn() {
  int row = int(random(0, testing_set.length));
  response = nn.netrespond(testing_set[row].inputs);
  actual = testing_set[row].output;
}
void testnnd() {
  response  =  nn.netrespond (draw_set.inputs);
}
void drawnn() {
  nn.drawl1(nnl1origin);
  nn.drawl2(nnl2origin);
  nn.drawl3(nnl3origin);
  fill(0);
  textAlign(CENTER);
  fill(100);
  //text(str(response), width-30, 30*8.2 + sPixelsY/2 +7);
}
class Network {                                                                                               
  Neuron [] m_input_layer;                                                                                    
  Neuron [] m_hidden_layer;
  Neuron [] m_output_layer;                                                                                    
  int nPixX, nPixY;
  float sPixX, sPixY;

  Network(int inputs, int hidden, int outputs, int _nPixX, int _nPixY, float _sPixX, float _sPixY) {                                                               
    m_input_layer = new Neuron [inputs];
    m_hidden_layer = new Neuron [hidden];
    m_output_layer = new Neuron [outputs];
    for (int i = 0; i < m_input_layer.length; i++) m_input_layer[i] = new Neuron();                             
    for (int j = 0; j < m_hidden_layer.length; j++) m_hidden_layer[j] = new Neuron(m_input_layer);              
    for (int k = 0; k < m_output_layer.length; k++) m_output_layer[k] = new Neuron(m_hidden_layer);            
    nPixX = _nPixX;
    nPixY = _nPixY;
    sPixX = _sPixX;
    sPixY = _sPixY;
  }
  int netrespond(float [] inputs) {
    float [] responses = new float [m_output_layer.length];                                                    
    for (int i = 0; i < m_input_layer.length; i++)  m_input_layer[i].m_output = inputs[i];                     
    for (int j = 0; j < m_hidden_layer.length; j++) m_hidden_layer[j].neuro_respond();
    for (int k = 0; k < m_output_layer.length; k++) responses[k] = m_output_layer[k].neuro_respond();          
    int response = -1;                                                                                         
    float best = max(responses);
    for (int a = 0; a < responses.length; a++)  if (responses[a] == best) response = a;
    return response;
  }
  void train(float [] outputs) {
    for (int k = 0; k < m_output_layer.length; k++) {                                                           
      m_output_layer[k].finderror(outputs[k]);
      m_output_layer[k].train();
    }
    for (int j = 0; j < m_hidden_layer.length; j++) {                                                           
      m_hidden_layer[j].train();                                                                                
    }
  }
  void drawl1(PVector origin) {                                                                                 
    for (int i = 0; i < m_input_layer.length; i++) {

      pushMatrix();
      translate(origin.x, origin.y);
      translate((i%nPixX) *sPixX, (i/nPixX) * sPixY);
      float level = (0.5-(m_input_layer[i].m_output*0.5)); 
      stroke(200);
      fill(255 * level);
      rect(0, 0, sPixX, sPixY);
      popMatrix();
      stroke(100);
      noFill();
      rect(origin.x, origin.y, sPixX*nPixX, sPixY*nPixY);
    }
  }
  void drawl2(PVector origin) {
    for (int j = 0; j < m_hidden_layer.length; j++) {
      pushMatrix();
      translate(origin.x, origin.y);
      translate((j%nPixX) * sPixX, (j/nPixX) * sPixY);
      float level = (0.5-(m_hidden_layer[j].m_output*0.5)); 
      fill(255 * level);
      rect(0, 0, sPixX, sPixY);
      popMatrix();
    }
  }
  void drawl3(PVector origin) {
    for (int k = 0; k < m_output_layer.length; k++) {                                                              
      pushMatrix();                                                                                             
      translate(origin.x, origin.y);
      translate(k*sPixX, 0);                                                                                    
      float level = (0.5-(m_output_layer[k].m_output*0.5)); 
      fill(255 * level);
      rect(0, 0, sPixX, sPixY);                                                                                 
      popMatrix();
    }
  }
}
class Neuron {                                                                                                  
  Neuron [] m_inputs;
  float [] m_weights;
  float m_threshold;
  float m_output;
  float m_error;

  Neuron() {                                                                                                   
    m_threshold = 0.0;
    m_error = 0.0;
    m_output = sigm(random(-5.0, 5.0));                                                                        
  }
  Neuron(Neuron [] inputs) {                                                                                  
    m_inputs = inputs;  
    m_weights = new float [inputs.length];
    for (int i = 0; i < inputs.length; i++) m_weights[i] = random(-1.0, 1.0);
    m_threshold = random(-1.0, 1.0);
    m_error = 0.0;
    m_output = sigm(random(-5.0, 5.0));                                                                        
  }
  float neuro_respond() {                                                                                      
    float input = 0.0;
    for (int i = 0; i < m_inputs.length; i++) input += m_inputs[i].m_output * m_weights[i];
    m_output = sigm(input + m_threshold);                                                                      
    m_error = 0.0;
    return m_output;
  }
  void finderror(float desired) {                                                                              
    m_error = desired - m_output;
  }
  void train() {                                                                                               
    float LEARNING_RATE = 0.01;    
    float delta = (1.0 - m_output) * (1.0 + m_output) * m_error * LEARNING_RATE;
    for (int i = 0; i < m_inputs.length; i++) {        
      m_inputs[i].m_error += m_weights[i] * m_error;                                                          
      m_weights[i] += m_inputs[i].m_output * delta;                                                           
    }
  }
}
float sigm(float x) {                                                                                         
  return  2.0 / (1.0 + exp(-2.0 * (x/5))) - 1.0;                                                             
}                                                                                   