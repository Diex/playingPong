class Ball {

  PVector pos, ppos;

  Ball() {
    pos = new PVector();
    ppos = new PVector();
  }

  PVector dir() {
    PVector dir = PVector.sub(pos, ppos);
    dir.normalize();
    return  dir;
  }


  void setPosition(float x, float y) {
    ppos.x = pos.x;
    ppos.y = pos.y;
    pos.x = ease(x, ppos.x, 0.93);
    pos.y = ease(y, ppos.y, 0.93);
  }
  
  
  float ease(float current, float last, float factor) {
    return current * factor + last * (1 - factor);
  }
}
