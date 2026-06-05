  
 PImage photo;

 void setup() {
  size (900,500);
  background(255);
   photo = loadImage("uno.jpg");
}

void draw() {
  image(photo, 0, 0);

for (int x = 0; x < width; x += 10) {
    for (int y = 0; y < height; y += 10) {
      int c = photo.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      fill(r, g, b, 150);
      noStroke();
      point(x,y);
     // ellipse(x, y, 10, 10);
    }
  }
 //  float z1 = noise(x * frecuencia, y * frecuencia) * amplitud;

}
 


/*
void mouseDragged() {
  mouseMoved();
  mousePressed();
}
*/