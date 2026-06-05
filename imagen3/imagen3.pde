PImage photo;
float[][] offsetX, offsetY; // almacena desplazamientos para cada punto

void setup() {
  size(940, 520);
  background(255);
  photo = loadImage("uno.jpg"); // asegúrate de que la imagen exista
  
  // Inicializar arreglos de desplazamiento
  offsetX = new float[width / 10 + 1][height / 10 + 1];
  offsetY = new float[width / 10 + 1][height / 10 + 1];
  
  for (int i = 0; i < offsetX.length; i++) {
    for (int j = 0; j < offsetX[0].length; j++) {
      offsetX[i][j] = 0;
      offsetY[i][j] = 0;
    }
  }
}

void draw() {
  background(255);
  image(photo, 0, 0); // fondo fijo opcional, pero taparía los puntos movidos
  
  int step = 10; // distancia entre puntos
  
  for (int x = 0; x < width; x += step) {
    for (int y = 0; y < height; y += step) {
      int c = photo.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      // Definir violeta: r > 100, b > 100, g < 100 (ajústalo)
      boolean esVioleta = (r > 100 && b > 100 && g < 100);
      
      int ix = x / step;
      int iy = y / step;
      
      if (esVioleta) {
        // Animar: mover aleatoriamente cerca de su posición
        offsetX[ix][iy] += random(-1, 1);
        offsetY[ix][iy] += random(-1, 1);
        
        // Limitar el movimiento máximo a 5 píxeles
        offsetX[ix][iy] = constrain(offsetX[ix][iy], -5, 5);
        offsetY[ix][iy] = constrain(offsetY[ix][iy], -5, 5);
        
        float nuevoX = x + offsetX[ix][iy];
        float nuevoY = y + offsetY[ix][iy];
        
        fill(r, g, b, 150);
        noStroke();
        ellipse(nuevoX, nuevoY, step, step);
      } else {
        // Los no violetas quedan fijos
        fill(r, g, b, 150);
        noStroke();
        ellipse(x, y, step, step);
      }
      
    }
  }
}