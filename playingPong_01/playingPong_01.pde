import gab.opencv.*;

void settings(){
  size(1024, 768, P3D);
}

void setup(){
  setupCam();
}

void draw(){
  image(getLines(), 0, 0);
}