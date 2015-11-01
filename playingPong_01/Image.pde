String feedUrl = "http://userx-pc:8080/cam_1.jpg";

PImage cam;
PGraphics camClean;
OpenCV opencv;
ArrayList<Line> lines;

void setupCam() {
  cam = loadImage(feedUrl);
  camClean = createGraphics(720, 480, P3D);
  
  opencv = new OpenCV(this, cam);
  

 
  
}

PImage getFeed() {
  cam = loadImage(feedUrl);
  camClean.beginDraw();
  camClean.image(cam,0,0);
  camClean.endDraw();
  return camClean;
}

PImage getLines(){
     cam = loadImage(feedUrl);
   opencv.loadImage(cam);
  // Find lines with Hough line detection
  // Arguments are: threshold, minLengthLength, maxLineGap
  opencv.findCannyEdges(150, 200);
   lines = opencv.findLines(20, 100, 100);
   
   camClean.beginDraw();
   camClean.image(opencv.getOutput(), 0, 0);
   
   for (Line line : lines) {
    // lines include angle in radians, measured in double precision
    // so we can select out vertical and horizontal lines
    // They also include "start" and "end" PVectors with the position
    if (line.angle >= radians(0) && line.angle < radians(1)) {
      camClean.stroke(0, 255, 0);
      camClean.line(line.start.x, line.start.y, line.end.x, line.end.y);
    }

    if (line.angle > radians(89) && line.angle < radians(91)) {
      camClean.stroke(255, 0, 0);
      camClean.line(line.start.x, line.start.y, line.end.x, line.end.y);
    }
  }
   camClean.endDraw();
  
  return camClean;
}