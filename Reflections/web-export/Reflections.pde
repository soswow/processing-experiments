
ArrayList<MovablePoint> movablePoints;
MovablePoint currentlyMovingPoint;

int w = 500;
int h = 500;
void setup() {
  size(500, 500);
  movablePoints = new ArrayList<MovablePoint>();
  for(int i=0; i<10; i++) {
    new MovablePoint(new PVector(random(0,w), random(0,h))); 
  }
}

void mouseDragged(){
  for (int i = 0; i < movablePoints.size(); i++ ) 
    movablePoints.get(i).onDragged();
}

void draw() {
  background(255);
  line(30, 300, 350, 300);

  for (int i = 0; i < movablePoints.size(); i++) 
    movablePoints.get(i).update();
}


class MovablePoint {
  float hoverDistance = 10;
  int bigSize = 10;
  int smallSize = 6;
  int smallColor = 200;
  int bigColor = 30;
  
  PVector p;
  public boolean hovered = false;
  
  MovablePoint(PVector point){
    this.p = point;
    register();
  }
  
  void onMousePressed() {
    
  }
  void onMouseRelease() {
    
  }
  void onDragged() {
    if(mousePressed && this.hovered) {
      p.x = mouseX;
      p.y = mouseY;
    }
  }
  
  void update(){
    float d = dist(p.x, p.y, mouseX, mouseY);
    boolean otherHover = false;
    for (int i = 0; i < movablePoints.size(); i++){
      MovablePoint point = movablePoints.get(i);  
      if (point != this && point.hovered)
        otherHover = true;
    }
    this.hovered = !otherHover && d < hoverDistance;
    int size;
    if (hovered){
      size = bigSize;
      fill(bigColor);
    } else {
      size = smallSize;
      fill(smallColor);
    }
    noStroke();
    ellipse(p.x, p.y, size, size);
    noFill();
  }
  
  void register() {
    movablePoints.add(this);
  }
  
  void unregister() {
    movablePoints.remove(this);
  }
  
}

