void setup() {
  size(800, 800, P3D);
  background(0);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateX(45);
  translate(-width/2, -height/2);

  stroke(255);
  noFill();
  strokeWeight(2);
  
  float frecuencia = map(mouseX,0,width, 0.01,0.1);
  float amplitud = map(mouseY, 0, height, 10, 100);
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
  int paso = 40;
  
  beginShape(QUADS);
  for (int x = 0; x< width; x += paso) {
    for (int y = 0; y< height; y += paso) {
      float z1 = noise(x * frecuencia, y * frecuencia) * amplitud;
      float z2 = noise((x+paso) * frecuencia, y * frecuencia) * amplitud;
      float z3 = noise((x+paso) * frecuencia, (y+paso) * frecuencia) * amplitud;
      float z4 = noise(x * frecuencia, (y+paso) * frecuencia) * amplitud;
      vertex(x, y, z1);
      vertex(x+paso, y, z2);
      vertex(x+paso, y+paso, z3);
      vertex(x, y+paso, z4);
    }
  }
  endShape();
}