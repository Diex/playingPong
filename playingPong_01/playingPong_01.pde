import controlP5.*;

import gab.opencv.*;
import blobDetection.*;


Court court;
PImage difference;

//void settings() {
//  size(1024, 768, P3D);
//}

int debugWidth;
int debugHeight;
PImage feed;

void setup() {
  size(1024, 768, P3D);
  court = new Court(this);
  setupCam();  
  setupBD(getFeed().width, getFeed().height);
  setupFilters();
  setBackground(getFeed());
  feed = getFeed(); 

  debugWidth = width - feed.width;
  debugHeight = feed.height * (width - feed.width) / feed.width;
  
//  setupGUI();
}

void draw() {
  updateCam();
  
  feed = getFeed();
  
  difference = getdiff(feed);
 
  //println(feed);

  setBackground(feed);
  
  detectBlobs(difference);
  
  image(difference , 0, 0);
  image(bd,   feed.width, 0, debugWidth, debugHeight   );
  image(feed, feed.width, debugHeight, debugWidth, debugHeight);

  court.render();
//  drawControls();
}
