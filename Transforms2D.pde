// Construct viewport matrix using width and height of canvas
PMatrix2D getViewPort() {
  PMatrix2D Vp = new PMatrix2D();
  Vp.set(width / 2.0, 0, width / 2.0,
         0, -height / 2.0, height / 2.0);
  return Vp;
}

// Construct projection matrix using 2D boundaries
PMatrix2D getOrtho(float left, float right, float bottom, float top) {
  PMatrix2D Pr = new PMatrix2D();
  float sx = 2.0 / (right - left);
  float sy = 2.0 / (top - bottom);
  float tx = -(right + left) / (right - left);
  float ty = -(top + bottom) / (top - bottom);
  Pr.set(sx, 0, tx,
         0, sy, ty);
  return Pr;
}

// Construct camera matrix using camera position, up vector, and zoom setting
PMatrix2D getCamera(PVector center, PVector up, PVector perp, float zoom) {
  PMatrix2D V = new PMatrix2D();
  
  // Scale by zoom
  PVector upZoomed = PVector.mult(up, zoom);
  PVector perpZoomed = PVector.mult(perp, zoom);
  
  // V = [perpZoomed.x, perpZoomed.y, -perpZoomed.dot(center)
  //      upZoomed.x,   upZoomed.y,   -upZoomed.dot(center)]
  
  float tx = -perpZoomed.dot(center);
  float ty = -upZoomed.dot(center);
  
  V.set(perpZoomed.x, perpZoomed.y, tx,
        upZoomed.x, upZoomed.y, ty);
  
  return V;
}
/*
Functions That Manipulate The Matrix Stack
*/

void myPush() {
  // Push a copy of the current model matrix M onto the stack
  matrixStack.push(M.get());
}

void myPop() {
  // Pop the top matrix off the stack and set M to it
  M = matrixStack.pop();
}

/*
Functions that update the model matrix
*/

void myScale(float sx, float sy) {
  PMatrix2D S = new PMatrix2D();
  S.scale(sx, sy);
  // Post-multiply M by S: M = M * S
  M.apply(S);
}

void myTranslate(float tx, float ty) {
  PMatrix2D T = new PMatrix2D();
  T.translate(tx, ty);
  // Post-multiply M by T: M = M * T
  M.apply(T);
}

void myRotate(float theta) {
  PMatrix2D R = new PMatrix2D();
  R.rotate(theta);
  // Post-multiply M by R: M = M * R
  M.apply(R);
}

/*
Receives a point in object space and applies the complete transformation
 pipeline, Vp.Pr.V.M.point, to put the point in viewport coordinates.
 Then calls vertex to plot this point on the raster
*/
void myVertex(float x, float y) {
  // Create a PVector with the input point
  PVector v = new PVector(x, y);

  // apply Model matrix M
  v = M.mult(v, null);

  // apply View matrix V
  v = V.mult(v, null);

  // apply Projection matrix Pr
  v = Pr.mult(v, null);

  // apply Viewport matrix Vp
  v = Vp.mult(v, null);

  // this is the only place in your program where you are allowed
  // to use the vertex command
  vertex(v.x, v.y);
}

// Overload for convenience
void myVertex(PVector vertex) {
  myVertex(vertex.x, vertex.y);
}
