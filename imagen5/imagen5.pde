PImage photo;
float[][] offsetX;
float[][] offsetY;
ArrayList<ArrayList<PVector>> ramas;
ArrayList<Integer> coloresRama;
int contadorVioletas;

void setup() {
  size(940, 520);
  background(255);
  photo = loadImage("doss.jpg");
  
  int step = 20;  // USAR EL MISMO STEP EN TODAS PARTES
  int gridX = width / step + 1;
  int gridY = height / step + 1;
  
  offsetX = new float[gridX][gridY];
  offsetY = new float[gridX][gridY];
  ramas = new ArrayList<ArrayList<PVector>>();
  coloresRama = new ArrayList<Integer>();
  
  inicializar();
}

void inicializar() {
  int step = 20;
  int gridX = width / step + 1;
  int gridY = height / step + 1;
  
  for (int i = 0; i < gridX; i++) {
    for (int j = 0; j < gridY; j++) {
      offsetX[i][j] = 0;
      offsetY[i][j] = 0;
    }
  }
  
  ramas.clear();
  coloresRama.clear();
  
  for (int i = 0; i < gridX; i++) {
    for (int j = 0; j < gridY; j++) {
      ArrayList<PVector> rama = new ArrayList<PVector>();
      rama.add(new PVector(0, 0));
      ramas.add(rama);
      coloresRama.add(color(0));
    }
  }
}

void mousePressed() {
  inicializar();
}

void draw() {
  background(255);
  image(photo, 0, 0);
  
  int step = 20;  // MISMO STEP
  contadorVioletas = 0;
  int index = 0;
  
  int gridX = width / step + 1;
  int gridY = height / step + 1;
  
  for (int x = 0; x < width; x += step) {
    for (int y = 0; y < height; y += step) {
      int c = photo.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      boolean esVioleta = (r > 100 && b > 100 && g < 100);
      
      int ix = x / step;
      int iy = y / step;
      
      // VERIFICACIÓN DE LÍMITES - IMPORTANTE
      if (ix < gridX && iy < gridY) {
        float nuevoX = x + offsetX[ix][iy];
        float nuevoY = y + offsetY[ix][iy];
        
        if (esVioleta) {
          contadorVioletas++;
          
          offsetX[ix][iy] += random(-0.5, 0.5);
          offsetY[ix][iy] += random(-0.5, 0.5);
          offsetX[ix][iy] = constrain(offsetX[ix][iy], -5, 5);
          offsetY[ix][iy] = constrain(offsetY[ix][iy], -5, 5);
          
          ArrayList<PVector> rama = ramas.get(index);
          
          // Crecimiento continuo
          if (frameCount % 2 == 0) {
            PVector ultimo = rama.get(rama.size() - 1);
            float angulo = random(TWO_PI);
            float nuevaRamaX = ultimo.x + cos(angulo) * random(2, 8);
            float nuevaRamaY = ultimo.y + sin(angulo) * random(2, 8);
            
            if (abs(nuevaRamaX) > 200 || abs(nuevaRamaY) > 200) {
              rama.clear();
              rama.add(new PVector(0, 0));
            } else {
              rama.add(new PVector(nuevaRamaX, nuevaRamaY));
            }
          }
          
          // Control de densidad
          if (rama.size() > 60) {
            rama.remove(0);
          }
          
          // Dibujar rama
          for (int k = 1; k < rama.size(); k++) {
            PVector p1 = rama.get(k-1);
            PVector p2 = rama.get(k);
            float grosor = map(k, 0, rama.size(), 2, 0.5);
            float opacidad = map(k, 0, rama.size(), 100, 200);
            strokeWeight(grosor);
            stroke(random(150, 255), random(50, 100), random(200, 255), opacidad);
            line(p1.x + nuevoX, p1.y + nuevoY, p2.x + nuevoX, p2.y + nuevoY);
          }
          
          fill(r, g, b, 200);
          noStroke();
          ellipse(nuevoX, nuevoY, step * 0.6, step * 0.6);
          
        } else {
          fill(r, g, b, 30);
          noStroke();
          ellipse(x, y, step * 0.4, step * 0.4);
        }
      }
      index++;
    }
  }
  
  println("Violetas: " + contadorVioletas);
}