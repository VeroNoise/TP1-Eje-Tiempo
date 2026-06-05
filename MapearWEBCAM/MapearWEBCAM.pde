import processing.video.*;

Capture cam;

// esquinas deformables
PVector[] esquinas = new PVector[4];

int puntoSeleccionado = -1;

void setup() {

  size(1000, 700, P2D);

  // iniciar webcam
  cam = new Capture(this, 640, 480);
  cam.start();

  // posiciones iniciales
  esquinas[0] = new PVector(100, 100);
  esquinas[1] = new PVector(900, 100);
  esquinas[2] = new PVector(900, 600);
  esquinas[3] = new PVector(100, 600);

  textureMode(IMAGE);
}

void draw() {

  background(0);

  // leer webcam
  if (cam.available()) {
    cam.read();
  }

  noStroke();

  // ------------------------
  // video deformable
  // ------------------------

  beginShape();

  texture(cam);

  // superior izquierda
  vertex(
    esquinas[0].x,
    esquinas[0].y,
    0,
    0
  );

  // superior derecha
  vertex(
    esquinas[1].x,
    esquinas[1].y,
    cam.width,
    0
  );

  // inferior derecha
  vertex(
    esquinas[2].x,
    esquinas[2].y,
    cam.width,
    cam.height
  );

  // inferior izquierda
  vertex(
    esquinas[3].x,
    esquinas[3].y,
    0,
    cam.height
  );

  endShape(CLOSE);

  // ------------------------
  // handles visuales
  // ------------------------

  fill(255, 0, 0);

  for (int i = 0; i < 4; i++) {

    ellipse(
      esquinas[i].x,
      esquinas[i].y,
      16,
      16
    );
  }
}

// ------------------------
// seleccionar vértice
// ------------------------

void mousePressed() {

  for (int i = 0; i < 4; i++) {

    float d = dist(
      mouseX,
      mouseY,
      esquinas[i].x,
      esquinas[i].y
    );

    if (d < 20) {
      puntoSeleccionado = i;
    }
  }
}

// ------------------------
// mover vértice
// ------------------------

void mouseDragged() {

  if (puntoSeleccionado != -1) {

    esquinas[puntoSeleccionado].x = mouseX;
    esquinas[puntoSeleccionado].y = mouseY;
  }
}

// ------------------------
// soltar vértice
// ------------------------

void mouseReleased() {

  puntoSeleccionado = -1;
}
