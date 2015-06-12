int w = 1200;
int h = 700;
int w2 = 500;

void setup() {
  size(w, h);
  
}

PVector mapCordesianToPlotter(int x, int y) {
  float c1 = sqrt(pow(x,2) + pow(y,2));
  float c2 = sqrt(pow(w2-x, 2) + pow(y,2));
  return new PVector(c1, c2);
}

float sin45 = sin(degrees(-45));
float cos45 = cos(degrees(-45));
PVector sideShift = new PVector(w2, 0);
void rotate45(PVector p) {
//  p.add(new PVector(-w2/2, -w2/2));
//  p.rotate(radians(45));
//  p.add(new PVector(sqrt(2 * pow(w2, 2))/2, 0));

//  p.x = p.x * cos45 - p.y * sin45;
//  p.y = p.x * sin45 + p.y * cos45;
  p.add(sideShift);
}

void mapToTheRight(){
  loadPixels();
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w2 + 2; x++) {
        color currentColor = pixels[w * y + x];
        if(currentColor != white){
          PVector newCoords = mapCordesianToPlotter(x, y);
          rotate45(newCoords);
          
          int newPosition = w * int(newCoords.y) + int(newCoords.x);
          
          if(newCoords.y > 0 && newCoords.y < h && newCoords.x < w && newCoords.x > 0){
            pixels[newPosition] = currentColor;
          }
        }
    }
  }
  updatePixels();
}


color white = color(255);
void draw() {
  background(255);
//  fill(125);
  int s = 200;
  stroke(20,20,255);
  strokeWeight(3);
  rect(mouseX-s/2, mouseY-s/2, s, s);
  strokeWeight(1);
  stroke(125);
  for(int i=0;i<25;i++){
    line(i*20, 0, i*20, h);
  }
  for(int i=0;i<35;i++){
    line(0, i*20, w2, i*20);
  }
  
  mapToTheRight();
  line(w2,0,w2,h);
}
