import controlP5.*;

import gab.opencv.*;
import blobDetection.*;

Court court;

int debugWidth;
int debugHeight;
PImage blur;
PImage difference;
PImage feed;

void setup() {
  size(1024, 768, P3D);
  court = new Court(this);
  
  setupCam();  
  feed = updateCam();
    
  setupBD(feed.width, feed.height);
  setupFilters();
  setBackground(feed); 
  
  debugWidth = width - feed.width;
  debugHeight = feed.height * (width - feed.width) / feed.width;
  
  setupGUI();
  
 }

void draw() {
  background(0);
  
  feed = updateCam();
  
  difference = getdiff(feed);  
  setBackground(feed);
  
  blur = cvblur(difference);
  detectBlobs(blur);
  
  court.updateBall(getMovingBlob());
  
  image(court.render() , 0, 0);
  image(bd,   feed.width, 0, debugWidth, debugHeight   );
  image(feed, feed.width, debugHeight, debugWidth, debugHeight);
  drawControls();
  
}