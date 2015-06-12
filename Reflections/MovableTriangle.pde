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
