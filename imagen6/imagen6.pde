PImage photo;
float[][] offsetX;
float[][] offsetY;
ArrayList ramas;
ArrayList coloresRama;
int contadorNaranjas;
int contadorAmarillos;
int contadorPetroleo;

void setup() {
  size(940, 520);
  background(255);
  photo = loadImage("CINCO.jpg");
  
  offsetX = new float[94][52];
  offsetY = new float[94][52];
  ramas = new ArrayList();
  coloresRama = new ArrayList();
  
  inicializar();
}

void inicializar() {
  for (int i = 0; i < 94; i++) {
    for (int j = 0; j < 52; j++) {
      offsetX[i][j] = 0;
      offsetY[i][j] = 0;
    }
  }
  
  ramas.clear();
  coloresRama.clear();
  
  for (int i = 0; i < 94; i++) {
    for (int j = 0; j < 52; j++) {
      ArrayList rama = new ArrayList();
      rama.add(new PVector(0, 0));
      ramas.add(rama);
      
      ArrayList colores = new ArrayList();
      colores.add(color(0));
      coloresRama.add(colores);
    }
  }
}

void mousePressed() {
  inicializar();
}

void draw() {
  background(255);
  image(photo, 0, 0);
  
  int step = 10;
  contadorNaranjas = 0;
  contadorAmarillos = 0;
  contadorPetroleo = 0;
  int index = 0;
  
  for (int x = 0; x < width; x += step) {
    for (int y = 0; y < height; y += step) {
      int c = photo.get(x, y);
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      // NARANJA - MUY AMPLIO
      boolean esNaranja = (r > 100 && g > 40 && g < 220 && b < 180 && r > g);
      
      // AMARILLO - MUY AMPLIO  
      boolean esAmarillo = (r > 130 && g > 100 && b < 180 && r > b && g > b);
      
      // PETROLEO / VERDOSO / AZULADO - MUY AMPLIO
      // Detecta cualquier tono donde predomine verde o azul sobre rojo
      boolean esPetroleo = (r < 180 && (g > 60 || b > 60) && (g > r || b > r));
      
      // Casos específicos adicionales para petróleo:
      // Verde oliva, verde musgo, azul verdoso, turquesa, teal
      boolean esVerdeOscuro = (r < 120 && g > 50 && g < 200 && b > 40);
      boolean esAzulVerde = (r < 150 && g > 70 && b > 70 && (g + b) > (r * 1.5));
      boolean esTeal = (r < 100 && g > 80 && g < 200 && b > 80);
      boolean esVerdeClaro = (r < 150 && g > 100 && b < 150 && g > r && g > b);
      
      // Unir todas las condiciones de petróleo
      esPetroleo = esPetroleo || esVerdeOscuro || esAzulVerde || esTeal || esVerdeClaro;
      
      int ix = x / step;
      int iy = y / step;
      
      if (ix < 94 && iy < 52) {
        float nuevoX = x + offsetX[ix][iy];
        float nuevoY = y + offsetY[ix][iy];
        
        if (esNaranja || esAmarillo || esPetroleo) {
          if (esNaranja) contadorNaranjas++;
          if (esAmarillo) contadorAmarillos++;
          if (esPetroleo) contadorPetroleo++;
          
          offsetX[ix][iy] += random(-0.4, 0.4);
          offsetY[ix][iy] += random(-0.4, 0.4);
          if (offsetX[ix][iy] > 3.5) offsetX[ix][iy] = 3.5;
          if (offsetX[ix][iy] < -3.5) offsetX[ix][iy] = -3.5;
          if (offsetY[ix][iy] > 3.5) offsetY[ix][iy] = 3.5;
          if (offsetY[ix][iy] < -3.5) offsetY[ix][iy] = -3.5;
          
          ArrayList colores = (ArrayList) coloresRama.get(index);
          if ((int) colores.get(0) == color(0)) {
            if (esNaranja) {
              colores.set(0, color(random(200, 255), random(80, 200), random(20, 120)));
            } else if (esAmarillo) {
              colores.set(0, color(random(200, 255), random(160, 255), random(20, 140)));
            } else if (esPetroleo) {
              // Colores más variados para petróleo: verdes, azules, turquesas
              int opcion = (int) random(4);
              if (opcion == 0) colores.set(0, color(random(20, 100), random(100, 200), random(100, 200)));
              else if (opcion == 1) colores.set(0, color(random(20, 80), random(120, 220), random(80, 160)));
              else if (opcion == 2) colores.set(0, color(random(30, 120), random(80, 180), random(120, 220)));
              else colores.set(0, color(random(40, 140), random(100, 200), random(60, 180)));
            }
          }
          
          int colorRama = (int) colores.get(0);
          float rRama = red(colorRama);
          float gRama = green(colorRama);
          float bRama = blue(colorRama);
          
          ArrayList rama = (ArrayList) ramas.get(index);
          
          if (frameCount % 5 == 0 && rama.size() < 45) {
            PVector ultimo = (PVector) rama.get(rama.size() - 1);
            float angulo = random(TWO_PI);
            float nuevaRamaX = ultimo.x + cos(angulo) * random(3, 18);
            float nuevaRamaY = ultimo.y + sin(angulo) * random(3, 18);
            
            if (abs(nuevaRamaX) > 250 || abs(nuevaRamaY) > 250) {
              rama.clear();
              rama.add(new PVector(0, 0));
            } else {
              rama.add(new PVector(nuevaRamaX, nuevaRamaY));
            }
          }
          
          for (int k = 1; k < rama.size(); k++) {
            PVector p1 = (PVector) rama.get(k-1);
            PVector p2 = (PVector) rama.get(k);
            float grosor = map(k, 0, rama.size(), 3.5, 0.8);
            strokeWeight(grosor);
            stroke(rRama, gRama, bRama, 190);
            line(p1.x + nuevoX, p1.y + nuevoY, p2.x + nuevoX, p2.y + nuevoY);
          }
          
          fill(r, g, b, 220);
          noStroke();
          ellipse(nuevoX, nuevoY, step, step);
          
        } else {
          fill(r, g, b, 40);
          noStroke();
          ellipse(x, y, step, step);
        }
      }
      index++;
    }
  }
  
  println("Naranjas: " + contadorNaranjas + " | Amarillos: " + contadorAmarillos + " | Petroleo/Verde/Azul: " + contadorPetroleo);
}