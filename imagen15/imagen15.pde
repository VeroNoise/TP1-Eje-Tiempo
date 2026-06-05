import processing.core.*;
import java.util.*;

String imageName = "triptico.jpg"; // Asegúrate de llamar así a tu imagen
PImage img;

// Lista de puntos que formarán las líneas
ArrayList<PuntoLinea> puntos = new ArrayList<PuntoLinea>();
boolean needsUpdate = true;

void setup() {
  size(1200, 800, P2D);
  img = loadImage(imageName);
  if (img == null) {
    println("ERROR: Coloca la imagen '" + imageName + "'");
    exit();
  }
  img.resize(width, height);
  noStroke();
}

void draw() {
  if (needsUpdate) {
    background(0);
    img.loadPixels();
    puntos.clear();
    
    // PASO 1: DETECTAR PÍXELES RELEVANTES (Los bordes y líneas de la imagen)
    int step = 10; // Más grande = menos puntos
    float umbralContraste = 40; // Para detectar bordes (líneas)
    
    // Usamos un filtro de detección de bordes simple basado en diferencia de brillo
    for (int x = step; x < img.width - step; x += step) {
      for (int y = step; y < img.height - step; y += step) {
        int loc = x + y * img.width;
        color c = img.pixels[loc];
        
        // Comparar con vecinos para detectar línea (contraste)
        color cArriba = img.pixels[x + (y-step)*img.width];
        color cAbajo = img.pixels[x + (y+step)*img.width];
        color cIzq = img.pixels[(x-step) + y*img.width];
        color cDer = img.pixels[(x+step) + y*img.width];
        
        float difTotal = abs(brightness(c) - brightness(cArriba)) +
                         abs(brightness(c) - brightness(cAbajo)) +
                         abs(brightness(c) - brightness(cIzq)) +
                         abs(brightness(c) - brightness(cDer));
        
        // Si hay contraste, es una línea o borde
        if (difTotal > umbralContraste && brightness(c) > 10) {
          float r = red(c);
          float g = green(c);
          float b = blue(c);
          PuntoLinea p = new PuntoLinea(x, y, color(r, g, b));
          puntos.add(p);
        }
      }
    }
    
    println("Puntos de línea detectados: " + puntos.size());
    needsUpdate = false;
  }
  
  background(0);
  
  // PASO 2: DIBUJAR LÍNEAS ORGÁNICAS (ramificaciones)
  // En lugar de puntos, conectamos puntos cercanos con curvas
  strokeWeight(2.5);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  
  // Recorremos los puntos
  for (int i = 0; i < puntos.size(); i++) {
    PuntoLinea p1 = puntos.get(i);
    
    // Buscar puntos cercanos para conectar
    int conexiones = 0;
    for (int j = i + 1; j < puntos.size(); j++) {
      PuntoLinea p2 = puntos.get(j);
      float d = dist(p1.x, p1.y, p2.x, p2.y);
      
      // Si están muy cerca, conectarlos (orgánico)
      if (d < 30) { // Ajusta este número para más/menos líneas
        // Interpolar color entre los dos puntos
        color cInterpolado = lerpColor(p1.col, p2.col, 0.5);
        stroke(cInterpolado, 120); // Transparencia para efecto tinta
        line(p1.x, p1.y, p2.x, p2.y);
        conexiones++;
      }
      
      // Máximo 3 conexiones por punto para evitar saturación
      if (conexiones > 3) break;
    }
  }
  
  // PASO 3: EFECTO MOUSE ORGÁNICO
  // El mouse hace que las líneas "vibren" o se expandan ligeramente
  noStroke();
  for (PuntoLinea p : puntos) {
    p.display();
  }
  
  fill(255, 180);
  textAlign(LEFT, TOP);
 // text("Click: reiniciar | Mouse: las líneas se mueven orgánicamente", 10, 10);
}

class PuntoLinea {
  float x, y;
  color col;
  float desplX, desplY; // Para el efecto mouse
  
  PuntoLinea(float x, float y, color col) {
    this.x = x;
    this.y = y;
    this.col = col;
    this.desplX = 0;
    this.desplY = 0;
  }
  
  void display() {
    // Efecto mouse: el punto se desplaza ligeramente hacia el mouse
    float d = dist(mouseX, mouseY, x, y);
    float fuerza = random(0, 10) * (1 - d / 200); // Más cerca = más fuerza
    fuerza = constrain(fuerza, 0, 10);
    
    // Movimiento suave hacia el mouse
    float angulo = atan2(mouseY - y, mouseX - x);
    desplX += (cos(angulo) * fuerza * 0.8 - desplX) * 0.1;
    desplY += (sin(angulo) * fuerza * 0.8 - desplY) * 0.1;
    
    // Dibujamos un pequeño punto en la intersección de las líneas
    // (muy sutil para no arruinar las líneas)
    fill(col, 80);
    ellipse(x + desplX, y + desplY, random(3,10),random(3,10));
  }
}

void mousePressed() {
  // REINICIAR A CERO (volver a detectar puntos)
  puntos.clear();
  needsUpdate = true;
  background(0);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    puntos.clear();
    needsUpdate = true;
  }
}