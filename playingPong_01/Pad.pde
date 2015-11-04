     import point2line.*;

class Pad {
  // my side of the court
  final static int LEFT = -1;
  final static int RIGHT = 1;

  PVector p;
  int side = RIGHT; 
  float xpos;
  Court court;

  Pad(Court c) {
    p = new PVector();
    this.court = c;
  }

  void setxPos(float x) {
    xpos = x;
    p.x = xpos;
  }

  float follow() {
    if ((int) Math.signum(court.ball.dir().x) != side) {
      p.y = 0.5;
      return 1 - p.y;
    }
    p.y = court.ball.p.y;    
    return 1 - p.y;
  
  }


 

  public PVector reflect(PVector vector, PVector normal)
  {
    PVector v = new PVector(vector.x, vector.y, vector.z);
    normal.mult(2 * PVector.dot(v, normal));
    v.sub(normal);
    return v;
  }


  void render() {
  }
}

