ArrayList<Movable> movables;
ArrayList<Drawable> drawables;

int w = 500;
int h = 500;

void setup() {
  size(500, 500);
  movables = new ArrayList<Movable>();
  drawables = new ArrayList<Drawable>();
  MovableRay spotLight = new MovableRay(
    new MovablePoint(new PVector(random(0,w), random(0,h))),
    new MovablePoint(new PVector(random(0,w), random(0,h)))
  );
  for(int i=0; i<3; i++) {
    new MovableTriangle(
      new MovablePoint(new PVector(random(0,w), random(0,h))),
      new MovablePoint(new PVector(random(0,w), random(0,h))),
      new MovablePoint(new PVector(random(0,w), random(0,h)))); 
  }
}

class MovableRay extends MovableLine  {
  MovableLine perp;
  
  public MovableRay(MovablePoint p1, MovablePoint p2){
    super(p1, p2);
    
    MovablePoint perpPoint = new MovablePoint(p1.p.get());
    perpPoint.locked = true;
    perp = new MovableLine(p1, perpPoint);
  }
  
  public void update() {
    float m = (p2.p.y - p1.p.y) / (p2.p.x - p1.p.x);
    float c = (p2.p.x * p1.p.y - p1.p.x * p2.p.y) / (p2.p.x - p1.p.x);
    float perpSlope = -1 * (p2.p.x - p1.p.x) / (p2.p.y - p1.p.y);
    perp.p2.p = p1.getSecondPoint(perpSlope, 20.0);
  }
  
  public void draw() {
    update();
    p1.draw();
    p2.draw();
    stroke(0);
    line(p1.p.x, p1.p.y, p2.p.x, p2.p.y);
    line(p1.p.x, p1.p.y, perp.p2.p.x, perp.p2.p.y);
  }
}

import java.util.Collections;
import java.util.Comparator;
class ZIndexComparator implements Comparator<Drawable> {
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
   if (!movables.get(i).isLocked())
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
  
  public MovableLine(MovablePoint p1, MovablePoint p2) {
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
  public boolean locked = false;
  
  public boolean isLocked() {return locked;}
  
  public MovablePoint(PVector point){
    this.p = point;
    registerDrawable(this);
    registerMovable(this);
  }
  
  public PVector getSecondPoint(float slope, float len) {
    float dx = len / sqrt(1 + sq(slope));
    float dy = dx * slope;
    return new PVector(p.x + dx, p.y + dy);
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
  boolean isLocked();
  void onDragged();
  boolean isDragged();
}
/**
@author Ryan Alexander 
*/
 
// Infinite Line Intersection
 
PVector lineIntersection(PVector p1, PVector p2, PVector p3, PVector p4)
{
  float bx = p2.x - p1.x;
  float by = p2.y - p1.y;
  float dx = p4.x - p3.x;
  float dy = p4.y - p3.y; 
  float b_dot_d_perp = bx*dy - by*dx;
  if(b_dot_d_perp == 0) {
    return null;
  }
  float cx = p3.x-p1.x; 
  float cy = p3.y-p1.y;
  float t = (cx*dy - cy*dx) / b_dot_d_perp; 
 
  return new PVector(p1.x+t*bx, p1.y+t*by); 
}
 
 
// Line Segment Intersection
 
PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) 
{ 
  float bx = x2 - x1; 
  float by = y2 - y1; 
  float dx = x4 - x3; 
  float dy = y4 - y3;
  float b_dot_d_perp = bx * dy - by * dx;
  if(b_dot_d_perp == 0) {
    return null;
  }
  float cx = x3 - x1;
  float cy = y3 - y1;
  float t = (cx * dy - cy * dx) / b_dot_d_perp;
  if(t < 0 || t > 1) {
    return null;
  }
  float u = (cx * by - cy * bx) / b_dot_d_perp;
  if(u < 0 || u > 1) { 
    return null;
  }
  return new PVector(x1+t*bx, y1+t*by);
}

