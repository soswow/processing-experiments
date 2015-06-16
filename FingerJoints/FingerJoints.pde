import controlP5.*;

// Finger joint understanding project
int W = 700;
int H = 600;

float boxWidth = 105;
float boxDepth = 140;
float boxHeight = 200;

float tabSize = 10;
float thickness = 6;

String topEdgeLeftCorner;
String topEdgeRightCorner;

ControlP5 cp5;

void setup(){
  size(W, H);
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("tabSize")
     .setPosition(100, 30)
     .setWidth(200)
     .setCaptionLabel("Tab Size")
     .setColorCaptionLabel(color(0,0,0))
     .setSliderMode(Slider.FIX)
     .setRange(1, 40)
     .getCaptionLabel()
     .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER);
     
  cp5.addSlider("thickness")
     .setPosition(100, 50)
     .setWidth(200)
     .setCaptionLabel("Material Thickness")
     .setColorCaptionLabel(color(0,0,0))
     .setSliderMode(Slider.FIX)
     .setRange(1, 20)
     .getCaptionLabel()
     .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER);
     
  cp5.addSlider("boxWidth")
     .setPosition(100, 70)
     .setWidth(200)
     .setCaptionLabel("Width")
     .setColorCaptionLabel(color(0,0,0))
     .setSliderMode(Slider.FIX)
     .setRange(50, 300)
     .getCaptionLabel()
     .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER);
     
  cp5.addSlider("boxHeight")
     .setPosition(100, 90)
     .setWidth(200)
     .setCaptionLabel("Height")
     .setColorCaptionLabel(color(0,0,0))
     .setSliderMode(Slider.FIX)
     .setRange(50, 300)
     .getCaptionLabel()
     .align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER);
}

void draw(){
  background(255);
  drawLayout();
}

void drawLayout(){
  EdgeConfiguration widthEdgeConfig = new EdgeConfiguration(tabSize, thickness, "c1", "b1", boxWidth);
  EdgeConfiguration leftEdgeConfig = new EdgeConfiguration(tabSize, thickness, "c2", "c2", boxHeight);
  EdgeConfiguration rightEdgeConfig = new EdgeConfiguration(tabSize, thickness, "b2", "b2", boxHeight);
  
  drawEdge(widthEdgeConfig, "top", new PVector(10, 150));
  drawEdge(leftEdgeConfig, "left", new PVector(10, 150));
  drawEdge(rightEdgeConfig, "right", new PVector(10+boxWidth, 150));
  drawEdge(widthEdgeConfig, "bottom", new PVector(10, 150+boxHeight));
}

void drawEdge(EdgeConfiguration edgeConfig, String side, PVector origin) {
  beginShape();
  boolean flipDepth = side == "right" || side == "bottom";
  for(PVector p: getPointForEdge(edgeConfig, flipDepth)){
    if(side == "top" || side == "bottom"){
      vertex(origin.x + p.x, origin.y + p.y);
    }else if(side == "left" || side == "right"){
      vertex(origin.x + p.y, origin.y + p.x);
    } 
  }
  endShape();
  stroke(0);
}

ArrayList<PVector> getPointForEdge(EdgeConfiguration edgeConfig, boolean flipDepth) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  float levelPx = 0;
  
  //Draw start corner
  float startLevel = edgeConfig.startHigh ? levelPx : edgeConfig.tabDepth * (flipDepth?-1:1);
  
  PVector point = new PVector(edgeConfig.startSkipSize, startLevel);
  println(point);
  points.add(point.get());
  point.x += edgeConfig.cornerSize - edgeConfig.startSkipSize;
  
  //Draw tabs
  for(int i=0; i < edgeConfig.fullTabsNumber; i++) {
    point.y = levelPx;
    if (i % 2 == (edgeConfig.startHigh ? 1 : 0)) {
      point.y = levelPx + edgeConfig.tabDepth * (flipDepth?-1:1);
    }
    println(point);
    points.add(point.get());
    point.x += edgeConfig.tabSize;
    println(point);
    points.add(point.get());
  }
  
  //Draw end corner
  float endLevel = edgeConfig.endHigh ? levelPx : edgeConfig.tabDepth * (flipDepth?-1:1);
  point.y = endLevel;
  println(point);
  points.add(point.get());
  point.x += edgeConfig.cornerSize - edgeConfig.endSkipSize;
  println(point);
  points.add(point.get());
  
  return points;
}
