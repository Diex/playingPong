import controlP5.*;
import processing.serial.*;

import cc.arduino.*;
import gab.opencv.*;
import blobDetection.*;

Court court;

int debugWidth;
int debugHeight;
PImage blur;
PImage difference;
PImage feed;
Pad player;

boolean calibrate = false; 

void setup() {
  size(1024, 768, P3D);
  court = new Court(this);
  setupArduino();
  setupCam();  
  feed = updateCam();
    
  setupBD(feed.width, feed.height);
  setupFilters();
  setBackground(feed); 
  
  debugWidth = width - feed.width;
  debugHeight = feed.height * (width - feed.width) / feed.width;
  
  setupGUI();
  player = new Pad(court);  
  player.setxPos(0.975);
  updateServoR(0.5);
 }

void draw() {
  background(0);
  
  feed = updateCam();
  
  difference = getdiff(feed);  
  setBackground(feed);  
  blur = cvblur(difference);  
  detectBlobs(blur);
  
  
  if(!calibrate){
    court.updateBall(getMovingBlob());
    updateServoR(map(player.follow() , 0, 1, 45, 145) - 10 );
  }else{
    court.setBallPosition(mouseX * 1.0 / width,mouseY * 1.0 / height);
    updateServoR(map(1 - court.ball.p.y , 0, 1, 45, 145));
    println(1 - court.ball.p.y);    
  }
 
  

  court.clear();
  court.drawPad(player);
  court.drawBall();
  court.drawCollision(court.bounce());
  
  
  image(feed, 0, 0);
  image(court.render() , 0, 0);
  image(bd,   feed.width, 0, debugWidth, debugHeight   );
  image(feed, feed.width, debugHeight, debugWidth, debugHeight);
  drawControls();
  
}

void keyPressed(){
    if(key == 'c') calibrate = !calibrate;    
    println("servoR");
}
