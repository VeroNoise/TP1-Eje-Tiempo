PImage photo;
ArrayList<ArrayList<PVector>> todosLosTallos;
ArrayList<Integer> coloresTallo;
ArrayList<Float> angulosTallo;
ArrayList<Float> velocidadesTallo;
boolean imagenCargada = false;

void setup() {
  size(940, 520);
  photo = loadImage("triptico.jpg");
  if (photo != null) {
    photo.resize(width, height);
    photo.loadPixels();
    imagenCargada = true;
  } else {
    println("Error: No se pudo cargar la imagen 'triptico.jpg'");
  }
  
  todosLosTallos = new ArrayList<ArrayList<PVector>>();
  coloresTallo = new ArrayList<Integer>();
  angulosTallo = new ArrayList<Float>();
  velocidadesTallo = new ArrayList<Float>();
  
  if (imagenCargada) generarSemillas();
}

void generarSemillas() {
  int paso = 10; 
  int contador = 0;
  int limiteSemillas = 4000;
  
  for (int x = 0; x < width; x += paso) {
    for (int y = 0; y < height; y += paso) {
      int loc = x + y * width;
      if (loc >= photo.pixels.length) continue;
      
      color c = photo.pixels[loc];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      // Detectamos cualquier píxel con color significativo (no negro)
      boolean tieneColor = (r > 10 || g > 10 || b > 10);
      
      if (tieneColor) {
        ArrayList<PVector> nuevoTallo = new ArrayList<PVector>();
        PVector inicio = new PVector(x, y);
        nuevoTallo.add(inicio);
        
        todosLosTallos.add(nuevoTallo);
        coloresTallo.add(c);
        angulosTallo.add(random(TWO_PI));
        velocidadesTallo.add(random(0.5, 20));
        
        contador++;
        if(contador > limiteSemillas) break; 
      }
    }
    if(contador > limiteSemillas) break;
  }
  println("Semillas generadas: " + todosLosTallos.size());
}

void draw() {
  background(0);
  
  // IMAGEN BASE (Opacidad para que se vea el fondo)
  if (imagenCargada) {
    tint(255, 180); 
    image(photo, 0, 0);
    noTint();
  }
  
  noFill();
  
  if (todosLosTallos.size() == 0) return;
  
  for (int i = 0; i < todosLosTallos.size(); i++) {
    ArrayList<PVector> tallo = todosLosTallos.get(i);
    color c = coloresTallo.get(i);
    float angulo = angulosTallo.get(i);
    float velocidad = velocidadesTallo.get(i);
    
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    // PUNTO DE INICIO
    PVector inicio = tallo.get(0);
    stroke(r, g, b, 255);
    strokeWeight(4);
    point(inicio.x, inicio.y);
    
    // Halo del punto
    stroke(r, g, b, 100);
    strokeWeight(3);
    ellipse(inicio.x, inicio.y, 20 + sin(frameCount * 0.05 + i)*3, 10 + sin(frameCount * 0.05 + i)*3);
    
    // CRECER EL TALLO SIGUIENDO LA IMAGEN
    PVector ultimo = tallo.get(tallo.size()-1);
    
    // --- NUEVA LÓGICA: SEGUIR EL FLUJO DE LA IMAGEN ---
    // Buscamos en un radio de 10 píxeles alrededor del punto actual
    // para ver hacia dónde hay más color similar
    float mejorAngulo = angulo;
    float mejorPuntaje = -1;
    
    int radioBusqueda = 8;
    for (int a = 0; a < 360; a += 15) { // Probamos 24 direcciones
      float anguloPrueba = radians(a);
      float sumaR = 0, sumaG = 0, sumaB = 0;
      int contadorMuestra = 0;
      
      // Muestreamos en esa dirección
      for (int d = 2; d <= radioBusqueda; d += 2) {
        float px = ultimo.x + cos(anguloPrueba) * d;
        float py = ultimo.y + sin(anguloPrueba) * d;
        
        if (px >= 0 && px < width && py >= 0 && py < height) {
          int loc = int(px) + int(py) * width;
          if (loc < photo.pixels.length) {
            color cMuestra = photo.pixels[loc];
            sumaR += red(cMuestra);
            sumaG += green(cMuestra);
            sumaB += blue(cMuestra);
            contadorMuestra++;
          }
        }
      }
      
      if (contadorMuestra > 0) {
        float promR = sumaR / contadorMuestra;
        float promG = sumaG / contadorMuestra;
        float promB = sumaB / contadorMuestra;
        
        // Calculamos qué tan similar es este color al color original
        float similitud = dist(r, g, b, promR, promG, promB);
        float puntaje = 1000 - similitud; // Menor distancia = mayor puntaje
        
        // También favorecemos direcciones con más color (no negro)
        float brillo = (promR + promG + promB) / 3;
        puntaje += brillo * 0.5;
        
        if (puntaje > mejorPuntaje) {
          mejorPuntaje = puntaje;
          mejorAngulo = anguloPrueba;
        }
      }
    }
    
    // Si no encontramos nada, usamos el ángulo anterior con ruido
    if (mejorPuntaje < 0) {
      mejorAngulo = angulo + random(-PI/4, PI/4);
    }
    
    // Añadimos un poco de ruido para que sea orgánico
    mejorAngulo += random(-0.1, 0.1);
    
    // PASO
    float paso = 1.0 * velocidad;
    float newX = ultimo.x + cos(mejorAngulo) * paso;
    float newY = ultimo.y + sin(mejorAngulo) * paso;
    
    // Reinicio al salir de pantalla (pero solo si realmente se salió)
    if (newX < -10 || newX > width+10 || newY < -10 || newY > height+10) {
      tallo.clear();
      tallo.add(new PVector(inicio.x, inicio.y));
      angulosTallo.set(i, random(TWO_PI));
    } else {
      tallo.add(new PVector(newX, newY));
    }
    
    // DIBUJAR LÍNEA
    stroke(r, g, b, 150);
    strokeWeight(1.8);
    beginShape();
    for (PVector p : tallo) {
      curveVertex(p.x, p.y);
    }
    endShape();
  }
}

void mousePressed() {
  todosLosTallos.clear();
  coloresTallo.clear();
  angulosTallo.clear();
  velocidadesTallo.clear();
  if (imagenCargada) generarSemillas();
}