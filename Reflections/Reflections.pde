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
