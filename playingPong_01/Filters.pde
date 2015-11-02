PShader diff;
PGraphics diffBuffer;
PGraphics bg;
float diffMinValue = 0.01;
float diffMaxValue = 0.1;

float gain = 1.0;
int filterW = 720;
int filterH = 480;




void setupFilters(){
  
  bg = createGraphics(filterW, filterH, P3D);
  diffBuffer = createGraphics(filterW, filterH, P3D);

  diff = loadShader("shaders/diff.glsl");
  diff.set("diffMinValue", diffMinValue);
  diff.set("diffMaxValue", diffMaxValue);
  diff.set("gain", gain);
}


void setBackground(PImage image){
  bg.beginDraw();
  bg.background(0);
  bg.image(image, 0,0, bg.width, bg.height);  
  bg.endDraw();
  // importante: aca le paso al shader que hace el diff la textura sobre la cual va a restar 
  diff.set("previo", bg);
}

PImage getdiff(PImage video){    
  if (diffBuffer != null && video != null) { 
        println("diff()");      
        diffBuffer.beginDraw();
        diffBuffer.background(0);
        diffBuffer.shader(diff); // si uso el shader como filtro tiene que ser de tipo TEXTURE
        diffBuffer.image(video, 0, 0); // como uso image() el filtro tiene que ser TEXTURE (es razonable ya que yo no estoy creando ninguna geometría)        
        diffBuffer.endDraw();
        diffBuffer.loadPixels();
    }    
    
    return diffBuffer; 
}