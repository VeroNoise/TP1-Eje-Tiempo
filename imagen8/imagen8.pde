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
      boolean esPetroleo = (r < 180 && (g > 60 || b > 60) && (g > r || b > r));
      boolean esVerdeOscuro = (r < 120 && g > 50 && g < 200 && b > 40);
      boolean esAzulVerde = (r < 150 && g > 70 && b > 70 && (g + b) > (r * 1.5));
      boolean esTeal = (r < 100 && g > 80 && g < 200 && b > 80);
      boolean esVerdeClaro = (r < 150 && g > 100 && b < 150 && g > r && g > b);
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
          
          offsetX[ix][iy] += random(-0.3, 0.3);
          offsetY[ix][iy] += random(-0.3, 0.3);
          if (offsetX[ix][iy] > 3) offsetX[ix][iy] = 3;
          if (offsetX[ix][iy] < -3) offsetX[ix][iy] = -3;
          if (offsetY[ix][iy] > 3) offsetY[ix][iy] = 3;
          if (offsetY[ix][iy] < -3) offsetY[ix][iy] = -3;
          
          ArrayList colores = (ArrayList) coloresRama.get(index);
          if ((int) colores.get(0) == color(0)) {
            if (esNaranja) {
              colores.set(0, color(random(200, 255), random(80, 200), random(20, 120)));
            } else if (esAmarillo) {
              colores.set(0, color(random(200, 255), random(160, 255), random(20, 140)));
            } else if (esPetroleo) {
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
          
          // CRECIMIENTO CONTINUO - NUNCA SE DETIENE
          // Crece cada frame, sin límite de tamaño máximo
          // Pero controlo la densidad eliminando puntos viejos cuando hay muchos
          
          // Crecer en cada frame (frameCount % 2 para que sea más fluido)
          if (frameCount % 2 == 0) {
            PVector ultimo = (PVector) rama.get(rama.size() - 1);
            
            // Calcular dirección basada en el gradiente de la imagen (sigue el dibujo)
            float anguloBase = 0;
            if (x + step < width && y + step < height) {
              int cRight = photo.get(x + step, y);
              int cDown = photo.get(x, y + step);
              float rRig = red(cRight);
              float gRig = green(cRight);
              float bRig = blue(cRight);
              float rDow = red(cDown);
              float gDow = green(cDown);
              float bDow = blue(cDown);
              
              float diffX = (rRig + gRig + bRig) - (r + g + b);
              float diffY = (rDow + gDow + bDow) - (r + g + b);
              anguloBase = atan2(diffY, diffX);
            }
            
            // Variación según tipo de color
            float variacion;
            if (esNaranja) variacion = random(-0.8, 0.8);
            else if (esAmarillo) variacion = random(-0.6, 0.6);
            else variacion = random(-0.4, 0.4);
            
            float angulo = anguloBase + variacion;
            
            // Longitud variable pero siempre crece un poco
            float longitud;
            if (esNaranja) longitud = random(2, 7);
            else if (esAmarillo) longitud = random(2, 6);
            else longitud = random(1, 5);
            
            float nuevaRamaX = ultimo.x + cos(angulo) * longitud;
            float nuevaRamaY = ultimo.y + sin(angulo) * longitud;
            
            // Control de límites: si se aleja demasiado, vuelve al origen suavemente
            if (abs(nuevaRamaX) > 300 || abs(nuevaRamaY) > 300) {
              // No limpiar, sino redirigir hacia el centro
              nuevaRamaX = ultimo.x * 0.9;
              nuevaRamaY = ultimo.y * 0.9;
              rama.add(new PVector(nuevaRamaX, nuevaRamaY));
            } else {
              rama.add(new PVector(nuevaRamaX, nuevaRamaY));
            }
            
            // CONTROL DE DENSIDAD: si la rama tiene más de 80 puntos, elimino los más viejos
            // Esto mantiene el crecimiento continuo pero evita que se tape todo
            if (rama.size() > 80) {
              rama.remove(0);
            }
          }
          
          // Dibujar rama con opacidad variable según la antigüedad
          for (int k = 1; k < rama.size(); k++) {
            PVector p1 = (PVector) rama.get(k-1);
            PVector p2 = (PVector) rama.get(k);
            
            // Los puntos más nuevos son más gruesos y opacos, los viejos se desvanecen
            float grosor = map(k, 0, rama.size(), 1.5, 0.8);
            float opacidad = map(k, 0, rama.size(), 100, 220);
            
            strokeWeight(grosor);
            stroke(rRama, gRama, bRama, opacidad);
            line(p1.x + nuevoX, p1.y + nuevoY, p2.x + nuevoX, p2.y + nuevoY);
          }
          
          // Punto central más pequeño
          fill(r, g, b, 200);
          noStroke();
          ellipse(nuevoX, nuevoY, step * 0.6, step * 0.6);
          
        } else {
          fill(r, g, b, 25);
          noStroke();
          ellipse(x, y, step * 0.4, step * 0.4);
        }
      }
      index++;
    }
  }
  
  if (frameCount % 30 == 0) {
    println("Naranjas: " + contadorNaranjas + " | Amarillos: " + contadorAmarillos + " | Petroleo: " + contadorPetroleo);
  }
}