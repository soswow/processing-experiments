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
