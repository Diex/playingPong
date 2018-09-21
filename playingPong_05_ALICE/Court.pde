import java.awt.geom.Line2D;
import blobDetection.*;

class Court {
  
  PApplet p;
  PGraphics pg;
  PFont futura = createFont("Futura", 48);

  Line2D top;
  Line2D bottom;
  Line2D right;
  Line2D left;

  Line2D[] limits;
  


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
  }

 PImage render(Ball ball, Pad r, Pad l) {

    clear();
    drawLimits();
   // drawPad(r);
   // drawPad(l);
    drawBall(ball);
    
    //PVector bounce = Collisions.bounce(this, ball);
    //court.drawCollision(bounce);
    //court.drawReflection(bounce, Collisions.reflection(bounce, ball), ball);

    court.drawCollision(Collisions.getCollisionWithPad(this, r, ball));
    court.drawCollision(Collisions.getCollisionWithPad(this, l, ball));


    return pg;
  }

  void drawCollision(PVector p) {
    pg.beginDraw();
    pg.pushStyle();
    pg.fill(0, 0, 255);
   
    pg.ellipse( 
    p.x * pg.width,
    p.y * pg.height,    
      10, 10
    );   
    pg.popStyle();
    pg.endDraw();
  }


  void drawReflection(PVector collision, PVector newdir, Ball ball) {
    pg.beginDraw();
    pg.pushStyle();
    pg.noFill();
    pg.stroke(0, 0, 255);
    pg.ellipse( 
    collision.x * pg.width,
    collision.y * pg.height,
      12, 12
      );   


    pg.strokeWeight(0.5);
    pg.stroke(255, 255, 255);
    // direction
    pg.line(
    collision.x * pg.width,
    collision.y * pg.height,
    collision.x * pg.width  + newdir.x * 500,
    collision.y * pg.height + newdir.y * 500
     
      );

    pg.strokeWeight(0.51);
    pg.stroke(255, 255, 255);
    // crosshatch
    // crosshatch
    pg.line(
     ball.pos.x * pg.width, 0,
     ball.pos.x * pg.width, pg.height
     );
    
    pg.line(
      0, ball.pos.y * pg.height,
      pg.width, ball.pos.y * pg.height
      );

    pg.popStyle();
    pg.endDraw();
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

  void drawBall(Ball ball) {
    pg.beginDraw();
    pg.pushStyle();
    pg.fill(0, 255, 0);
    // ball
    pg.ellipse( 
    ball.pos.x * pg.width,
    ball.pos.y * pg.height,
    10, 10
      );   

    PVector dir = ball.dir();
    dir.normalize();
    pg.strokeWeight(1);
    pg.stroke(255, 255, 0);
    // direction
    pg.line(
      ball.pos.x * pg.width, 
      ball.pos.y * pg.height, 
      ball.pos.x * pg.width + dir.x * 500, 
      ball.pos.y * pg.height + dir.y * 500      
     );

    pg.strokeWeight(0.51);
    pg.stroke(255, 255, 255);
    // crosshatch
    pg.line(
     ball.pos.x * pg.width, 0,
     ball.pos.x * pg.width, pg.height
     );
    
    pg.line(
      0, ball.pos.y * pg.height,
      pg.width, ball.pos.y * pg.height
      );

    
    pg.textFont(futura);
    pg.textSize(18);
    pg.fill(255);
    pg.text("+ \n" + nfc(ball.pos.x, 2) + '\n'+ nfc(ball.pos.y, 2),  5 + ball.pos.x * pg.width, ball.pos.y * pg.height);
    pg.popStyle();
    pg.endDraw();
  }

}
