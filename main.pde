import java.util.Stack;  // For the matrix stack

// Global list of shapes
ArrayList<FlyingShape> shapes = new ArrayList<FlyingShape>();

// Global variables for the transformation matrices
PMatrix2D M = new PMatrix2D();
PMatrix2D V = new PMatrix2D();
PMatrix2D Pr = new PMatrix2D();
PMatrix2D Vp = new PMatrix2D();

// Stack for the model matrix
Stack<PMatrix2D> matrixStack = new Stack<PMatrix2D>();

// Global variables for camera parameters
PVector camCenter, camUp, camPerp;
float camZoom;
float camAngle;

// Left, Right, Nottom, Top boundaries for orthographic projection
float left, right, bottom, top;

// Scene scaling factor based on the projection volume
float sceneScaleFactor;

// Constants for the test patterns
final float BIG_TEST_PATTERN = 1000;
final float MED_TEST_PATTERN = 100;
final float SMALL_TEST_PATTERN = 1;

// Color constants
final color BLACK = color(0);




void setup() {
  size(600, 600);
  colorMode(RGB, 1.0);

  // initialize the viewport matrix
  Vp = getViewPort();

  // initialize camera parameters
  camCenter = new PVector(0, 0);
  camZoom = 1.0;
  camAngle = 0.0;
  updateCameraVectors();

  // initialize the projection matrices
  setProjectionMatrices();

  // Generate random shapes (squares)
  generateShapes();
}

void draw() {
  background(BLACK);

  // Set projection matrices based on the current orthoMode
  setProjectionMatrices();

  switch (testMode) {
    case PATTERN:
      drawTest(BIG_TEST_PATTERN);
      drawTest(MED_TEST_PATTERN);
      drawTest(SMALL_TEST_PATTERN);
      break;

    case SCENE:
      drawScene();
      break;

    case SHAPES:
      moveShapes();
      drawShapes();
      break;
  }
}

void mouseDragged() {
  if (orthoMode != OrthoMode.IDENTITY) {
    // calculate how much the mouse has moved between this frame and the previous one,measured in viewport coordinates
    float xMove = mouseX - pmouseX;
    float yMove = mouseY - pmouseY;

    //  viewport coordinates to NDC coordinates 4 mouse movement
    float ndcMoveX = xMove / (width / 2.0);
    float ndcMoveY = -yMove / (height / 2.0); // Negative because of y-axis inversion

    // conv NDC movement to camera coordinates
    float deltaCamX = ndcMoveX * (right - left) / 2.0;
    float deltaCamY = ndcMoveY * (top - bottom) / 2.0;

    // conv camera coordinates movement to world coordinates uisng formula deltaWorld = R^T * (deltaCam / zoom)
    float deltaWorldX = (deltaCamX * camPerp.x + deltaCamY * camUp.x) / camZoom;
    float deltaWorldY = (deltaCamX * camPerp.y + deltaCamY * camUp.y) / camZoom;

    // upodate the camCenter
    camCenter.sub(deltaWorldX, deltaWorldY);
  }
}

void updateCameraVectors() {
  float cosTheta = cos(camAngle);
  float sinTheta = sin(camAngle);
  camPerp = new PVector(cosTheta, sinTheta);
  camUp = new PVector(-sinTheta, cosTheta);
}


void drawScene() {
  // reset model matrix
  M = new PMatrix2D();

  // base translations and scales
  float baseTranslation = 200;
  float baseScale = 100;

  // apply the scaling factor
  float treeTranslation = baseTranslation * sceneScaleFactor;
  float treeScale = baseScale * sceneScaleFactor;

  // draw multiple trees at different positions (3)
  myPush();
  myTranslate(-treeTranslation, 0);
  myScale(treeScale, treeScale);
  drawTree();
  myPop();

  myPush();
  myTranslate(treeTranslation, 0);
  myScale(treeScale, treeScale);
  drawTree();
  myPop();

  myPush();
  myTranslate(0, -treeTranslation);
  myScale(treeScale, treeScale);
  drawTree();
  myPop();
}

