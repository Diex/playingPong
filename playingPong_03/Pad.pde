import point2line.*;

class Pad {
  // my side of the court
  final static int LEFT = -1;
  final static int RIGHT = 1;

  PVector p;
  int side = RIGHT; 
  
  Pad() {
    p = new PVector();
  }

  void setPos(float x, float y) {
    p.x = x;
    p.y = y;
  }

  float follow(Court court, Ball ball) {
    if ((int) Math.signum(ball.dir().x) != side) {
      return p.y;
    }
    PVector collision = Collisions.getCollisionWithPad(court, this, ball);
    if (collision != null && collision.y > 0.0 && collision.y < 1.0) {        
      p.y = collision.y;
    }
    return p.y;
  }

  void reset() {
    println("padReset");
    p.y = 0.5;
  }


  public PVector reflect(PVector vector, PVector normal)
  {
    PVector v = new PVector(vector.x, vector.y, vector.z);
    normal.mult(2 * PVector.dot(v, normal));
    v.sub(normal);
    return v;
  }
}
