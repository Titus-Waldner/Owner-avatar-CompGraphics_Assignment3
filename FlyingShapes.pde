// getViewFrustum function
PMatrix3D getViewFrustum(float left, float right, float bottom, float top, float near, float far) {
  PMatrix3D frustum = new PMatrix3D();
  
  // calc  elements of the perspective projection matrix
  float A = 2 * near / (right - left);
  float B = 2 * near / (top - bottom);
  float C = (right + left) / (right - left);
  float D = (top + bottom) / (top - bottom);
  float E = -(far + near) / (far - near);
  float F = -2 * far * near / (far - near);

  frustum.set(
    A,  0,  C,  0,
    0,  B,  D,  0,
    0,  0,  E,  F,
    0,  0, -1,  0
  );

  return frustum;
}


class FlyingShape {
  float[][] vertices; // array of vertices (each vertex is an array of 4 floats: x, y, z, w)
  float speed;        // Speed shape moves along z-axis
  color shapeColor;   // Color shaspes

  FlyingShape(float[][] vertices, float speed, color shapeColor) {
    this.vertices = vertices;
    this.speed = speed;
    this.shapeColor = shapeColor;
  }

  // Travel to move the shape along the z-axis
  void move() {
    for (int i = 0; i < vertices.length; i++) {
      vertices[i][2] += speed; // distance i.e z-coordinate
      // Loop  if the shape goes beyond z boundaries
      if (vertices[i][2] > 0) {
        vertices[i][2] -= 500; // z = -500 to 0
      } else if (vertices[i][2] < -500) {
        vertices[i][2] += 500;
      }
    }
  }
}