void drawTree() {
  // Draw Main Branch
  myPush();
  drawBranch();
  myPop();

  // Left Branch
  myPush();
  myTranslate(0, 1);
  myScale(0.7, 0.7);
  myRotate(radians(-30));
  drawBranch();
  myPop();

  // Right Branch
  myPush();
  myTranslate(0, 1);
  myScale(0.7, 0.7);
  myRotate(radians(30));
  drawBranch();
  myPop();
}

void drawBranch() {
  // Draw Central Leaf
  myPush();
  drawLeaf();
  myPop();

  // Left Leaf
  myPush();
  myTranslate(0, 0.5);
  myRotate(radians(-45));
  myScale(0.7, 0.7);
  drawLeaf();
  myPop();

  // Right leaf
  myPush();
  myTranslate(0, 0.5);
  myRotate(radians(45));
  myScale(0.7, 0.7);
  drawLeaf();
  myPop();
}

void drawLeaf() {
  // Draw a leaf (a simple triangle)
  fill(0, 1, 0); // Green color
  beginShape();
  myVertex(0, 1);
  myVertex(-0.5, 0);
  myVertex(0.5, 0);
  endShape(CLOSE);
}

void generateShapes() {
  int numShapes = 20; // Choose the number of shapes you want

  for (int i = 0; i < numShapes; i++) {
    // Random position (x, y, z)
    float x = random(-300, 300);
    float y = random(-300, 300);
    float z = random(-500, 0);

    // Random size
    float size = random(20, 50);

    // Random speed
    float speed = random(1, 5); //5 is max, 1 is min

    // Random color
    color shapeColor = color(random(1), random(1), random(1));

    // vertices for the shape
    float[][] vertices = createShapeVertices(x, y, z, size);

    // create a new FlyingShape class instance
    FlyingShape shape = new FlyingShape(vertices, speed, shapeColor);

    // Add to the list!
    shapes.add(shape);
  }
}

float[][] createShapeVertices(float x, float y, float z, float size) {
  //shape is a square

  float halfSize = size / 2;

  float[][] vertices = {
    { x - halfSize, y - halfSize, z, 1 },
    { x + halfSize, y - halfSize, z, 1 },
    { x + halfSize, y + halfSize, z, 1 },
    { x - halfSize, y + halfSize, z, 1 }
  };

  return vertices;
}

void moveShapes() {
  for (FlyingShape shape : shapes) {
    shape.move();
  }
}

void drawShapes() {
  // Reset matrices
  M = new PMatrix2D(); // Model matrix
  V = new PMatrix2D(); // View matrix
  Pr = new PMatrix2D(); // Projection matrix

  // Use the same Vp as before

  // define the frustum parameters
  float left = -300;
  float right = 300;
  float bottom = -300;
  float top = 300;
  float near = 100;   // Near plane (must be > 0)
  float far = 600;    // Far plane

  //get the frustum projection matrix
  PMatrix3D frustum = getViewFrustum(left, right, bottom, top, near, far);

  // For each shape
  for (FlyingShape shape : shapes) {
    // set the shape's color
    fill(shape.shapeColor);
    beginShape();

    // for each vertex in the shape
    for (int i = 0; i < shape.vertices.length; i++) {
      float[] vertex = shape.vertices[i]; // Original vertex [x, y, z, w]

      // Project the vertex using the frustum matrix
      float[] projectedVertex = new float[4]; // To hold the result
      frustum.mult(vertex, projectedVertex);

      // perform perspective division to get NDC coordinates
      float ndcX = projectedVertex[0] / projectedVertex[3];
      float ndcY = projectedVertex[1] / projectedVertex[3];

      // now call myVertex() with NDC coordinates
      myVertex(ndcX, ndcY);
    }

    endShape(CLOSE);
  }
}
