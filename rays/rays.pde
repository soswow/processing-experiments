import java.util.Iterator;

int w=500;
int h=500;
int raySize = w * h;

class Line {
  PVector start;
  PVector end;
  
  Line(PVector start, PVector end) {
    this.start = start;
    this.end = end;
  }
  
  int getSide(PVector point){
    float result = (end.x - start.x) * (point.y - start.y) - (end.y - start.y) * (point.x - start.x);
    if(result > 0){
      return 1;
    }else if(result < 0){
      return -1;
    }else{
      return 0;
    }
    
//    float a = end.x - start.x;
//    float b = point.x - start.x;
//    float c = end.y - start.y;
//    float d = point.y - start.y;
//    return a * d - b * c;
  }
  
  PVector getMiddlePoint(){
    float x = start.x + (end.x - start.x) / 2;
    float y = start.y + (end.y - start.y) / 2;
    return new PVector(x, y);
  }
}

float correctHeading(float heading){
  if(heading < 0){
      heading += TWO_PI;
  }
  return heading;
}

class ShadowCone {
  PVector origin;
  PVector firstVector;
  PVector secondVector;
  Line border;
  Line firstRay;
  Line secondRay;
  float alpha;
  float beta;
  
  public ShadowCone(Line border, PVector origin){
    this.origin = origin;
    this.border = border;
    firstVector = getConeSideVector(border.start);
    secondVector = getConeSideVector(border.end);
    correctClockwiseOrder();
    firstRay = getRay(origin, firstVector);
    secondRay = getRay(origin, secondVector);
    alpha = correctHeading(firstVector.heading());
    beta = correctHeading(secondVector.heading());
  }
  
  void correctClockwiseOrder(){
    float alpha = correctHeading(firstVector.heading());
    float beta = correctHeading(secondVector.heading());
    float diff = abs(alpha - beta);
    boolean needReverse = !((diff > PI && alpha > beta) || (diff < PI && alpha < beta));
    if(needReverse){
      PVector tmp = secondVector;
      secondVector = firstVector;
      firstVector = tmp;
    }
  }
  
  void draw(){
    stroke(30, 255, 30);
    line(firstRay.start.x, firstRay.start.y, firstRay.end.x, firstRay.end.y);
    stroke(255, 30, 30);
    line(secondRay.start.x, secondRay.start.y, secondRay.end.x, secondRay.end.y); 
  }
  
  boolean doesContainVector(PVector vector){
    float gamma = correctHeading(vector.heading());
    
    if(beta - alpha > 0){
      return gamma > alpha && gamma < beta;
    } else {
      return gamma > alpha || gamma < beta;
    }
  }
  
  boolean isInside(ShadowCone cone) {
    return cone.doesContainVector(firstVector) &&
           cone.doesContainVector(secondVector);
  }
  
  boolean isBehind(ShadowCone cone) {
    int originSide = cone.border.getSide(this.origin);
    
    return cone.border.getSide(this.border.start) != originSide || 
          cone.border.getSide(this.border.end) != originSide;
  }
  
  private PVector getConeSideVector(PVector pointOnLine){
    PVector ray = pointOnLine.get();
    ray.sub(origin);
    ray.normalize();
    ray.mult(raySize);
    return ray;
  }
  
  private Line getRay(PVector fromPoint, PVector toPoint){
    toPoint = toPoint.get();
    toPoint.add(fromPoint);
    return new Line(fromPoint, toPoint); 
  }
  
  boolean isPointInBetweenRays(PVector point){
    PVector lineMiddlePoint = this.border.getMiddlePoint();
    return this.firstRay.getSide(lineMiddlePoint) == this.firstRay.getSide(point) && 
            this.secondRay.getSide(lineMiddlePoint) == this.secondRay.getSide(point); 
  }
  
  boolean isInShadow(PVector point){
    if(!this.isPointInBetweenRays(point)){
      return false;
    }
    
    return this.border.getSide(point) != this.border.getSide(this.origin);    
  }
  
  float distanceToPoint(PVector point) {
    
    float firstDistance = abs(
      (firstRay.end.y - origin.y) * point.x - (firstRay.end.x - origin.x) * point.y + 
      firstRay.end.x * origin.y - firstRay.end.y * origin.x) / raySize;
    float secondDistance = abs(
      (secondRay.end.y - origin.y) * point.x - (secondRay.end.x - origin.x) * point.y + 
      secondRay.end.x * origin.y - secondRay.end.y * origin.x) / raySize;
    return min(firstDistance, secondDistance);
  }
}

Line[] lines = new Line[5];

void initLines(){
  for(int i=0; i<lines.length; i++){
    float x1 = random(0, w);
    float y1 = random(0, h);
    int randomFactor = 100;
    float x2 = random(max(0, x1-randomFactor), min(w, x1+randomFactor));
    float y2 = random(max(0, y1-randomFactor), min(h, y1+randomFactor));
    lines[i] = new Line(new PVector(x1, y1), new PVector(x2, y2));
  }
}

void setup(){
  size(w,h);
  initLines();
}

ArrayList<ShadowCone> removeInclusions(ArrayList<ShadowCone> cones){
  ArrayList<ShadowCone> newCones = new ArrayList<ShadowCone>();
  for (ShadowCone coneI: cones) {
    boolean toRemove = false;
    for (ShadowCone coneJ: cones) {
      if (!coneI.equals(coneJ)) {
        if(coneI.isInside(coneJ) && coneI.isBehind(coneJ)){
          toRemove = true;
        }
      }
    }
    if(!toRemove){
      newCones.add(coneI);
    }
  }
  
  return newCones;
}

ArrayList<ShadowCone> cones;

void updateCones(){
  cones = new ArrayList<ShadowCone>();
  
  PVector cursor = new PVector(mouseX, mouseY);
  for (int i=0; i<lines.length; i++) {
    cones.add(new ShadowCone(lines[i], cursor));
  }
  cones = removeInclusions(cones);
}

void mouseMoved(){
  updateCones();  
}


void draw() {
  background(255);
  if(cones == null) {
    updateCones();
  }
  stroke(255, 100, 100);
  loadPixels();
  PVector point;
  for(int y=0; y<h; y++){
    for(int x=0; x<w; x++){
      int pix = y * w + x;
      point = new PVector(x, y);
      boolean isInShadow = false;
      for (ShadowCone cone: cones) {
        if (!isInShadow && cone.isInShadow(point)) {
          isInShadow = true;
        }
      }
      
      if (isInShadow) {
        pixels[pix] = color(0);
      } else {
        float dist = dist(mouseX,mouseY,x,y);
        color c = color(255-dist);
        pixels[pix] =c;
      }

//      float distance = cones.get(0).distanceToPoint(point);
//      pixels[pix] =color(255 - (distance > 255 ? 255 : int(distance)));
    }
  }
  updatePixels();
  
  for(ShadowCone cone: cones){
    cone.draw();
  }
  
  stroke(0);
  for(int i=0; i<lines.length; i++){
    line(lines[i].start.x, lines[i].start.y, lines[i].end.x, lines[i].end.y);
  }
  
  textSize(20);
  text(frameRate, 10, 20);
}



void mouseClicked() {
   initLines();
}
