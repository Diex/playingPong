BlobDetection theBlobDetection;
PGraphics bd;
float x1 = 0.185;
float x2 = 0.84;
float y1 = 0.13;
float y2 = 0.89;
ArrayList<Blob> valid;

void setupBD(int w, int h) {
  bd = createGraphics(w, h, P3D);
  theBlobDetection = new BlobDetection(w, h);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.95f); // will detect bright areas whose luminosity > 0
}

void detectBlobs(PImage img) {
  theBlobDetection.computeBlobs(img.pixels);
  ArrayList<Blob> blobs = getBlobs();
  
  ArrayList<Blob> filterRoi = bdRoi(blobs, x1, x2, y1, y2);  
  ArrayList<Blob> filterSize = bdSize(filterRoi, 0.1, 0.1);
//  println(filterSize.size());
  bd.beginDraw();
  bd.background(0);
  bd.endDraw();
  
  for (Blob b : filterSize) {
    drawBlobAndEdge(b, true, true);
  }
  valid = filterSize;
  drawRoi();
}

ArrayList<Blob> getBlobs() {
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  for (int id = 0; id < theBlobDetection.getBlobNb(); id++) {
    blobs.add(theBlobDetection.getBlob(id));
  }
  return blobs;
}

ArrayList<Blob> bdRoi(ArrayList<Blob> blobs, float x1, float x2, float y1, float y2) {
  ArrayList<Blob> valids = new ArrayList<Blob>();
  for (Blob b : blobs) {
    if ( b.x > x1 && b.x < x2 && b.y > y1 && b.y < y2) valids.add(b);
  }
  return valids;
}

ArrayList<Blob> bdSize(ArrayList<Blob> blobs, float maxWidth, float maxHeight) {
  ArrayList<Blob> valids = new ArrayList<Blob>();
  for (Blob b : blobs) {
    if ( b.w < maxWidth && b.h < maxHeight) valids.add(b);
  }
  return valids;
}

void saveValids(ArrayList<Blob> blobs){
  valid = blobs;
}

Blob getMovingBlob(){
   return valid.size() > 0 ? valid.get(0) : null;
  //return theBlobDetection.getBlobNb() > 0 ? theBlobDetection.getBlob(0) : null;
}

void drawRoi() {
  bd.beginDraw();
  bd.strokeWeight(3);
  bd.stroke(200);
  bd.line(x1 * bd.width, 0, x1 * bd.width, bd.height);
  bd.line(x2 * bd.width, 0, x2 * bd.width, bd.height);
  bd.line(0, y1 * bd.height, bd.width, y1 * bd.height);
  bd.line(0, y2 * bd.height, bd.width, y2 * bd.height);
  bd.endDraw();
}
// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobAndEdge(Blob b, boolean drawBlobs, boolean drawEdges)
{
  bd.beginDraw();
  bd.noFill();

  EdgeVertex eA, eB;

  if (b!=null)
  {
    // Edges
    if (drawEdges)
    {
      bd.strokeWeight(3);
      bd.stroke(0, 255, 0);
      for (int m=0; m<b.getEdgeNb(); m++)
      {
        eA = b.getEdgeVertexA(m);
        eB = b.getEdgeVertexB(m);
        if (eA !=null && eB !=null)
          bd.line(
            eA.x*bd.width, eA.y*bd.height, 
            eB.x*bd.width, eB.y*bd.height
            );
      }
    }

    // Blobs
    if (drawBlobs)
    {
      bd.strokeWeight(1);
      bd.stroke(255, 0, 0);
      bd.rect(
        b.xMin*bd.width, b.yMin*bd.height, 
        b.w*bd.width, b.h*bd.height
        );
    }
  }

  bd.endDraw();
}
