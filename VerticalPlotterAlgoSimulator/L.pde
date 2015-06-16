class L{
  P start;
  P end;
  float length;
  float m;
  float b;
  
  L(P start, P end) {
    this.start = start;
    this.end = end;
    this.length = start.distTo(end);
    this.m = (start.y - end.y) / (start.x - end.x);
    this.b = (end.x * start.y - start.x * end.y) / (end.x - start.x);
  }
  
  P pointAtPercent(float p){
    float x = this.start.x + (this.end.x - this.start.x) * p;
    float y = this.start.y + (this.end.y - this.start.y) * p;
    return new P(x, y);
  }
  
  void draw(){
    this.start.lineTo(this.end);
  }
  
  P perpendicularFrom(P ref){
    float perpM = -1 / this.m;
    float perpB = (perpM * - 1 * ref.x) + ref.y;
    float x = (this.b - perpB) / (perpM - this.m); 
    float y = this.m * x + this.b;
    return new P(x, y);
  }
}
