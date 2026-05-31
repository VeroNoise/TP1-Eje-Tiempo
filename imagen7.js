let photo;
let offsetX;
let offsetY;
let ramas = [];
let coloresRama = [];
let contadorNaranjas;
let contadorAmarillos;
let contadorPetroleo;

// 1. Cargar la imagen en preload()
function preload() {
  photo = loadImage("CINCO.jpg");
}

function setup() {
  createCanvas(940, 520);
  background(255);
  
  // Inicializar arrays 2D (en JavaScript se hace diferente que en Java)
  offsetX = new Array(94);
  offsetY = new Array(94);
  for (let i = 0; i < 94; i++) {
    offsetX[i] = new Array(52);
    offsetY[i] = new Array(52);
  }
  
  inicializar();
}

function inicializar() {
  // Resetear offsets
  for (let i = 0; i < 94; i++) {
    for (let j = 0; j < 52; j++) {
      offsetX[i][j] = 0;
      offsetY[i][j] = 0;
    }
  }
  
  // Vaciar arrays (en p5.js los arrays son mutables)
  ramas = [];
  coloresRama = [];
  
  // Crear nuevas ramas
  for (let i = 0; i < 94; i++) {
    for (let j = 0; j < 52; j++) {
      let rama = [];
      rama.push(createVector(0, 0));
      ramas.push(rama);
      
      let colores = [];
      // En Processing: color(0) en p5.js es color(0,0,0) o usar un array [0,0,0]
      colores.push([0, 0, 0]); 
      coloresRama.push(colores);
    }
  }
}

function mousePressed() {
  inicializar();
}

