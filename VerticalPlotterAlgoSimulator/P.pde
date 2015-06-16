class P{
  float x;
  float y;
  P(int x, int y){
    this.x = x;
    this.y = y;
  }
  P(float x, float y){
    this.x = x;
    this.y = y;
  }
  P(P p){
    this.x = p.x;
    this.y = p.y;
  }
  
  float distTo(P p){
    return dist(this.x, this.y, p.x, p.y);
  }
  float distTo(float x, float y){
    return dist(this.x, this.y, x, y);
  }
  void lineTo(P p){
    line(this.x, this.y, p.x, p.y);
  }
  void circle(float r){
    ellipse(round(this.x), round(this.y), round(r * 2), round(r * 2));
  }
  boolean isSameAs(P p){
    return this.x == p.x && this.y == p.y;
  }
  void drawPoint(){
    point(this.x, this.y);
  }
}
