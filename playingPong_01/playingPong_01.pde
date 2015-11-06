import controlP5.*;
import processing.serial.*;

import cc.arduino.*;
import gab.opencv.*;
import blobDetection.*;

Court court;

int debugWindowW;
int debugWindowH;

PImage blur;
PImage difference;
PImage feed;
Pad playerR;
Pad playerL;
boolean calibrate = false; 

int padR_min, padL_min =0;
int padR_max, padL_max =255;
void setup() {
  size(1366, 768, P3D);
  // ----------------------------------------------------------------------
  // hardware
  // ----------------------------------------------------------------------

  setupArduino();
  setupCam();  
  feed = updateCam();

  setupBD(feed.width, feed.height);
  setupFilters();
  setBackground(feed); 

  setupGUI();
  cp5.loadProperties();

  debugWindowW = (int) ((width - feed.width) * 0.75);
  debugWindowH = (int) ((feed.height * (width - feed.width) / feed.width) * 0.75);

  // ----------------------------------------------------------------------
  // juego
  // ----------------------------------------------------------------------

  court = new Court(this);

  playerR = new Pad(court);
  playerR.side = Pad.RIGHT;
  playerR.setxPos(0.975);

  playerL = new Pad(court);
  playerL.side = Pad.LEFT;  
  playerL.setxPos(0.025);


  updateServoR(0.5);
  updateServoL(0.5);
}

void draw() {
  background(0);
  // video processing  
  feed = updateCam();
  difference = getdiff(feed);  
  setBackground(feed);  
  blur = cvblur(difference);  
  detectBlobs(blur);

  // pads
  if (calibrate) {
    court.setBallPosition(ballPos.arrayValue()[0] * 1.0 / 100, ballPos.arrayValue()[1] * 1.0 / 100);
    updateServoR(map(court.ball.p.y, 1, 0, padR_min, padR_max));
    updateServoL(map(court.ball.p.y, 1, 0, padL_min, padL_max));
    println(1 - court.ball.p.y);
  } else {
    court.update(getMovingBlob());
    updateServoR(map(playerR.follow(), 1, 0, padR_min, padR_max));
    updateServoL(map(playerL.follow(), 1, 0, padL_min, padL_max));
  }



  court.clear();
  court.drawPad(playerR);
  court.drawPad(playerL);
  court.drawBall();
  PVector bounce = court.bounce();
  court.drawCollision(bounce);
  court.drawReflection(bounce, court.getReflection(bounce));
  
  court.drawCollision(court.getCollisionWithPad(playerR));
  court.drawCollision(court.getCollisionWithPad(playerL));

  image(feed, -5, 0);
  image(court.render(), 0, 0);
  image(bd, feed.width, 0, debugWindowW, debugWindowH   );
  image(feed, feed.width, debugWindowH, debugWindowW, debugWindowH);
  drawControls();
}

public void centerPads() {
  println("center pads");
  updateServoR(map(0.5, 0, 1, 45, 145) - 10 );
  updateServoL(map(0.5, 0, 1, 45, 145) - 10 );
}

public void calibrate(boolean flag) {
  println("Calibrate");
  calibrate = flag;
}


void keyPressed() {
  if (key == 'c') calibrate = !calibrate;    
  if (key == 'r') {
    playerR.reset();
    playerL.reset();
  }

  if (key == 's') cp5.saveProperties();
  if (key == 'l') cp5.loadProperties();
}

