// Finger joint understanding project
int W = 700;
int H = 600;

float boxWidth = 105;
float boxDepth = 140;
float boxHeight = 200;

float tabSize = 10;
float thickness = 6;


void setup(){
  size(W, H);
  background(255);
  
  drawLayout();
}

void drawLayout(){
  EdgeConfiguration widthEdgeConfig = new EdgeConfiguration(tabSize, thickness, "c1", "b1", boxWidth);
  EdgeConfiguration leftEdgeConfig = new EdgeConfiguration(tabSize, thickness, "c2", "c2", boxHeight);
  EdgeConfiguration rightEdgeConfig = new EdgeConfiguration(tabSize, thickness, "b2", "b2", boxHeight);
  
  translate(10, 10);
  drawEdge(widthEdgeConfig, "top");
  drawEdge(leftEdgeConfig, "left");
  translate(boxWidth, 0);
  drawEdge(rightEdgeConfig, "right");
  translate(-boxWidth, boxHeight);
  drawEdge(widthEdgeConfig, "bottom");
}

void drawEdge(EdgeConfiguration edgeConfig, String side) {
  beginShape();
  boolean flipDepth = side == "right" || side == "bottom";
  for(PVector p: getPointForEdge(edgeConfig, flipDepth)){
    if(side == "top" || side == "bottom"){
      vertex(p.x, p.y);
    }else if(side == "left" || side == "right"){
      vertex(p.y, p.x);
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
