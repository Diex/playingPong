class Ball{

  PVector p, pp;

  Ball(){
    p = new PVector();
    pp = new PVector();

  }

  PVector dir(){
    PVector dir = PVector.sub(p, pp);
    dir.normalize();
    return  dir;
  }
  

}
