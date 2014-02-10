import remixlab.proscene.*;

Scene scene;

import processing.net.*; 
Client myClient; 

int width = 100;
int height= 100;

void setup(){
  size(640, 360, P3D);
  
  scene = new Scene(this);
  // when damping friction = 0 -> spin
  scene.camera().frame().setDampingFriction(0);
  
  myClient = new Client(this, "127.0.0.1", 5050); 
}

PVector transformation(PVector input, float size){
  float a = (sq(input.x) - sq(input.y) - sq(size)) / (-2 * size);
  float b = sqrt(sq(input.x) - sq(a));
  return new PVector(a, b);
}

void draw() {
  colorMode(RGB, 255);
  background(255);
//  noFill();
  
//  stroke(255, 140, 140);
//  beginShape(TRIANGLE_STRIP);
  PVector result;
  float y;

  float inc = 1;
  stroke(0,0,0,30);
  
//  colorMode(HSB, 100);
  for(y = 0; y < 100; y+=inc){
   beginShape(TRIANGLE_STRIP); 
    for(float x = 0; x < 100; x+=inc){
      result = transformation(new PVector(x, y), 100);
//      fill(result.y, 100, 100);
      vertex(x, y, result.y);
      
      result = transformation(new PVector(x, y+inc), 100);
//      fill(result.y, 100, 100);
      vertex(x, y+inc, result.y);
    }
    endShape(CLOSE);
  }
  
  if (myClient.available() > 0) { 
    //result = myClient.readString();
  }
//  fill(10, 200, 200);
//  vertex(30, 20, 10);
//  vertex(85, 20, 10);
//  fill(200, 10, 200);
//  vertex(85, 75, -25);
//  vertex(30, 75, 50);
  
}

void keyPressed() {
  if(scene.camera().frame().dampingFriction() == 0)
    scene.camera().frame().setDampingFriction(0.5);
  else
    scene.camera().frame().setDampingFriction(0);
  println("Camera damping friction now is " + scene.camera().frame().dampingFriction());
}
