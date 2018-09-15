import controlP5.*;
import processing.serial.*;

import cc.arduino.*;
import gab.opencv.*;
import blobDetection.*;



PImage cv;
PImage feed;
PImage pfeed;
PImage blur;
PImage difference;

Pad playerR;
Pad playerL;

Ball b;

Court court;


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
  pfeed = new PImage(640, 480);

  setupBD(feed);
  setupFilters(feed);

  setupGUI();
  cp5.loadProperties();

  // ----------------------------------------------------------------------
  // juego
  // ----------------------------------------------------------------------

  court = new Court(this, feed.width, feed.height);

  playerR = new Pad();
  playerR.side = Pad.RIGHT;
  playerR.setPos(0.97, 0.5);

  playerL = new Pad();
  playerL.side = Pad.LEFT;  
  playerL.setPos(0.03, 0.5);

  b = new Ball();
}

void draw() {
  background(0);

  feed = updateCam();
  int w = feed.width;
  int h = feed.height;

  image(feed, 0, 0);  // el tamanno de feed depende del ROI (devuelve un PImage de esas dimensiones)

  cv = getCV();

  difference = getdiff(cv);  
  setBackground(cv);

  detectBlobs(difference);

  image(cv, w, 0, w/2, h/2);
  image(difference, w, h/2, w/2, h/2);  
  image(bd, w+w/2, 0, w/2, h/2);

  if (calibrate) {
    b.setPosition(ballPos.getArrayValue()[0] * 1.0 / 100, ballPos.getArrayValue()[1] * 1.0 / 100);
    updateServo("A", map(b.pos.y, 1, 0, padR_min/255.0, padR_max/255.0));
    updateServo("B", map(b.pos.y, 1, 0, padL_min/255.0, padL_max/255.0));
  } else {
    Blob blob = getMovingBlob();
    if (blob != null) {
      b.setPosition(blob.x, blob.y);
    
    }

    updateServo("A", map(playerR.follow(court, this.b), 1, 0, padR_min/255.0, padR_max/255.0));
    updateServo("B", map(playerL.follow(court, this.b), 1, 0, padL_min/255.0, padL_max/255.0));
  }



  drawCourt();
  drawControls();
}

public void drawCourt() {
  image(court.render(b, playerR, playerL), 0, 0);
}


void SerialEvent(Serial port) {
  println(port.readString());
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
