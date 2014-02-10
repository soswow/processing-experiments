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
