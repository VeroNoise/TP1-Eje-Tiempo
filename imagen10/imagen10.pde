PImage photo;
ArrayList<ArrayList<PVector>> todosLosTallos;
ArrayList<Integer> coloresTallo;
ArrayList<Float> angulosTallo;
ArrayList<Float> velocidadesTallo;
boolean imagenCargada = false;

void setup() {
  size(940, 520);
  photo = loadImage("doss.jpg");
  if (photo != null) {
    photo.resize(width, height);
    photo.loadPixels();
    imagenCargada = true;
  } else {
    println("Error: No se pudo cargar la imagen 'doss.jpg'");
  }
  
  todosLosTallos = new ArrayList<ArrayList<PVector>>();
  coloresTallo = new ArrayList<Integer>();
  angulosTallo = new ArrayList<Float>();
  velocidadesTallo = new ArrayList<Float>();
  
  if (imagenCargada) generarSemillas();
}

void generarSemillas() {
  int paso = 6; // Más semillas para más densidad
  int contador = 0;
  
  for (int x = 0; x < width; x += paso) {
    for (int y = 0; y < height; y += paso) {
      int loc = x + y * width;
      if (loc >= photo.pixels.length) continue;
      
      color c = photo.pixels[loc];
      float r = red(c);
      float g = green(c);
      float b = blue(c);
      
      // PALETA: Fucsia, Celeste, Violeta
      boolean esFucsia = (r > 80 && b > 80 && g < 150);
      boolean esCeleste = (b > 80 && r < 150 && g < 150);
      boolean esVioleta = (r > 60 && b > 60 && r < 200 && b < 200 && g < 180);
      
      if (esFucsia || esCeleste || esVioleta) {
        ArrayList<PVector> nuevoTallo = new ArrayList<PVector>();
        PVector inicio = new PVector(x, y);
        nuevoTallo.add(inicio);
        
        todosLosTallos.add(nuevoTallo);
        coloresTallo.add(c);
        angulosTallo.add(random(TWO_PI));
        velocidadesTallo.add(random(1.0, 2.0)); // Velocidad media
        
        contador++;
        if(contador > 800) break; // Más semillas
      }
    }
  }
  println("Semillas generadas: " + todosLosTallos.size());
}

void draw() {
  background(0);
  
  // IMAGEN DE FONDO (MÁS OSCURA PARA QUE RESALTEN LAS LÍNEAS)
  if (imagenCargada) {
    tint(255, 80); // Reducido a 80 (antes 220) para que las líneas dominen
    image(photo, 0, 0);
    noTint();
  }
  
  noFill();
  
  for (int i = 0; i < todosLosTallos.size(); i++) {
    ArrayList<PVector> tallo = todosLosTallos.get(i);
    color c = coloresTallo.get(i);
    float angulo = angulosTallo.get(i);
    float velocidad = velocidadesTallo.get(i);
    
    // COLOR SATURADO Y BRILLANTE
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    // Aumentamos la saturación para que se vea intenso
    // Si es fucsia, lo hacemos más rosa fuerte
    // Si es celeste, lo hacemos más azul claro
    if (r > b) {
      // Fucsia/Violeta: potenciamos rojo y azul
      r = min(255, r * 1.5);
      b = min(255, b * 1.3);
    } else {
      // Celeste: potenciamos azul
      b = min(255, b * 1.5);
    }
    
    stroke(r, g, b, 220); // Color intenso, opaco
    strokeWeight(2.5); // Línea más gruesa
    
    // PUNTO DE INICIO (Grande y brillante)
    PVector inicio = tallo.get(0);
    stroke(r, g, b, 255);
    strokeWeight(8);
    point(inicio.x, inicio.y);
    
    // Halo del punto
    stroke(r, g, b, 150);
    strokeWeight(3);
    ellipse(inicio.x, inicio.y, 15 + sin(frameCount * 0.05 + i)*5, 15 + sin(frameCount * 0.05 + i)*5);
    
    // CRECER EL TALLO
    PVector ultimo = tallo.get(tallo.size()-1);
    
    // Movimiento orgánico
    float noiseVal = noise(ultimo.x * 0.01, ultimo.y * 0.01, frameCount * 0.005);
    float anguloActual = angulo + map(noiseVal, 0, 1, -PI/3, PI/3);
    
    // Apertura suave
    anguloActual += 0.003 * tallo.size();
    
    // PASO MÁS RÁPIDO (velocidad 1.0-2.0)
    float paso = 1.5 * velocidad;
    float newX = ultimo.x + cos(anguloActual) * paso;
    float newY = ultimo.y + sin(anguloActual) * paso;
    
    // Reinicio al salir de pantalla
    if (newX < -20 || newX > width+20 || newY < -20 || newY > height+20) {
      tallo.clear();
      tallo.add(new PVector(inicio.x, inicio.y));
      angulosTallo.set(i, random(TWO_PI));
    } else {
      tallo.add(new PVector(newX, newY));
    }
    
    // DIBUJAR LÍNEA
    // Usamos el color con algo de transparencia para efecto de estela
    stroke(r, g, b, 180);
    strokeWeight(2);
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