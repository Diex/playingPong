ControlP5 cp5;
CallbackListener cb;
Textarea myTextarea;
Println console;

Slider2D ballPos;
void setupGUI() {
  cp5 = new ControlP5(this);

  int top = 10;
  Group padsGroup = cp5.addGroup("pads")
    .setPosition(10, 400)
    .setWidth(300)
    .activateEvent(true)
    .setLabel("pads");

  cp5.addToggle("calibrate")  //
    .setPosition(5, top + 0)
    .setId(0)
    .setGroup("pads");

  ballPos = cp5.addSlider2D("ballPosition")
    .setPosition(50, top +  0)
    .setSize(100, 100)
    .setArrayValue(new float[] {
    1.0, 1.0
    }
    )
    .setGroup("pads");


  cp5.addSlider("padR_min")
    .setPosition(160, top + 0)
    .setRange(0, 255)
    .setValue(0)
    .setGroup("pads");
  ;

  cp5.addSlider("padR_max")
    .setPosition(160, top +  25)
    .setRange(0, 255)
    .setValue(255)
    .setGroup("pads");
  ;

  cp5.addSlider("padL_min")
    .setPosition(160, top + 50)
    .setRange(0, 255)
    .setValue(0)
    .setGroup("pads");
  ;

  cp5.addSlider("padL_max")
    .setPosition(160, top + 75)
    .setRange(0, 255)
    .setValue(255)
    .setGroup("pads");
  ;

 // -----------------------------------------------------------------------------------------------
 // -----------------------------------------------------------------------------------------------


  Group diffGroup = cp5.addGroup("diff")
    .setPosition(320, 400)
    .setWidth(200)
    .activateEvent(true)
    .setLabel("difference.")
    ;

  cp5.addSlider("diffMinValue")
    .setPosition(15, 10)
    .setRange(0.0, 0.3)
    .setGroup(diffGroup)
    .init();
  ;
  cp5.addSlider("diffMaxValue")
    .setPosition(15, 30)
    .setRange(0, 1.0)
    .setGroup(diffGroup)
    ;

  cp5.addSlider("blurLevel").
    setPosition(15, 50)
    .setRange(1, 105)
    .setGroup(diffGroup)
    .init();
  ;

  cp5.addSlider("cvth")
    .setPosition(15, 70)
    .setRange(1, 100)
    .setGroup(diffGroup)
    .init();
  ;

  cp5.addSlider("gain")
    .setPosition(15, 90)
    .setRange(0.01, 4.0)
    .setGroup(diffGroup)
    .init();
  ;

  // -----------------------------------------------------------------------------------------------

  Group detectGroup = cp5.addGroup("detect")
    .setPosition(320, 500)
    .setWidth(200)
    .activateEvent(true)
    .setBackgroundColor(color(0, 200))
    .setBackgroundHeight(180)
    .setLabel("detection.")
    ;

  cp5.addSlider("minSize")  //
    .setPosition(15, 30)
    .setRange(30, 100)
    .setGroup("detect");
  cp5.addSlider("maxSize")  //
    .setPosition(15, 50)
    .setRange(50, 200)
    .setGroup("detect");
  cp5.addSlider("maxArea")   //
    .setPosition(15, 70)
    .setRange(2000., 6000.)
    .setGroup("detect");
  cp5.addSlider("maxSegments") //
    .setPosition(15, 90)
    .setRange(4, 35)
    .setGroup("detect");
  cp5.addSlider("maxDefects")  //
    .setPosition(15, 110)
    .setRange(1, 25)
    .setGroup("detect");
  cp5.addSlider("maxAverage")  //
    .setPosition(15, 130)
    .setRange(10., 250.)
    .setGroup("detect");
    
    
    
    
  //detectGroup.hide();
  //diffGroup.hide();



  cb = new CallbackListener() {    
    public void controlEvent(CallbackEvent theEvent) {    
      diff.set("diffMinValue", diffMinValue);
      diff.set("diffMaxValue", diffMaxValue);
      diff.set("gain", gain);
    }
  };

  // add the above callback to controlP5
  cp5.addCallback(cb);
  cp5.setAutoDraw(false);
}

void drawControls() {
  cp5.draw();
}

void renderGUI(PImage a, PImage b, PImage c, 
  PImage d, PImage e, PImage f, boolean drawControls) {
  noFill();
  stroke(255, 0, 0);
  if (a != null) image(a, 0, 0, 320, 240);  
  if (b != null) image(b, 320, 0, 320, 240);  
  if (c != null) image(c, 640, 0, 320, 240);
  //
  if (d != null) image(d, 0, 240, 320, 240);
  if (e != null) image(e, 320, 240, 320, 240);
  if (f != null) image(f, 640, 240, 320, 240);

  rect(  0, 0, 320, 240);
  rect(320, 0, 320, 240);  
  rect(640, 0, 320, 240);
  ////
  rect(0, 240, 320, 240);
  rect(320, 240, 320, 240);
  rect(640, 240, 320, 240);
}
