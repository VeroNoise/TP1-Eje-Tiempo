PImage photo;

void setup() {
  size(940, 520);
  photo = loadImage("doss.jpg");
}

void draw() {
  image(photo, 0, 0);

  if (mousePressed) {

    photo.loadPixels();

    for (int y = 0; y < photo.height; y++) {
      for (int x = 0; x < photo.width; x++) {

        int c = photo.pixels[y * photo.width + x];

        float r = red(c);
        float g = green(c);
        float b = blue(c);

        // NUEVA DETECCIÓN DE VIOLETA
        boolean esVioleta =
          (b > g + 15) &&
          (r > g + 15) &&
          ((r + b) > 100);

        if (esVioleta) {
          noFill();
          stroke(255);
          strokeWeight(1);
          ellipse(x, y, 10, 10);
        }
      }
    }
  }
}
