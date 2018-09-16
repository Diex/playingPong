/* IPCapture sample sketch for Java and Android   *
 *                                                *
 * === IMPORTANT ===                              *
 * In Android mode, Remember to enable            *
 * INTERNET permissions in the                    *
 * Android -> Sketch permissions menu             */

import ipcapture.*;

IPCapture cam;


// stream  ffmpeg -f v4l2 -i /dev/video0 http://localhost:8090/camera.ffm
// server ffserver -f server.conf
// y el conf:
/*
HTTPPort            8090
HTTPBindAddress     0.0.0.0
MaxHTTPConnections 200
MaxClients      100
MaxBandWidth    500000
CustomLog       -

<Feed camera.ffm>
        File            /tmp/camera.ffm
FileMaxSize     200M
</Feed>

<Stream camera.mjpeg>
Feed camera.ffm
Format mpjpeg
VideoFrameRate 15
VideoIntraOnly
VideoBitRate 4096
VideoBufferSize 4096
VideoSize 640x480
VideoQMin 5
VideoQMax 51
NoAudio
Strict -1
</Stream>


*/


void setup() {
  size(640,500);
  cam = new IPCapture(this, "http://127.0.0.1:8090/camera.mjpeg", "", "");
  cam.start();
  
  // this works as well:
  
  // cam = new IPCapture(this);
  // cam.start("url", "username", "password");
  
  // It is possible to change the MJPEG stream by calling stop()
  // on a running camera, and then start() it with the new
  // url, username and password.
}

void draw() {
  if (cam.isAvailable()) {
    cam.read();
    image(cam,0,0);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (cam.isAlive()) cam.stop();
    else cam.start();
  }
}
