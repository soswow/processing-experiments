/**
@author Ryan Alexander 
*/
 
// Infinite Line Intersection
 
PVector lineIntersection(PVector p1, PVector p2, PVector p3, PVector p4)
{
  float bx = p2.x - p1.x;
  float by = p2.y - p1.y;
  float dx = p4.x - p3.x;
  float dy = p4.y - p3.y; 
  float b_dot_d_perp = bx*dy - by*dx;
  if(b_dot_d_perp == 0) {
    return null;
  }
  float cx = p3.x-p1.x; 
  float cy = p3.y-p1.y;
  float t = (cx*dy - cy*dx) / b_dot_d_perp; 
 
  return new PVector(p1.x+t*bx, p1.y+t*by); 
}
 
 
// Line Segment Intersection
 
PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) 
{ 
  float bx = x2 - x1; 
  float by = y2 - y1; 
  float dx = x4 - x3; 
  float dy = y4 - y3;
  float b_dot_d_perp = bx * dy - by * dx;
  if(b_dot_d_perp == 0) {
    return null;
  }
  float cx = x3 - x1;
  float cy = y3 - y1;
  float t = (cx * dy - cy * dx) / b_dot_d_perp;
  if(t < 0 || t > 1) {
    return null;
  }
  float u = (cx * by - cy * bx) / b_dot_d_perp;
  if(u < 0 || u > 1) { 
    return null;
  }
  return new PVector(x1+t*bx, y1+t*by);
}
