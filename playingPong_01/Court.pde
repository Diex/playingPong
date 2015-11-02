import java.awt.geom.Line2D;

class Court {
  PApplet p;
  PGraphics pg;

  Line2D top;
  Line2D bottom;
  Line2D right;
  Line2D left;

  Line2D[] limits;

  float yy1 = 61;
  float yy2 = 430;
  float xx1 = 112;
  float xx2 = 623;
  Ball ball;

  Court(PApplet parent) {
    p = parent;  
    pg = p.createGraphics(720, 480, P3D);

    top       = new Line2D.Float(0, 0, 1, 0);
    bottom    = new Line2D.Float(0, 1, 1, 1);
    right     = new Line2D.Float(1, 0, 1, 1);
    left      = new Line2D.Float(0, 0, 0, 1);

    limits = new Line2D[4];
    limits[0] = top;
    limits[1] = bottom;
    limits[2] = right;
    limits[3] = left;

    ball = new Ball();
  }

  void updateBall(Blob b) {
    ball.infereFromBlob(b);
  }

  PImage render() {
    pg.beginDraw();
    pg.background(0);
    pg.strokeWeight(3);
    pg.stroke(255, 0, 0);
    for (Line2D line : limits) {
      pg.line(
        PApplet.map((float) line.getX1(), 0, 1, xx1, xx2), 
        PApplet.map((float) line.getY1(), 0, 1, yy1, yy2), 
        PApplet.map((float) line.getX2(), 0, 1, xx1, xx2), 
        PApplet.map((float) line.getY2(), 0, 1, yy1, yy2));
    }
    pg.fill(0, 255, 0);
    pg.ellipse( 
      PApplet.map((float) ball.p.x, 0, 1, 0, pg.width), 
      PApplet.map((float) ball.p.y, 0, 1, 0, pg.height), 
      10, 10
      );   
      
    PVector dir = ball.getDirection().normalize();
    pg.strokeWeight(1);
    pg.stroke(255, 255, 0);
   
    pg.line(
      PApplet.map((float) ball.p.x, 0, 1, 0, pg.width), 
      PApplet.map((float) ball.p.y, 0, 1, 0, pg.height),
      PApplet.map((float) ball.p.x, 0, 1, 0, pg.width) + dir.x * 500, 
      PApplet.map((float) ball.p.y, 0, 1, 0, pg.height) + dir.y * 500
      
      );
   
    
    pg.endDraw();
    return pg;
  }
}