function draw() {
  background(255);
  image(photo, 0, 0);
  
  let step = 10;
  contadorNaranjas = 0;
  contadorAmarillos = 0;
  contadorPetroleo = 0;
  let index = 0;
  
  for (let x = 0; x < width; x += step) {
    for (let y = 0; y < height; y += step) {
      // Obtener color del píxel
      let c = photo.get(x, y);
      let r = red(c);
      let g = green(c);
      let b = blue(c);
      
      // Rangos para detectar colores
      let esNaranja = (r > 100 && g > 40 && g < 220 && b < 180 && r > g);
      let esAmarillo = (r > 130 && g > 100 && b < 180 && r > b && g > b);
      
      let esPetroleo = (r < 180 && (g > 60 || b > 60) && (g > r || b > r));
      let esVerdeOscuro = (r < 120 && g > 50 && g < 200 && b > 40);
      let esAzulVerde = (r < 150 && g > 70 && b > 70 && (g + b) > (r * 1.5));
      let esTeal = (r < 100 && g > 80 && g < 200 && b > 80);
      let esVerdeClaro = (r < 150 && g > 100 && b < 150 && g > r && g > b);
      esPetroleo = esPetroleo || esVerdeOscuro || esAzulVerde || esTeal || esVerdeClaro;
      
      let ix = floor(x / step);
      let iy = floor(y / step);
      
      if (ix < 94 && iy < 52) {
        let nuevoX = x + offsetX[ix][iy];
        let nuevoY = y + offsetY[ix][iy];
        
        if (esNaranja || esAmarillo || esPetroleo) {
          if (esNaranja) contadorNaranjas++;
          if (esAmarillo) contadorAmarillos++;
          if (esPetroleo) contadorPetroleo++;
          
          // Movimiento sutil
          offsetX[ix][iy] += random(-0.2, 0.2);
          offsetY[ix][iy] += random(-0.2, 0.2);
          if (offsetX[ix][iy] > 2) offsetX[ix][iy] = 2;
          if (offsetX[ix][iy] < -2) offsetX[ix][iy] = -2;
          if (offsetY[ix][iy] > 2) offsetY[ix][iy] = 2;
          if (offsetY[ix][iy] < -2) offsetY[ix][iy] = -2;
          
          let colores = coloresRama[index];
          // Verificar si el color inicial es negro (0,0,0) o null
          if (colores[0] && colores[0][0] === 0) {
            if (esNaranja) {
              colores[0] = [random(200, 255), random(80, 200), random(20, 120)];
            } else if (esAmarillo) {
              colores[0] = [random(200, 255), random(160, 255), random(20, 140)];
            } else if (esPetroleo) {
              let opcion = floor(random(4));
              if (opcion == 0) colores[0] = [random(20, 100), random(100, 200), random(100, 200)];
              else if (opcion == 1) colores[0] = [random(20, 80), random(120, 220), random(80, 160)];
              else if (opcion == 2) colores[0] = [random(30, 120), random(80, 180), random(120, 220)];
              else colores[0] = [random(40, 140), random(100, 200), random(60, 180)];
            }
          }
          
          let colorRama = colores[0];
          let rRama = colorRama[0];
          let gRama = colorRama[1];
          let bRama = colorRama[2];
          
          let rama = ramas[index];
          
          // CRECIMIENTO MÁS RÁPIDO (cada 2 frames) y MÁS PUNTOS (hasta 60)
          if (frameCount % 2 == 0 && rama.length < 60) {
            let ultimo = rama[rama.length - 1];
            
            // DIRECCIÓN BASADA EN EL DIBUJO (gradiente de la imagen)
            let anguloBase = 0;
            
            // Muestrear píxeles vecinos para determinar dirección del trazo
            if (x + step < width && y + step < height) {
              let cRight = photo.get(x + step, y);
              let cDown = photo.get(x, y + step);
              let rRig = red(cRight);
              let gRig = green(cRight);
              let bRig = blue(cRight);
              let rDow = red(cDown);
              let gDow = green(cDown);
              let bDow = blue(cDown);
              
              // Vector de dirección aproximado
              let diffX = (rRig + gRig + bRig) - (r + g + b);
              let diffY = (rDow + gDow + bDow) - (r + g + b);
              
              anguloBase = atan2(diffY, diffX);
            }
            
            // Añadir variación según el tipo de color
            let variacion;
            if (esNaranja) variacion = random(-0.5, 0.5);
            else if (esAmarillo) variacion = random(-0.4, 0.4);
            else variacion = random(-0.3, 0.3);
            
            let angulo = anguloBase + variacion;
            
            // LÍNEAS MÁS CORTAS (longitud reducida)
            let longitud;
            if (esNaranja) longitud = random(2, 6);
            else if (esAmarillo) longitud = random(2, 5);
            else longitud = random(1, 4);
            
            let nuevaRamaX = ultimo.x + cos(angulo) * longitud;
            let nuevaRamaY = ultimo.y + sin(angulo) * longitud;
            
            if (abs(nuevaRamaX) > 150 || abs(nuevaRamaY) > 150) {
              rama = [];
              rama.push(createVector(0, 0));
              // Reasignar la rama actualizada al array original? 
              // En JavaScript, si mutas el array referenciado, funciona.
              // Pero aquí es seguro actualizar ramas[index] = rama;
              ramas[index] = rama; 
            } else {
              rama.push(createVector(nuevaRamaX, nuevaRamaY));
            }
          }
          
          // DIBUJO DE LÍNEAS MÁS FINAS Y CONTINUAS
          for (let k = 1; k < rama.length; k++) {
            let p1 = rama[k-1];
            let p2 = rama[k];
            // Grosor más fino
            let grosor = map(k, 0, rama.length, 1.5, 0.5);
            strokeWeight(grosor);
            stroke(rRama, gRama, bRama, 200);
            line(p1.x + nuevoX, p1.y + nuevoY, p2.x + nuevoX, p2.y + nuevoY);
          }
          
          // Punto central más pequeño
          fill(r, g, b, 200);
          noStroke();
          ellipse(nuevoX, nuevoY, step * 0.6, step * 0.6);
          
        } else {
          fill(r, g, b, 30);
          noStroke();
          ellipse(x, y, step * 0.5, step * 0.5);
        }
      }
      index++;
    }
  }
  
  // Mostrar contadores cada 30 frames
  if (frameCount % 30 == 0) {
    print("Naranjas: " + contadorNaranjas + " | Amarillos: " + contadorAmarillos + " | Petroleo: " + contadorPetroleo);
  }
}