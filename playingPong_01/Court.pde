import java.awt.geom.Line2D;
import blobDetection.*;
class Court {
  PApplet p;
  PGraphics pg;

  Line2D top;
  Line2D bottom;
  Line2D right;
  Line2D left;

  Line2D[] limits;

  float yy1 = 58;
  float yy2 = 422;
  float xx1 = 105;
  float xx2 = 618;
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

  void updateBall(Blob blob) {
    if (blob == null) return;
    
    setBallPosition(blob.x, blob.y);
  }
  
  void setBallPosition(float x, float y) {
    ball.pp.x = ease(ball.pp.x, ball.p.x, 0.1);
    ball.pp.y = ease(ball.pp.y, ball.p.y, 0.1);
    
    // normalized blob to screen
    float screenX = PApplet.map(x, 0, 1, 0, pg.width);
    float screenY = PApplet.map(y, 0, 1, 0, pg.height); 
    // screen to norm limits frame
    ball.p.x = PApplet.map(screenX, xx1, xx2, 0.0, 1.0) ;
    ball.p.y = PApplet.map(screenY, yy1, yy2, 0.0, 1.0);
  }
  
  public PVector bounce() {
    PVector collision = new PVector();
    Vect2[] line1 = new Vect2[ 2 ];
    line1[ 0 ] = new Vect2( ball.p.x, ball.p.y );
    line1[ 1 ] = new Vect2( ball.p.x + ball.dir().x, ball.p.y + ball.dir().y );

    Vect2[]line2 = new Vect2[ 2 ];

    if (court.ball.dir().y <= 0) { // choca arriba
      line2[ 0 ] = new Vect2((float) top.getX1(), (float) top.getY1());
      line2[ 1 ] = new Vect2((float) top.getX2(), (float) top.getY2()); // will be updateed by the mouse
    } else { //choca abajo
      line2[ 0 ] = new Vect2((float) bottom.getX1(), (float) bottom.getY1());
      line2[ 1 ] = new Vect2((float) bottom.getX2(), (float) bottom.getY2()); // will be updateed by the mouse
    }

    Vect2 intersectionPoint = Space2.lineIntersection( line1[ 0 ], line1[ 1 ], line2[ 0 ], line2[ 1 ] );

    if ( intersectionPoint != null ) {
      println("ÏNTERSECTION");
      collision.x = intersectionPoint.x;
      collision.y = intersectionPoint.y;
    }

    return collision;
  }


  void clear() {
    pg.beginDraw();
    pg.background(0, 0);
    pg.endDraw();
  }

  void drawPad(Pad p) {
    pg.beginDraw();
    pg.pushStyle();
    pg.noStroke();
    pg.fill(255, 0, 0);
    pg.rectMode(PConstants.CENTER); 
    pg.rect(
    PApplet.map((float) p.p.x, 0, 1, xx1, xx2), 
    PApplet.map((float) p.p.y, 0, 1, yy1, yy2), 
    8, 
    30);

    pg.popStyle();
    pg.endDraw();
  }


  void drawCollision(PVector p) {
    pg.beginDraw();
    pg.pushStyle();
    pg.fill(255, 0, 0);
    pg.ellipse( 
    PApplet.map((float) p.x, 0, 1, xx1, xx2), 
    PApplet.map((float) p.y, 0, 1, yy1, yy2), 
    10, 10
      );   
    pg.popStyle();
    pg.endDraw();
  }
  void drawBall() {
    pg.beginDraw();
    pg.pushStyle();
    pg.fill(0, 255, 0);
    // ball
    pg.ellipse( 
    PApplet.map((float) ball.p.x, 0, 1, xx1, xx2), 
    PApplet.map((float) ball.p.y, 0, 1, yy1, yy2), 
    10, 10
      );   

    PVector dir = ball.dir();
    dir.normalize();
    pg.strokeWeight(1);
    pg.stroke(255, 255, 0);
    // direction
    pg.line(
    PApplet.map((float) ball.p.x, 0, 1, xx1, xx2), 
    PApplet.map((float) ball.p.y, 0, 1, yy1, yy2), 
    PApplet.map((float) ball.p.x, 0, 1, xx1, xx2) + dir.x * 500, 
    PApplet.map((float) ball.p.y, 0, 1, yy1, yy2) + dir.y * 500
      );

    pg.strokeWeight(0.51);
    pg.stroke(255, 255, 255);
    // crosshatch
    pg.line(
    PApplet.map((float) ball.p.x, 0, 1, xx1, xx2), yy1, 
    PApplet.map((float) ball.p.x, 0, 1, xx1, xx2), yy2);
    pg.line(
    xx1, PApplet.map((float) ball.p.y, 0, 1, yy1, yy2), 
    xx2, PApplet.map((float) ball.p.y, 0, 1, yy1, yy2));

    pg.popStyle();
    pg.endDraw();
  }


  PImage render() {
    pg.beginDraw();
    pg.pushStyle();
    pg.strokeWeight(3);
    pg.stroke(255, 0, 0);
    for (Line2D line : limits) {
      pg.line(
      PApplet.map((float) line.getX1(), 0, 1, xx1, xx2), 
      PApplet.map((float) line.getY1(), 0, 1, yy1, yy2), 
      PApplet.map((float) line.getX2(), 0, 1, xx1, xx2), 
      PApplet.map((float) line.getY2(), 0, 1, yy1, yy2));
    }
    pg.popStyle();
    pg.endDraw();
    return pg;
  }

  float ease(float current, float last, float factor) {
    return current * factor + last * (1 - factor);
  }
}

