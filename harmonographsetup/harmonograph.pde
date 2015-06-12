class Harmonograph {
  float distanceApart = width / 3;
  Configuration leftConfig, rightConfig;
  float crossPointY;
  
  Harmonograph(Configuration leftConfig, Configuration rightConfig) {
    this.leftConfig = leftConfig;
    this.rightConfig = rightConfig;
  }
  
  void setSliders(){
    cp5.addSlider("crossPointY")
      .plugTo(this, "crossPointY")
      .setSize(10, 100)
      .setPosition(width / 2 - 5, 80)
      .setColorCaptionLabel(0)
      .setRange(150, 300);
    
    cp5.getController("crossPointY").getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  }
  
  public void tick(){
    background(255);
  }
}

class Line {
  PVector start, end;
  
  Line (){}
  
  Line (PVector start, PVector end){
    this.start = start;
    this.end = end;
  }
}

class LegsPosition {
  Configuration config;
  Line firstLeg;
  private PVector crossPoint;
  
  LegsPosition (Configuration config, PVector crossPoint){
    this.config = config;
    this.crossPoint = crossPoint;
  }
  
  Line calcFirstLeg() {
    firstLeg = new Line();
    float angleInRad = (config.diskAngle * PI) / 180;
    float startPosX = sin(angleInRad) * (config.diskSize / 2) + config.diskCenter.x;
    float startPosY = cos(angleInRad) * (config.diskSize / 2) + config.diskCenter.y;
    firstLeg.start = new PVector(startPosX, startPosY);
    
    PVector firstLegVector = new PVector(config.diskCenter.x - firstLeg.start.x, config.diskCenter.y - firstLeg.start.y);
    firstLegVector.setMag(config.firstLegSize);
    firstLeg.end = new PVector(firstLegVector.x + firstLeg.start.x, firstLegVector.y + firstLeg.start.y);
    return firstLeg;
  }
  
  Line calcSecondLeg() {
    
  }
  
  void calculate(LegsPosition otherSide) {
    Line leg1 = calcFirstLeg();
    Line leg2 = otherSide.calcFirstLeg();
  }
}



//
//void _draw() {
//  leftSpeed += leftAcc;
//  if(leftSpeed >= 5 || leftSpeed <= -5){
//    leftAcc *= -1;
//  }
//  
//  rightSpeed += rightAcc;
//  if(rightSpeed >= 5 || rightSpeed <= -5){
//    rightAcc *= -1;
//  }
//  
//  rightAngle += rightSpeed;
//  if(rightAngle>=360){
//    rightAngle = 0;
//  }
//  leftAngle += leftSpeed;
//  if(leftAngle>=360){
//    leftAngle = 0;
//  }
//  background(255);
//  stroke(#000000, 50);
//  PVector leftCenter = new PVector(width / 3, 150);
//  PVector rightCenter = new PVector(width * 2 / 3, 150);
//  arc(leftCenter.x, leftCenter.y, leftSize, leftSize, 0, PI * 2);
//  arc(rightCenter.x, rightCenter.y, rightSize, rightSize, 0, PI * 2);
//  stroke(#000000, 255);
//  float leftAngleInRad = (leftAngle * PI) / 180;
//  float rightAngleInRad = (rightAngle * PI) / 180;
//  PVector leftStartPos = new PVector(sin(leftAngleInRad) * (leftSize / 2)  + leftCenter.x, cos(leftAngleInRad) * (leftSize / 2) + leftCenter.y);
//  PVector rightStartPos = new PVector(sin(rightAngleInRad) * (rightSize / 2)  + rightCenter.x, cos(rightAngleInRad) * (rightSize / 2) + rightCenter.y);
//  line(leftCenter.x, leftCenter.y, leftStartPos.x, leftStartPos.y);
//  line(rightCenter.x, rightCenter.y, rightStartPos.x, rightStartPos.y);
//  
//  PVector centerPoint = new PVector(width / 2, 200 + crossPointPosition);
//  PVector leftFirstLeg = new PVector(centerPoint.x - leftStartPos.x, centerPoint.y - leftStartPos.y);
//  PVector rightFirstLeg = new PVector(centerPoint.x - rightStartPos.x, centerPoint.y - rightStartPos.y);
//  leftFirstLeg.setMag(leftFirstLegSize);
//  rightFirstLeg.setMag(rightFirstLegSize);
//  PVector leftFirstLegEnd = new PVector(leftFirstLeg.x + leftStartPos.x, leftFirstLeg.y + leftStartPos.y);
//  PVector rightFirstLegEnd = new PVector(rightFirstLeg.x + rightStartPos.x, rightFirstLeg.y + rightStartPos.y);
//  line(leftStartPos.x, leftStartPos.y, leftFirstLegEnd.x, leftFirstLegEnd.y);
//  line(rightStartPos.x, rightStartPos.y, rightFirstLegEnd.x, rightFirstLegEnd.y);
// 
// 
//  stroke(#dddddd);
//  float d = dist(leftFirstLegEnd.x, leftFirstLegEnd.y, rightFirstLegEnd.x, rightFirstLegEnd.y);
////  line(leftFirstLegEnd.x, leftFirstLegEnd.y, rightFirstLegEnd.x, rightFirstLegEnd.y);
//  
//  int secondLegSize = 400;
//  noFill();
////  arc(leftFirstLegEnd.x, leftFirstLegEnd.y, secondLegSize, secondLegSize, 0, TWO_PI);
////  arc(rightFirstLegEnd.x, rightFirstLegEnd.y, secondLegSize, secondLegSize, 0, TWO_PI);
//  
//  float xmag = (pow(d, 2) - pow(secondLegSize, 2) + pow(secondLegSize, 2)) / (2 * d); //
////  println("secondLegX: " + xmag);
//  PVector secondLegEnd = new PVector(leftFirstLegEnd.x, leftFirstLegEnd.y);
//  secondLegEnd.sub(rightFirstLegEnd);
//  secondLegEnd.setMag(xmag);
//  PVector foo = new PVector(secondLegEnd.x, secondLegEnd.y);
//  secondLegEnd.add(rightFirstLegEnd);
//  
//  stroke(#000000);
//  
//  float y = sqrt(pow(secondLegSize/2,2) - pow(xmag, 2));
//  println("y: "+ y);
//  
//  foo.rotate(HALF_PI);
//  foo.setMag(y);
//  secondLegEnd.add(foo);
//  
//  stroke(#000000, 100);
//  line(rightFirstLegEnd.x, rightFirstLegEnd.y, secondLegEnd.x, secondLegEnd.y);
//  line(leftFirstLegEnd.x, leftFirstLegEnd.y, secondLegEnd.x, secondLegEnd.y);
//  
//  spline.add(secondLegEnd);
//  if(spline.size() > 10000){
//    spline.remove(0);
//  }
//  
//  PVector prev = spline.get(0);
//  for (int i = 1; i < spline.size(); i++) {
//    PVector next = spline.get(i);
//    line(prev.x, prev.y, next.x, next.y);
//    prev = next;
//  }
//  
//  
//  println("y: " + y);
//}
