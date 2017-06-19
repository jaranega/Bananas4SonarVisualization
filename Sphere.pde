class Sphere {
  
  private float _detail = 20;
  private int _ballRadius = 150;
  private boolean pulse = true;
  
  private float jitter;
  private float angle;
  
  public int centerX;
  public int centerY;
  private color sColor;
  
  private boolean startGrowing;
  private float bpm;
  private float eda;
  private float edaVariation = 0;
  private int meshType;
  
  Sphere(int x, int y, color c) 
  {
    centerX = x;
    centerY = y;  
    sColor = c;
  }
  
  void setup() {
    
  }
  
  
  void setBeat(float b) {
    startGrowing = true;
    pulse = false;
    bpm = b;
  }
  
  void setEda(float eV, float e) {
    edaVariation = eV;
    eda = e;
  }
  
  void draw() {
     pushMatrix();
     
     if (pulse && startGrowing ) {
      _ballRadius = _ballRadius + 10;
      if (_ballRadius >= 250) {
          pulse = false;
          startGrowing = false;
      }
    } else if(!pulse) {
      _ballRadius = _ballRadius - 10;
      if (_ballRadius <= 150) {
        pulse = true;
      } 
    }      
     
    jitter = 0.01;
    //if (second() % 5 == 0) {  
    //if (eda > 0) {
    // jitter = random(-0.1, 0.5);
    //} else {
    //  jitter = 0.05;
    //}
    
    angle = angle + jitter;
    float c = sin(angle);
    translate(centerX, centerY);
    rotateY(c);
    rotateX(c);
    //translate(width/2, height/2);
    //rotateY(map(mouseX, 0, width, 0, TWO_PI));
    //rotateX(map(mouseY, 0, width, 0, TWO_PI));
    stroke(sColor);
    
    
    noFill();
    meshType = TRIANGLE_FAN;
    //if (eda > 0) meshType=QUADS;
    beginShape(meshType);
    
    
    float x, y, z;
    
    for (float zi = -_detail * PI / 2; zi < _detail * PI; zi++) {
      for (float r = 0; r < TWO_PI; r += TWO_PI / _detail) {
      x = cos(r); 
      y = sin(r);
        
      z = zi / _detail;
        
      float heightMultiplier = sqrt(1 - sq(z-.5));
      float constantMultiplier = 1;
      
      if (edaVariation > 0) 
      {
        constantMultiplier = heightMultiplier * random(1, 1 + (eda * 0.001)/2);
      } else 
      if (edaVariation <=0) 
      { 
         constantMultiplier = heightMultiplier * random(1, 1.05);
      }
      vertex(x * heightMultiplier * constantMultiplier * _ballRadius, y * heightMultiplier * constantMultiplier * _ballRadius, z * _ballRadius - _ballRadius/2); 
     }
   }
    endShape();
    popMatrix();
  }
  
    
  void translatePos(int posX, int posY) {
    centerX = posX;
    centerY = posY;
  }
}