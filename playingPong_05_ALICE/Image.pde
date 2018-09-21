//String feedUrl = "http://userx-pc:8080/cam_1.jpg";
String feedUrl = "http://127.0.0.1:8090/camera.mjpeg";
PGraphics camClean;
OpenCV opencv;

int blurLevel = 3;

import ipcapture.*;

IPCapture cam;

void setupCam() {
  camClean = createGraphics(640, 480, P3D);
  cam = new IPCapture(this, feedUrl, "", "");
  cam.start();
  // HINT si tironea saco true para que funcione en gray
  opencv = new OpenCV(this, camClean,false);
}

PImage updateCam() {

  if (cam.isAvailable()) {
    cam.read();
    camClean.beginDraw();
    camClean.image(cam, 0, 0);
    camClean.endDraw();
  }

  opencv.loadImage(camClean);
  opencv.setROI(91, 53, 471, 388); // dimensiones tomadas a mano.
  return opencv.getSnapshot(); //();
}

PImage getCV(){  
  opencv.blur(3, 3);
  opencv.brightness(1);
  opencv.contrast(1);
  return opencv.getSnapshot();
}

PImage cvblur(PImage difference) {
 // println("cvblur()");
  opencv.loadImage(difference);
  opencv.blur(blurLevel);  
  return opencv.getSnapshot();
}
