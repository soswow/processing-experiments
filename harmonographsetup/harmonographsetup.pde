import controlP5.*;

ControlP5 cp5;

int width = 600;
int height = 600;

int crossPointPosition = 0;

public ArrayList<PVector> spline = new ArrayList<PVector>();

Configuration leftConfig;
Configuration rightConfig;
Harmonograph graph;

void setup() {
  size(width, height);
  cp5 = new ControlP5(this);
    
  leftConfig = new Configuration("left");
  leftConfig.diskAngle = 250; 
  leftConfig.diskSize = 120;
  leftConfig.angularSpeed = 1;
  leftConfig.angularAccelarion = 0;
  leftConfig.firstLegSize = 250;
  leftConfig.secondLegSize = 300;
  leftConfig.diskCenterX = 150;
  leftConfig.setupSliders(new PVector(50, 20));
  
  rightConfig = new Configuration("right");
  rightConfig.diskAngle = 127; 
  rightConfig.diskSize = 100;
  rightConfig.angularSpeed = 1;
  rightConfig.angularAccelarion = 0;
  rightConfig.firstLegSize = 300;
  rightConfig.secondLegSize = 300;
  rightConfig.diskCenterX = 150;
  rightConfig.setupSliders(new PVector(width - 200, 20));
  
  graph = new Harmonograph(leftConfig, rightConfig);
  graph.crossPointY = 200;
  graph.setSliders();
}

void draw() {
  graph.tick();
}












