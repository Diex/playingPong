import controlP5.*;
import processing.serial.*;

import cc.arduino.*;
import gab.opencv.*;
import blobDetection.*;

Court court;


PImage cv;
PImage feed;
PImage pfeed;
PImage blur;

PImage difference;

Pad playerR;
Pad playerL;
boolean calibrate = false; 

int padR_min, padL_min = 0;
int padR_max, padL_max = 255;

void setup() {
  size(1366, 768, P3D);
  // ----------------------------------------------------------------------
  // hardware
  // ----------------------------------------------------------------------
  setupArduino();
  setupCam();  
  feed = updateCam();
  pfeed = new PImage(640,480);

  setupBD(feed);
  setupFilters(feed);
  
  setupGUI();
  cp5.loadProperties();
  
  // ----------------------------------------------------------------------
  // juego
  // ----------------------------------------------------------------------

  court = new Court(this, feed.width, feed.height);

  playerR = new Pad(court);
  playerR.side = Pad.RIGHT;
  playerR.setPos(0.97, 0.5);

  playerL = new Pad(court);
  playerL.side = Pad.LEFT;  
  playerL.setPos(0.03, 0.5);
}

void draw() {
  background(0);
  
  feed = updateCam();
  int w = feed.width;
  int h = feed.height;
  
  image(feed, 0,0);  // el tamanno de feed depende del ROI (devuelve un PImage de esas dimensiones)
  
  cv = getCV();
  image(cv, w, 0, w/2,h/2);
  
  difference = getdiff(cv);  
  setBackground(cv);
  
  image(difference, w, h/2, w/2,h/2);  
  detectBlobs(difference);
   
  image(bd, w+w/2, 0   );
  drawCourt();


/**

  feed = updateCam();
  cv = getCV();
  image(cv, w,0, w/2,h/2);


  difference = getdiff(cv);

  
  //blur = cvblur(difference);  
  //detectBlobs(blur);
  detectBlobs(difference);
  pfeed.copy(feed, 0,0,w,h,0,0,w,h);
  setBackground(pfeed);    
**/
  
  // pads
  if (calibrate) {
    court.setBallPosition(ballPos.getArrayValue()[0] * 1.0 / 100, ballPos.getArrayValue()[1] * 1.0 / 100);
     
    updateServo("A", map(court.ball.p.y, 1.0, 0.0, padR_min/255.0, padR_max/255.0));
    updateServo("B", map(court.ball.p.y, 1.0, 0.0, padL_min/255.0, padL_max/255.0));
  } else {
    Blob b = getMovingBlob();
    court.update(b);
    
    updateServo("A", map(playerR.follow(), 1, 0, padR_min/255.0, padR_max/255.0));
    updateServo("B", map(playerL.follow(), 1, 0, padL_min/255.0, padL_max/255.0));
  }

  //drawCourt();

  //image(feed, 0, 0);
  //image(opencv.getSnapshot(opencv.getROI()), 0,0);


 // image(feed, feed.width, debugWindowH, debugWindowW, debugWindowH);
  drawControls();
}

public void drawCourt() {
 
  
 image(court.render(),feed.width*1.5, 0);
 
}


public void centerPads() {
  println("center pads");
  //updateServoR(map(0.5, 0, 1, 45, 145) - 10 );
  //updateServoL(map(0.5, 0, 1, 45, 145) - 10 );
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
