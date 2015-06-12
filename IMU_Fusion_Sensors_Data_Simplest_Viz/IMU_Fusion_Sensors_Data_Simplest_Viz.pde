import processing.serial.*;
Serial myPort;
int w = 600;
int h = 500;
int lf = 10;


void setup(){
  size(w,h,P3D);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[5], 115200);
   
}
float angX = 0;
float angY = 0;
float angZ = 0;

void draw(){
  background(0);
  
  //  "!ANG:-0.07,0.12,-140.02";
  String line = myPort.readStringUntil(lf);
  if(line != null && line.contains("!ANG:")){
    String[] tokens = split(line.replace("!ANG:", ""), ",");
    angZ = Float.parseFloat(tokens[0]);
    angX = Float.parseFloat(tokens[1]);
    angY = Float.parseFloat(tokens[2]);
//    rotateY(radians(Float.parseFloat(tokens[1])));
//    rotateZ(radians(Float.parseFloat(tokens[2])));
  }
  translate(w/2, h/2, 0);
  rotateZ(radians(angZ));
  rotateX(radians(angX));
  rotateY(radians(angY));
  
  box(40, 20, 100);
}
