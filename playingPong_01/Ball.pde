class Ball{

  PVector p, pp;
//  PVector d;

  
  Ball(){
    p = new PVector();
    pp = new PVector();
//    d = new PVector(); 
  }
  
//  void infereFromBlob(Blob b){
//    if(b == null) return;
//    pp.x = ease(pp.x, p.x, 0.0);
//    pp.y =  ease(pp.y, p.y, 0.0);
//    p.x = b.x;
//    p.y = b.y;    
//  }
  
  PVector dir(){
    PVector dir = PVector.sub(p, pp);
    dir.normalize();
    return  dir;
  }
  

}
