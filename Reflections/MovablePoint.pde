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
