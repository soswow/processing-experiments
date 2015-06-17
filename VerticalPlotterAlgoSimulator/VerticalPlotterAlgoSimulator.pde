import controlP5.*;

int w = 800;
int h = 600;
int step = 40;
int stepsLimitToDrawSupportGraphics = 9;
float diag = sqrt(w*w+h*h);
boolean isOptimizationOn = true;

L line = new L(new P(30, 70), new P(400, 350));
P lo = new P(0, 0);
P ro = new P(w, 0);

ControlP5 cp5;
Toggle optimizationToggle;
Slider stepSlider;

void setup() {
  size(w, h);
   
  cp5 = new ControlP5(this);
  
  stepSlider = cp5.addSlider("step")
     .setPosition(100,50)
     .setRange(2,60)
     .setValue(40)
     .setColorCaptionLabel(color(0, 0, 0))
     .setColorValueLabel(color(0,0,0));
  
  cp5.getController("step").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
  optimizationToggle = cp5.addToggle("isOptimizationOn")
     .setPosition(250, 50)
     .setColorCaptionLabel(color(0, 0, 0))
     .setColorValueLabel(color(0,0,0))
     .setSize(50,20)
     .setMode(ControlP5.SWITCH);
}

void draw() {
  myDraw();
}

void mousePressed() {
  if(!isOverControls()){
    line = new L(new P(mouseX, mouseY), line.end);
  }
}

void mouseDragged() {
  if(!isOverControls()){
    line = new L(line.start, new P(mouseX, mouseY));
  }
}

boolean isOverControls(){
  return optimizationToggle.isMouseOver() || stepSlider.isMouseOver();
}  

Position getClosestPosition(P p){
  float left = p.distTo(lo);
  float right = p.distTo(ro);
  int lSteps = round(left / step);
  int rSteps = round(right / step);
  return new Position(lSteps, rSteps);
}

void myDraw(){
  clear();
  stroke(150,150,150);
  strokeWeight(1);
  background(255);
  noFill();
  
  // Draw grid
  if (step > stepsLimitToDrawSupportGraphics) {
    for(int i=0; i < diag * 2; i=i+step*2){
      lo.circle(i / 2);
      ro.circle(i / 2);
    }
  }
  
  // Draw radiuses crossing in the closest intersaction
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
  
  // Draw target line
  if (step > stepsLimitToDrawSupportGraphics) {
    strokeWeight(2);
    stroke(150, 150, 255);
    line.draw();
  }
  
  int lineDist = ceil(line.length);

  //Getting list of positions to draw approximation to this line
  ArrayList<Position> positions = new ArrayList<Position>();
  // Go through each pixel of current line
  for(int i=0; i < lineDist; i++) {
    float percent = float(i) / float(lineDist);
    P samplePoint = line.pointAtPercent(percent);
    position = getClosestPosition(samplePoint);
    boolean sameAsLastPoint = i > 0 && position.isSameAs(positions.get(positions.size() - 1));
    if(i == 0 || !sameAsLastPoint){
      positions.add(position);
    }
  }
  
  // Draw small perpendicular lines, to show an error
  for(Position pos: positions){
    P perp = pos.getPerpendicularPoint(line);
    if (step > stepsLimitToDrawSupportGraphics) {
      strokeWeight(1);
      stroke(255,20,20);
      perp.lineTo(pos.getPoint());
    }
  }
  
  
  /*
   At this point "positions" includes one position per grid cell. 
   This means traverse line made of this points goes alonge grid lines and never diagonaly.
   This part removes all the unnesessery points, so: 
   1) line is continious and you still can go through all point gradually turning wheel 
      (but now there will be times when two wheel should be turned at the same time)
   2) points that has been left are optimal, meaning the error from the target line is minimum
   */ 
  if(isOptimizationOn) {
    boolean gogo = true;
    while(gogo) {
      float max = -1;
      int maxIndex = -1;
  
      for (int i = 1; i < positions.size() - 1; i++) {
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
  }
  
  //Draw resulting drawing path in green 
  for (int i=0; i < positions.size(); i++) {
    position = positions.get(i);
    P p = position.getPoint();
    if(!position.skip){
      stroke(100,255,100);
      strokeWeight(3);
      if (i > 0) {
        Position prev = positions.get(i - 1);
        if (prev.skip) {
          prev = positions.get(i - 2);
        }
        p.lineTo(prev.getPoint());
      }
    }
  }
  
  // Draw yellow balls to the intersaction 
  // has been skipped in order to make it smoother
  if (step > stepsLimitToDrawSupportGraphics) {
    for (int i=0; i < positions.size(); i++) {
      position = positions.get(i);
      P p = position.getPoint();
      if (position.skip) {
        stroke(250,255,100);
        strokeWeight(6);
        p.drawPoint();
      }
    }
  }
  
  
}
