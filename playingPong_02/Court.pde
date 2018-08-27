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

  Court(PApplet parent, int w, int h) {
    p = parent;  
    pg = p.createGraphics(w, h, P3D);

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

  void update(Blob blob) {
    if (blob == null) return;    
    PVector v = getCourtPositionFromBlob(blob);    
    setBallPosition(v.x, v.y);
  }

  PVector getCourtPositionFromBlob(Blob blob) {
    // normalized blob to screen
    // porque el blob detection esta viendo toda la imagen
    float screenX = PApplet.map(blob.x, 0, 1, 0, pg.width);
    float screenY = PApplet.map(blob.y, 0, 1, 0, pg.height);
    // screen to norm limits frame
    float nx = PApplet.map(screenX, xx1, xx2, 0.0, 1.0) ;
    float ny = PApplet.map(screenY, yy1, yy2, 0.0, 1.0);
    println("ball position: ", nx, ny);
    return new PVector(screenX, screenY);
  }

  void setBallPosition(float x, float y) {
    ball.pp.x = ball.p.x;
    ball.pp.y = ball.p.y;
    ball.p.x = ease(x, ball.pp.x, 0.95);
    ball.p.y = ease(y, ball.pp.y, 0.95);
  }

  public PVector bounce() {
    PVector collision = new PVector();

    Vect2[] line1 = new Vect2[ 2 ];
    line1[ 0 ] = new Vect2( ball.p.x, ball.p.y );
    line1[ 1 ] = new Vect2( ball.p.x + ball.dir().x, ball.p.y + ball.dir().y );

    Vect2[]line2 = new Vect2[ 2 ];

    if (court.ball.dir().y <= 0) { // choca arriba

      //println("rebota arriba");
      line2[ 0 ] = new Vect2((float) top.getX1(), (float) top.getY1());
      line2[ 1 ] = new Vect2((float) top.getX2(), (float) top.getY2()); // will be updateed by the mouse
    } else { //choca abajo
      //println("rebota abajo");
      line2[ 0 ] = new Vect2((float) bottom.getX1(), (float) bottom.getY1());
      line2[ 1 ] = new Vect2((float) bottom.getX2(), (float) bottom.getY2()); // will be updateed by the mouse
    }

    Vect2 intersectionPoint = Space2.lineIntersection( line1[ 0 ], line1[ 1 ], line2[ 0 ], line2[ 1 ] );

    if ( intersectionPoint != null ) {
      //      println("ÏNTERSECTION");
      collision.x = intersectionPoint.x;
      collision.y = intersectionPoint.y;
    }

    return collision;
  }

  PVector getReflection(PVector bounce) {
    PVector target = new PVector();
    // si no hay una colision directa puede que haya una colision contra la pared      

    // si existe esa colision
    if (bounce.x > 0 && bounce.x < 1) {
      // caculo la direccion entre ese punto y la direccion reflejada en el eje y
      PVector normal = bounce.y > 0.5 ? new PVector(0, -1) : new PVector(0, 1);

      // normalized incidence vector
      PVector incidence = PVector.mult(court.ball.dir(), -1);
      incidence.normalize();

      // calculate dot product of incident vector and base top normal 
      float dot = incidence.dot(normal);

      // calculate reflection vector
      // assign reflection vector to direction vector
      target.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y, 0);
    }
    return target;
  }


  private PVector getCollision(PVector bounce, PVector direction, PVector a, PVector b)
  {
    PVector collision = new PVector();
    Vect2[] line1 = new Vect2[ 2 ];
    line1[ 0 ] = new Vect2( bounce.x, bounce.y );
    line1[ 1 ] = new Vect2( bounce.x + direction.x, bounce.y + direction.y );

    Vect2[]line2 = new Vect2[ 2 ];

    line2[ 0 ] = new Vect2((float) a.x, (float) a.y);
    line2[ 1 ] = new Vect2((float) b.x, (float) b.y); // will be updateed by the mouse


    Vect2 intersectionPoint = Space2.lineIntersection( line1[ 0 ], line1[ 1 ], line2[ 0 ], line2[ 1 ] );

    if ( intersectionPoint != null ) {
      collision.x = intersectionPoint.x;
      collision.y = intersectionPoint.y;
    }

    return collision;
  }

  public PVector getCollisionWithPad(Pad p) {

    PVector collision = getCollision(ball.p, ball.dir(), new PVector(p.p.x, 0), new PVector(p.p.x, 1));

    if (collision != null && collision.y > 0.0 && collision.y < 1.0) {        
      //   println("colision en: ", collision.x, collision.y);  
      // itero sobre los bounces
      return collision;
    } else {
      //       println("buscar refleccion: ");
      PVector bounce = bounce();        
      collision = getCollision(bounce, getReflection(bounce), new PVector(p.p.x, 0), new PVector(p.p.x, 1));
      //       println("refleccion en: ", collision.x , collision.y);
      return collision;
    }
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





  void drawReflection(PVector collision, PVector newdir) {
    pg.beginDraw();
    pg.pushStyle();
    pg.noFill();
    pg.stroke(0, 0, 255);
    pg.ellipse( 
      PApplet.map((float) collision.x, 0, 1, xx1, xx2), 
      PApplet.map((float) collision.y, 0, 1, yy1, yy2), 
      12, 12
      );   


    pg.strokeWeight(0.5);
    pg.stroke(255, 255, 255);
    // direction
    pg.line(
      PApplet.map((float) collision.x, 0, 1, xx1, xx2), 
      PApplet.map((float) collision.y, 0, 1, yy1, yy2), 
      PApplet.map((float) collision.x, 0, 1, xx1, xx2) + newdir.x * 500, 
      PApplet.map((float) collision.y, 0, 1, yy1, yy2) + newdir.y * 500
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

    clear();
    drawLimits();
    drawPad(playerR);
    drawPad(playerL);
    court.drawBall();
    //PVector bounce = court.bounce();
    //court.drawCollision(bounce);
    //court.drawReflection(bounce, court.getReflection(bounce));

    //court.drawCollision(court.getCollisionWithPad(playerR));
    //court.drawCollision(court.getCollisionWithPad(playerL));


    return pg;
  }


  void clear() {
    pg.beginDraw();
    pg.background(0, 0);
    pg.endDraw();
  }

  void drawLimits() {
    pg.beginDraw();
    pg.pushStyle();
    pg.strokeWeight(3);
    pg.stroke(255, 0, 0);
    for (Line2D line : limits) {
      pg.line((float) line.getX1() * bg.width, (float) line.getY1() * bg.height, (float) line.getX2()* bg.width, (float) line.getY2() * bg.height);
    }

    pg.popStyle();
    pg.endDraw();
  }

  void drawPad(Pad p) {
    pg.beginDraw();
    pg.pushStyle();
    pg.noStroke();
    pg.fill(255, 0, 0);
    pg.rectMode(PConstants.CENTER); 
    pg.rect(
      p.p.x * pg.width,
      p.p.y * pg.height,
      8, 
      30);

    pg.popStyle();
    pg.endDraw();
  }

  void drawBall() {
    pg.beginDraw();
    pg.pushStyle();
    pg.fill(0, 255, 0);
    // ball
    pg.ellipse( 
    ball.p.x * pg.width,
    ball.p.y * pg.height,
    10, 10
      );   

    PVector dir = ball.dir();
    dir.normalize();
    pg.strokeWeight(1);
    pg.stroke(255, 255, 0);
    // direction
    pg.line(
      ball.p.x * pg.width, 
      ball.p.y * pg.height, 
      ball.p.x * pg.width + dir.x * 500, 
      ball.p.y * pg.height + dir.y * 500      
     );

    pg.strokeWeight(0.51);
    pg.stroke(255, 255, 255);
    // crosshatch
    pg.line(
     ball.p.x * pg.width, 0,
     ball.p.x * pg.width, pg.height
     );
    
    pg.line(
      0, ball.p.y * pg.height,
      pg.width, ball.p.y * pg.height);

    pg.popStyle();
    pg.endDraw();
  }
  float ease(float current, float last, float factor) {
    return current * factor + last * (1 - factor);
  }
}
