import java.awt.geom.Line2D;

class Court {
  PApplet p;
  
  Line2D top;
  Line2D bottom;
  Line2D right;
  Line2D left;

  Line2D[] limits;
  
  float yy1 = 61;
  float yy2 = 430;
  float xx1 = 112;
  float xx2 = 623;
  
  Court(PApplet parent) {
    p = parent;    
    
    top       = new Line2D.Float(0, 0, 1, 0);
    bottom    = new Line2D.Float(0, 1, 1, 1);
    right     = new Line2D.Float(1, 0, 1, 1);
    left      = new Line2D.Float(0, 0, 0, 1);

    limits = new Line2D[4];
    limits[0] = top;
    limits[1] = bottom;
    limits[2] = right;
    limits[3] = left;
  }

  void render() {
    p.strokeWeight(3);
    p.stroke(255, 0, 0);
    for (Line2D line : limits) {
      p.line(
        p.map((float) line.getX1(), 0, 1, xx1, xx2),
        p.map((float) line.getY1(), 0, 1, yy1, yy2),
        p.map((float) line.getX2(), 0, 1, xx1, xx2),
        p.map((float) line.getY2(), 0, 1, yy1, yy2));
    }
  }
}