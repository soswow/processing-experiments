ArrayList<Movable> movables;
ArrayList<Drawable> drawables;

int w = 500;
int h = 500;

void setup() {
  size(500, 500);
  movables = new ArrayList<Movable>();
  drawables = new ArrayList<Drawable>();
  for(int i=0; i<10; i++) {
    new MovableTriangle(
      new MovablePoint(new PVector(random(0,w), random(0,h))),
      new MovablePoint(new PVector(random(0,w), random(0,h))),
      new MovablePoint(new PVector(random(0,w), random(0,h)))); 
  }
}

class ZIndexComparator {
    int compare(Drawable o1, Drawable o2) {
        return o1.getZIndex() - o2.getZIndex();
    }
}

ZIndexComparator comparator = new ZIndexComparator();

void registerDrawable(Drawable obj){ 
  drawables.add(obj);
  Collections.sort(drawables, comparator);
}

void registerMovable(Movable obj){ movables.add(obj); }

void mouseDragged(){
  for (int i = 0; i < movables.size(); i++ ) 
    movables.get(i).onDragged();
}

void draw() {
  background(255);
  line(30, 300, 350, 300);

  for (int i = 0; i < drawables.size(); i++)
    if(!drawables.get(i).getSkipAutoDrawing()) 
      drawables.get(i).draw();
}
class MovableLine implements Drawable {
  MovablePoint p1;
  MovablePoint p2;
  
  public MovableLine(MovablePoint p1, MovablePoint p2){
    this.p1 = p1;
    this.p2 = p2;
    this.p1.skipAutoDrawing = true;
    this.p2.skipAutoDrawing = true;
    registerDrawable(this);
  }
  
  boolean getSkipAutoDrawing(){ return false;}
  Integer getZIndex(){ return 10;}
  
  public void draw() {
    stroke(0);
    p1.draw();
    p2.draw();
    line(p1.p.x, p1.p.y, p2.p.x, p2.p.y);
  } 
}
class MovablePoint implements Movable, Drawable {
  float hoverDistance = 10;
  int bigSize = 10;
  int smallSize = 6;
  int smallColor = 200;
  int bigColor = 30;
  
  public boolean skipAutoDrawing = false;
  
  boolean getSkipAutoDrawing(){ return skipAutoDrawing;}
  Integer getZIndex(){ return 30;}
  
  public PVector p;
  public boolean hovered = false;
  
  public MovablePoint(PVector point){
    this.p = point;
    registerDrawable(this);
    registerMovable(this);
  }
  
  public boolean isDragged() { return hovered; }
  
  public void onDragged() {
    if(mousePressed && this.hovered) {
      p.x = mouseX;
      p.y = mouseY;
    }
  }
  
  void draw(){
    float d = dist(p.x, p.y, mouseX, mouseY);
    boolean otherHover = false;
    for (int i = 0; i < movables.size(); i++){
      Movable movable = movables.get(i);
      if (movable != this && movable.isDragged())
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
}
class MovableTriangle implements Drawable {
  MovablePoint p1;
  MovablePoint p2;
  MovablePoint p3;
  
  public MovableTriangle(MovablePoint p1, MovablePoint p2, MovablePoint p3){
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    this.p1.skipAutoDrawing = true;
    this.p2.skipAutoDrawing = true;
    this.p3.skipAutoDrawing = true;
    registerDrawable(this);
  }
  
  boolean getSkipAutoDrawing(){ return false;}
  Integer getZIndex(){ return 20;}
  
  public void draw() {
    stroke(0);
    fill(100, 50, 50, 150);
    triangle(p1.p.x, p1.p.y, p2.p.x, p2.p.y, p3.p.x, p3.p.y);
    p1.draw();
    p2.draw();
    p3.draw();
  }
}
interface Drawable {
  boolean getSkipAutoDrawing();
  Integer getZIndex();
  void draw();
}

interface Movable {
  void onDragged();
  boolean isDragged();
}

