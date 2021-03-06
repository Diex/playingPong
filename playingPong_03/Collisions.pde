public static class Collisions{
  


public static PVector getCollisionWithPad(Court c, Pad p, Ball ball) {

    PVector collision = getCollision(ball.pos, ball.dir(), new PVector(p.p.x, 0), new PVector(p.p.x, 1));

    if (collision != null && collision.y > 0.0 && collision.y < 1.0) {        
      // itero sobre los bounces
      return collision;
    } else {
      //       println("buscar refleccion: ");
      PVector bounce = Collisions.bounce(c, ball);        
      collision = getCollision(bounce, Collisions.reflection(bounce, ball), new PVector(p.p.x, 0), new PVector(p.p.x, 1));
      //       println("refleccion en: ", collision.x , collision.y);
      return collision;
    }
  }
  
  public static PVector getCollision(PVector bounce, PVector direction, PVector a, PVector b)
  {
    PVector collision = new PVector();
    Vect2[] line1 = new Vect2[ 2 ];
    line1[ 0 ] = new Vect2( bounce.x, bounce.y );
    line1[ 1 ] = new Vect2( bounce.x + direction.x, bounce.y + direction.y );

    Vect2[]line2 = new Vect2[ 2 ];

    line2[ 0 ] = new Vect2((float) a.x, (float) a.y);
    line2[ 1 ] = new Vect2((float) b.x, (float) b.y); // will be updateed by the mouse


    Vect2 intersectionPoint = Space2.lineIntersection( line1[ 0 ], line1[ 1 ], line2[ 0 ], line2[ 1 ] );

    if ( intersectionPoint != null ) {
      collision.x = intersectionPoint.x;
      collision.y = intersectionPoint.y;
    }

    return collision;
  }
   public static PVector reflection(PVector bounce, Ball ball) {
    PVector target = new PVector();
  
    // si existe esa colision
    if (bounce.x > 0 && bounce.x < 1) {
      // caculo la direccion entre ese punto y la direccion reflejada en el eje y
      PVector normal = bounce.y > 0.5 ? new PVector(0, -1) : new PVector(0, 1);

      // normalized incidence vector
      PVector incidence = PVector.mult(ball.dir(), -1);
      incidence.normalize();

      // calculate dot product of incident vector and base top normal 
      float dot = incidence.dot(normal);

      // calculate reflection vector
      // assign reflection vector to direction vector
      target.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y, 0);
    }
    return target;
  }

  

public static PVector bounce(Court court, Ball ball) {
    PVector collision = new PVector();

    // ball direction (from ball)
    Vect2[] line1 = new Vect2[ 2 ];
    line1[ 0 ] = new Vect2( ball.pos.x, ball.pos.y );
    line1[ 1 ] = new Vect2( ball.pos.x + ball.dir().x, ball.pos.y + ball.dir().y );

    // should be top or bottom edge
    Vect2[]line2 = new Vect2[ 2 ];
    // bounce top
    if (ball.dir().y <= 0) { 
      line2[ 0 ] = new Vect2((float) court.top.getX1(), (float) court.top.getY1());
      line2[ 1 ] = new Vect2((float) court.top.getX2(), (float) court.top.getY2()); // will be updateed by the mouse
    } else { 
    // bounce bottom
      line2[ 0 ] = new Vect2((float) court.bottom.getX1(), (float) court.bottom.getY1());
      line2[ 1 ] = new Vect2((float) court.bottom.getX2(), (float) court.bottom.getY2()); // will be updateed by the mouse
    }


    Vect2 intersectionPoint = Space2.lineIntersection( line1[ 0 ], line1[ 1 ], line2[ 0 ], line2[ 1 ] );

    if ( intersectionPoint != null ) {
      collision.x = intersectionPoint.x;
      collision.y = intersectionPoint.y;
    }

    return collision;
  }



}
