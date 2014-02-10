interface Drawable {
  boolean getSkipAutoDrawing();
  Integer getZIndex();
  void draw();
}

interface Movable {
  void onDragged();
  boolean isDragged();
}
