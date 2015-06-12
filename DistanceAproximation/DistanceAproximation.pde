int w = 500;
int h = 500;

void setup(){
  size(w, h);
}

void draw() {
  background(0);
  PVector center = new PVector(mouseX, mouseY);
  loadPixels();
  for(int y=0;y<h;y++){
    for(int x=0;x<w;x++){
      float dx = x - center.x;
      float dy = y - center.y;

      // Comment this line and uncomment others to see different approches      
      float dist = aproxDistance2(dx, dy);
//      float dist = float(aproxDistance(int(dx), int(dy)));
//      float dist = dist(center.x, center.y, x, y);
      
      color c = color(255/dist(0,0,500,500) * dist);
      pixels[y * w + x] = c;
    }
  }
  updatePixels();
}

float aproxDistance2(float dx, float dy) {
  float result = 0.0;
  
  if ( dx < 0 ) dx = -dx;
  if ( dy < 0 ) dy = -dy;
   
  float maximum = max(dx, dy);
  float minimum = min(dx, dy);
  
  result += 1007.0/1024.0 * maximum;
  result += 441.0/1024.0 * minimum;
    
  if ( maximum < 16 * minimum){
    result -= 40/1024 * maximum;
  }
  
  return result;  
}


int aproxDistance(int dx, int dy){
//u32 approx_distance( s32 dx, s32 dy )
//{
   int min, max, approx;

   if ( dx < 0 ) dx = -dx;
   if ( dy < 0 ) dy = -dy;

   if ( dx < dy )
   {
      min = dx;
      max = dy;
   } else {
      min = dy;
      max = dx;
   }

   approx = ( max * 1007 ) + ( min * 441 );
   if ( max < ( min << 4 ))
      approx -= ( max * 40 );

   // add 512 for proper rounding
   return (( approx + 512 ) >> 10 );
}
