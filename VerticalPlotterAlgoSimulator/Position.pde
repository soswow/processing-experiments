class Position {
  float left;
  float right;
  int leftSteps;
  int rightSteps;
  P point = null;
  P perp = null;
  float dist = -1;
  boolean skip = false;
  
  Position(int leftSteps, int rightSteps){
    this.leftSteps = leftSteps;
    this.rightSteps = rightSteps;
    
    this.left = leftSteps * step;
    this.right = rightSteps * step;
  }
  
  private float triangleHeight(float a, float b, float c){
    return sqrt((a + b - c) * (a - b + c) * (b + c - a) * (a + b + c)) / (c * 2);
  }
  
  P getPoint(){
    if(this.point == null){
      float y = this.triangleHeight(this.left, this.right, w);
      float x = sqrt(sq(this.left) - sq(y));
      this.point = new P(x, y);
    }
    return this.point;
  }
  
  P getPerpendicularPoint(L line){
    if(this.perp == null) {
      this.perp = line.perpendicularFrom(this.getPoint());
      this.dist = this.perp.distTo(this.getPoint()); 
    }
    return this.perp;
  }
  
  boolean isSameAs(Position position){
    return this.left == position.left && this.right == position.right;
  }
}
