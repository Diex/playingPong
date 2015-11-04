String feedUrl = "http://userx-pc:8080/cam_1.jpg";

PGraphics camClean;
OpenCV opencv;
PImage prevFrame;
int blurLevel = 3;

void setupCam() {
  camClean = createGraphics(720, 480, P3D);
  opencv = new OpenCV(this, camClean);
 
}

PImage updateCam() {
  prevFrame = camClean;
  camClean.beginDraw();
  camClean.image(loadImage(feedUrl), 0, 0);
  camClean.endDraw();
  return getFeed();
}

PImage getFeed() {
  opencv.loadImage(camClean);
  opencv.gray();
  opencv.blur(2,2);
  opencv.brightness(1);
  opencv.contrast(1);
  opencv.threshold(75);
  return opencv.getSnapshot();
}

PImage cvblur(PImage difference) {
 // println("cvblur()");
  opencv.loadImage(difference);
  opencv.blur(blurLevel);  
  return opencv.getSnapshot();
}
