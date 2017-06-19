import netP5.*;
import oscP5.*;
import codeanticode.syphon.*;

SyphonServer server;

float heartRate1;
float heartRate2;
float edaVariation;
float eda;
int player;
boolean flashBeat = false;

float startTime;
final int DISPLAY_DURATION = 500;

OscP5 oscP5;
NetAddress myRemoteLocation;

Sphere sphere1;
Sphere sphere2;

Graph graph1;
Graph graph2;

Graph graph3;
Graph graph4;

PFont font;

color c1;
color c2;

PImage bg;

void settings() {
   size(1280, 1024, P3D);
   //fullScreen(2);
   PJOGL.profile=1;
}

void setup() {
  
  server = new SyphonServer(this, "Processing Syphon");
  oscP5 = new OscP5(this, 12345);
  
  frameRate(60);
  background(0);
  smooth ();
  
  c1 = color(159 , 255, 1);
  c2 = color(255, 249, 51);
  
  sphere1 = new Sphere(350, 2*height/3 - 50, c1);
  sphere2 = new Sphere(width-350, 2*height/3 - 50, c2);
  
  graph1 = new Graph(200, 225, 400, 50, c1, 500);
  graph2 = new Graph(width-620, 225, 400, 50, c2, 500);
  
  graph3 = new Graph(200, 280, 400, 50, c1, 50);
  graph4 = new Graph(width-620, 280, 400, 50, c2, 50);
  
  sphere1.setup();
  sphere2.setup();
  
  //graph1.setup();
  
  bg = loadImage("Bananas4Sonar2.png");
  
  font = createFont("Arial",26,true); // STEP 2 Create Font
}

 void keyPressed() {
  if (key == 'b') {
    sphere1.setBeat(1);
    sphere2.setBeat(1);
  } 
}
void oscEvent(OscMessage theOscMessage) {
  //println("### received an osc message. with address pattern " + theOscMessage.addrPattern());
  
  if(theOscMessage.checkAddrPattern("/beat")==true) {  
      player = theOscMessage.get(0).intValue();  
      
      if (player==1) {
        sphere1.setBeat(heartRate1);  
        heartRate1 = theOscMessage.get(1).floatValue(); 
      } else if (player==2) {
        sphere2.setBeat(heartRate2); 
        heartRate2 = theOscMessage.get(1).floatValue(); 
      }
     // print("### received an osc message /beat");
     // println(" values: 1: " + heartRate1 + " , 2: " + heartRate2);
      return; 
  }
  
  if(theOscMessage.checkAddrPattern("/eda")==true) {
      player = theOscMessage.get(0).intValue();  
      float edaVariation = theOscMessage.get(1).floatValue();
      float eda = theOscMessage.get(2).floatValue();
     // print("### received an osc message /eda");
     // print(" values: " + edaVariation);
     // println(", " + eda);
     
      float vals[] = new float[1];
      vals[0] = -1 * eda;
      
      //print(vals[0]);
      if (player==1) {
        sphere1.setEda(edaVariation, eda);
        graph3.addPoints(vals);
      }
      else if (player==2) {
        sphere2.setEda(edaVariation, eda); 
        graph4.addPoints(vals);
      }
      return; 
  }
  
  if(theOscMessage.checkAddrPattern("/tick")==true) {
    flashBeat = true;
    startTime = millis();
    return;
  }
  
  if(theOscMessage.checkAddrPattern("/ecg")==true) {
    player = theOscMessage.get(0).intValue();
    float vals[] = new float[10];
    
    if (player==1) {
      for(int i=1; i < 11; i++) {
        vals[i-1] = -1 * theOscMessage.get(i).floatValue();
      }
        graph1.addPoints(vals);
    }
     
     if (player==2) {
       for(int i=1; i < 11; i++) {
        vals[i-1] = -1 * theOscMessage.get(i).floatValue();
      }
        graph2.addPoints(vals);
     }
     
     return; 
  }

  println("### received an osc message. with address pattern " + theOscMessage.addrPattern());
}
void draw() {
  
  /*if (second() % 1 == 0) {  
    if (sphere1.centerY <= width/2)
      sphere1.translatePos(sphere1.centerX, sphere1.centerY++);
    if (sphere2.centerY >= width/2)
      sphere2.translatePos(sphere2.centerX, sphere2.centerY--);
  }*/
  
  background(bg);
  
  /*if (flashBeat)
  {
    background(255, 249, 51, 0.2);
    if (millis() - startTime > DISPLAY_DURATION)
    {
      // Stop displaying the message, thus resume the ball moving
      flashBeat = false;
    }
  }*/
  
  if (flashBeat) {
    background(255, 249, 51, 0.2);
    flashBeat = false;
  }
  
  textFont(font, 30);                  // STEP 3 Specify font to be used
  fill(159 , 255, 1);                      // STEP 4 Specify font color 
  text(Math.round(heartRate1) +" BPM", 310, height - 100 );   // STEP 5 Display Text
  fill(255, 249, 51);
  text(Math.round(heartRate2) + " BPM", width - 360, height - 100);
  sphere1.draw(); 
  sphere2.draw();
  graph1.draw();
  graph2.draw();
  graph3.draw();
  graph4.draw();
  
  server.sendScreen(); 
}