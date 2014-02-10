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
