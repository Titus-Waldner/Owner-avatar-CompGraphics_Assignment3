// Hotkey constants
final char KEY_ROTATE_CW = ']';
final char KEY_ROTATE_CCW = '[';
final char KEY_ZOOM_IN = '='; // Plus sign without the shift
final char KEY_ZOOM_OUT = '-';
final char KEY_ORTHO_MODE = 'o';
final char KEY_DISPLAY_MODE = 'd';

enum OrthoMode {
  IDENTITY, // straight to viewport with no transformations (Pr, V and M are all the identity)
  CENTER600, // bottom left is (-300,-300), top right is (300,300), center is (0,0)
  TOPRIGHT600, // bottom left is (0,0), top right is (600,600)
  FLIPX, // same as CENTER600 but reflected through y axis (x -> -x)
  ASPECT // uneven aspect ratio: x is from -300 to 300, y is from -100 to 100
}
OrthoMode orthoMode = OrthoMode.IDENTITY;

enum DisplayMode {
  PATTERN,
  SCENE,
  SHAPES
}

DisplayMode testMode = DisplayMode.PATTERN;

void keyPressed() {
  if (key == KEY_ORTHO_MODE) {
    // Cycle through orthoModes
    switch (orthoMode) {
      case IDENTITY:
        orthoMode = OrthoMode.CENTER600;
        break;
      case CENTER600:
        orthoMode = OrthoMode.TOPRIGHT600;
        break;
      case TOPRIGHT600:
        orthoMode = OrthoMode.FLIPX;
        break;
      case FLIPX:
        orthoMode = OrthoMode.ASPECT;
        break;
      case ASPECT:
        orthoMode = OrthoMode.IDENTITY;
        break;
    }

    // After changing orthoMode, reset matrices and parameters
    setProjectionMatrices();
    M = new PMatrix2D(); // Reset model matrix
  } else if (key == KEY_DISPLAY_MODE) {
    // Cycle through display modes
    switch (testMode) {
      case PATTERN:
        testMode = DisplayMode.SCENE;
        break;
      case SCENE:
        testMode = DisplayMode.SHAPES;
        break;
      case SHAPES:
        testMode = DisplayMode.PATTERN;
        break;
    }
  } else if (orthoMode != OrthoMode.IDENTITY) {
    // Camera controls are disabled in IDENTITY mode
    if (key == KEY_ZOOM_IN) {
      camZoom *= 1.1;
    } else if (key == KEY_ZOOM_OUT) {
      camZoom /= 1.1;
      if (camZoom < 0.001) {
        camZoom = 0.001; // Prevent camZoom from becoming too small
      }
    } else if (key == KEY_ROTATE_CW) {
      camAngle += radians(5);
      updateCameraVectors();
    } else if (key == KEY_ROTATE_CCW) {
      camAngle -= radians(5);
      updateCameraVectors();
    }
  }
}

void setProjectionMatrices() {
  switch (orthoMode) {
    case IDENTITY:
      left = -1; right = 1; bottom = -1; top = 1;

      // Compute the orthographic projection matrix
      Pr = getOrtho(left, right, bottom, top);

      // Compute the scene scaling factor
      float baseWidth = 600.0;
      float currentWidth = abs(right - left);
      sceneScaleFactor = currentWidth / baseWidth;

      // Set the view matrix V to the identity matrix
      V = new PMatrix2D();

      // Optionally reset camera parameters (not necessary if camera controls are working fine)
      // camZoom = 1.0;
      // camAngle = 0.0;
      // camCenter = new PVector(0, 0);
      // updateCameraVectors();

      break;

    case CENTER600:
      left = -300; right = 300; bottom = -300; top = 300;
      Pr = getOrtho(left, right, bottom, top);
      V = getCamera(camCenter, camUp, camPerp, camZoom);

      // Compute the scene scaling factor
      baseWidth = 600.0;
      currentWidth = abs(right - left);
      sceneScaleFactor = currentWidth / baseWidth;
      break;

    case TOPRIGHT600:
      left = 0; right = 600; bottom = 0; top = 600;
      Pr = getOrtho(left, right, bottom, top);
      V = getCamera(camCenter, camUp, camPerp, camZoom);

      baseWidth = 600.0;
      currentWidth = abs(right - left);
      sceneScaleFactor = currentWidth / baseWidth;
      break;

    case FLIPX:
      left = 300; right = -300; bottom = -300; top = 300;
      Pr = getOrtho(left, right, bottom, top);
      V = getCamera(camCenter, camUp, camPerp, camZoom);

      baseWidth = 600.0;
      currentWidth = abs(right - left);
      sceneScaleFactor = currentWidth / baseWidth;
      break;

    case ASPECT:
      left = -300; right = 300; bottom = -100; top = 100;
      Pr = getOrtho(left, right, bottom, top);
      V = getCamera(camCenter, camUp, camPerp, camZoom);

      baseWidth = 600.0;
      currentWidth = abs(right - left);
      sceneScaleFactor = currentWidth / baseWidth;
      break;
  }

  // Note: M is reset in drawScene(), so no need to reset it here
}

// don't change anything below here

final int NUM_LINES = 11;
final int THIN_LINE = 1;
void drawTest(float scale) {
  float left, right, top, bottom;
  left = bottom = -scale/2;
  right = top = scale/2;

  strokeWeight(THIN_LINE);
  beginShape(LINES);
  for (int i=0; i<NUM_LINES; i++) {
    float x = left + i*scale/(NUM_LINES-1);
    float y = bottom + i*scale/(NUM_LINES-1);

    setHorizontalColor(i);
    myVertex(left, y);
    myVertex(right, y);

    setVerticalColor(i);
    myVertex(x, bottom);
    myVertex(x, top);
  }
  endShape(LINES);
}

void setHorizontalColor(int i) {
  int r, g, b;
  r = (i >= NUM_LINES/2) ? 0 : 1;
  g = (i >= NUM_LINES/2) ? 1 : 0;
  b = (i >= NUM_LINES/2) ? 1 : 0;
  stroke(r, g, b);
}

void setVerticalColor(int i) {
  int r, g, b;
  r = (i >= NUM_LINES/2) ? 1 : 0;
  g = (i >= NUM_LINES/2) ? 1 : 0;
  b = (i >= NUM_LINES/2) ? 0 : 1;
  stroke(r, g, b);
}
