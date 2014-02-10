import controlP5.*;

import processing.net.*;
Server myServer;

// Starts a myServer on port 5204


int w = 800;
int h = 800;
int step = 5;
float diag = sqrt(w*w+h*h);

ControlP5 cp5;
RadioButton radioButtons;

void setup() {
  size(w, h);
  background(255); 
  myDraw();
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("step")
     .setPosition(100,50)
     .setRange(5,60)
     .setValue(40)
     .setColorCaptionLabel(color(0, 0, 0))
     .setColorValueLabel(color(0,0,0));
  cp5.getController("step").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  myServer = new Server(this, 5050);
//  radioButtons = addRadioButton("radioButton")
//         .setPosition(20,160)
//         .setSize(40,20)
//         .setColorForeground(color(120))
//         .setColorActive(color(255))
//         .setColorLabel(color(255))
//         .setItemsPerRow(5)
//         .setSpacingColumn(50)
//         .addItem("50",1)
//         .addItem("100",2)
//         .addItem("150",3)
//         .addItem("200",4)
//         .addItem("250",5).addItem("50",1)
//         .addItem("100",2)
//         .addItem("150",3)
//         .addItem("200",4)
//         .addItem("250",5); 
}

void radioButton(int a) {
  println("a radio Button event: "+a);
}

class P{
  float x;
  float y;
  P(int x, int y){
    this.x = x;
    this.y = y;
  }
  P(float x, float y){
    this.x = x;
    this.y = y;
  }
  P(P p){
    this.x = p.x;
    this.y = p.y;
  }
  
  float distTo(P p){
    return dist(this.x, this.y, p.x, p.y);
  }
  float distTo(float x, float y){
    return dist(this.x, this.y, x, y);
  }
  void lineTo(P p){
    line(this.x, this.y, p.x, p.y);
  }
  void circle(float r){
    ellipse(round(this.x), round(this.y), round(r * 2), round(r * 2));
  }
  boolean isSameAs(P p){
    return this.x == p.x && this.y == p.y;
  }
  void drawPoint(){
    point(this.x, this.y);
  }
}

class Position {
  float left;
  float right;
  int leftSteps;
  int rightSteps;
  P point = null;
  P perp = null;
  float dist = -1;
  boolean skip = false;
  
  Position(int leftSteps, int rightSteps){
    this.leftSteps = leftSteps;
    this.rightSteps = rightSteps;
    
    this.left = leftSteps * step;
    this.right = rightSteps * step;
    
//    this.point = getPoint();
  }
  
  private float triangleHeight(float a, float b, float c){
    return sqrt((a + b - c) * (a - b + c) * (b + c - a) * (a + b + c)) / (c * 2);
  }
  
  P getPoint(){
    if(this.point == null){
      float y = this.triangleHeight(this.left, this.right, w);
      float x = sqrt(sq(this.left) - sq(y));
      this.point = new P(x, y);
    }
    return this.point;
  }
  
  P getPerpendicularPoint(L line){
    if(this.perp == null) {
      this.perp = line.perpendicularFrom(this.getPoint());
      this.dist = this.perp.distTo(this.getPoint()); 
    }
    return this.perp;
  }
  
  boolean isSameAs(Position position){
    return this.left == position.left && this.right == position.right;
  }
}

Position getClosestPosition(P p){
  float left = p.distTo(lo);
  float right = p.distTo(ro);
  int lSteps = round(left / step);
  int rSteps = round(right / step);
  return new Position(lSteps, rSteps);
}

class L{
  P start;
  P end;
  float length;
  float m;
  float b;
  
  L(P start, P end) {
    this.start = start;
    this.end = end;
    this.length = start.distTo(end);
    this.m = (start.y - end.y) / (start.x - end.x);
    this.b = (end.x * start.y - start.x * end.y) / (end.x - start.x);
  }
  
  P pointAtPercent(float p){
    float x = this.start.x + (this.end.x - this.start.x) * p;
    float y = this.start.y + (this.end.y - this.start.y) * p;
    return new P(x, y);
  }
  
  void draw(){
    this.start.lineTo(this.end);
  }
  
  P perpendicularFrom(P ref){
    float perpM = -1 / this.m;
    float perpB = (perpM * - 1 * ref.x) + ref.y;
    float x = (this.b - perpB) / (perpM - this.m); 
    float y = this.m * x + this.b;
    return new P(x, y);
  }
}

L line = new L(new P(30, 70), new P(400, 350));
P lo = new P(0, 0);
P ro = new P(w, 0);


void myDraw(){
  clear();
  stroke(150,150,150);
  strokeWeight(1);
  background(255);
  noFill();
  for(int i=0; i < diag * 2; i=i+step*2){
    lo.circle(i / 2);
    ro.circle(i / 2);
  }
  Position position;
  if(!mousePressed){
    position = getClosestPosition(new P(mouseX, mouseY));
    strokeWeight(4);
    stroke(255, 100, 100);
    lo.circle(position.left);
    ro.circle(position.right);
    strokeWeight(2);
    lo.lineTo(position.getPoint());
    ro.lineTo(position.getPoint());
  }
  
  strokeWeight(2);
  stroke(150, 150, 255);
  line.draw();
  
  int lineDist = ceil(line.length);

  ArrayList<Position> positions = new ArrayList<Position>();
  for(int i=0; i < lineDist; i++){
    float p = float(i) / float(lineDist);
    P samplePoint = line.pointAtPercent(p);
    position = getClosestPosition(samplePoint);
    if(i == 0 || !position.isSameAs(positions.get(positions.size()-1))){
      positions.add(position);
    }
  }
   
  for(int i=0; i < positions.size(); i++){
    Position pos = positions.get(i);
    P perp = pos.getPerpendicularPoint(line);
    strokeWeight(1);
    stroke(255,20,20);
    perp.lineTo(pos.getPoint());
  }
  
  boolean gogo = true;
  while(gogo){
    float max = -1;
    int maxIndex = -1;
//    boolean valid = true;
    //From second to pre-last
    for(int i = 1; i < positions.size() - 1; i++){
      Position prev = positions.get(i-1);
      Position curr = positions.get(i);
      Position next = positions.get(i + 1);
      if(prev.skip || curr.skip || next.skip) continue;
      if(prev.leftSteps != curr.leftSteps && prev.rightSteps != curr.rightSteps) continue;
      if(next.leftSteps != curr.leftSteps && next.rightSteps != curr.rightSteps) continue;
      if(next.leftSteps == prev.leftSteps || next.rightSteps == prev.rightSteps) continue;  
      if(positions.get(i).dist > max){
        max = positions.get(i).dist;
        maxIndex = i;
      }
    }
    if(maxIndex != -1){
      positions.get(maxIndex).skip = true;
      gogo = true;  
    }else{
      gogo = false;
    }
  }
  
  for(int i=0; i < positions.size(); i++){
    stroke(100,255,100);
    strokeWeight(8);
    position = positions.get(i);
    P p = position.getPoint();
    if(position.skip){
      stroke(250,255,100);
      strokeWeight(6);
      p.drawPoint();
      continue;
    }
    
    strokeWeight(3);
    if(i > 0){
      Position prev = positions.get(i - 1);
      if(prev.skip){
        prev = positions.get(i - 2);
      }
      p.lineTo(prev.getPoint());
    }
  }
  
  if(myServer!=null)
    myServer.write("hello");
}

void mousePressed() {
  line = new L(new P(mouseX, mouseY), line.end);
}

void mouseDragged() {
  line = new L(line.start, new P(mouseX, mouseY));
}

void draw() {
  myDraw();
}


