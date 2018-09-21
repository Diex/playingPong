void setup() {
  size(800, 600);
}


ArrayList<PVector> path = new ArrayList<PVector>();
int maxPointsInPath = 10;
void draw() {
  //background(127);

  if (path.size() > maxPointsInPath) path.remove(0);
  PVector avg = getAverageDirection(path);  

  stroke(0);
  strokeWeight(10);
  for (PVector p : path) point(p.x, p.y);
  if (path.size() < 2 ) return;
  PVector a = path.get(path.size() - 2).copy();
  strokeWeight(1);
  stroke(255, 0, 0);
  line(a.x, a.y, a.x + avg.x * 100, a.y + avg.y * 100);
  PVector last = path.get(path.size()-1);
  stroke(0, 255, 0);
  line(a.x, a.y, last.x, last.y);
  println(avg.x, avg.y);
  //println(a.x, a.y, a.add(avg).x * 100, a.add(avg).y * 100);
}

void mousePressed() {
  path.add(new PVector(mouseX, mouseY));
}

PVector getAverageDirection(ArrayList<PVector> path) {
  
  
  PVector sum = new PVector();
  for(int point = 1; point < path.size(); point ++){
    PVector dir = PVector.sub(path.get(point - 1), path.get(point)); // una direccion  
    dir.normalize();
    sum.sub(dir); 
  }
  //return sum.normalize();
  return (sum.div(path.size()).normalize());
}
