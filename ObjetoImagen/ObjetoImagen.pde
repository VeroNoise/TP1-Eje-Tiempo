int cantidad = 20;
Lineas objeto[];
int xAnterior = 0;
int yAnterior = 0;

float radio = 0;
float radioMax = 100;

float alfa = 0;
float alfaMax = 1.0;

PImage imagen;
PGraphics mascara;
PImage imagenAdd;
//----------------------------------------------------------------------
void setup()
{
  size(570, 1025);
  strokeWeight(3);
  objeto = new Lineas[cantidad];//Contruye el vecto
  for (int i = 0; i < cantidad; i++) {
    objeto[i] = new Lineas();//Ejecuto el contructor por cada elemento
  }

  imagen = loadImage("imagen0.jpg");
  mascara= createGraphics(570, 1025);
  imagenAdd = createImage(570, 1025, RGB);
  
  background(0);
  xAnterior = mouseX;
  yAnterior = mouseY;
}
//----------------------------------------------------------------------
void draw() {
  //background(0);
  if (xAnterior != mouseX || xAnterior != mouseX) {
    alfa += 0.4;
    alfa = min(alfa, alfaMax);

    radio += 2;
    radio = min(radio, radioMax);
  } else {
    alfa -= 0.00001;
    alfa = max(alfa, 0);

    radio -= 0.4;
    radio = max(radio, 0);
  }

  mascara.beginDraw();
  mascara.fill(0,3);
  mascara.rect(0,0,mascara.width,mascara.height);
  for (int i = 0; i < cantidad; i++) {
    objeto[i].update(radio);
    for (int j = i + 1; j < cantidad; j++) {
      objeto[i].draw(objeto[j].x, objeto[j].y, alfa);
    }
  }
  mascara.endDraw();
  
  for (int x = 0; x < imagen.width; x++) {
    for (int y = 0; y < imagen.height; y++) {

      color c = imagen.get(x, y);
      color m = mascara.get(x, y);
       
       
      float gris = map(red(m), 0, 255, 0.0, 1.0);
      gris = max(gris-0.2,0);

      float r = red(c) * gris;
      float g = green(c) * gris ;
      float b = blue(c) * gris;

      imagenAdd.set(x, y, color(r, g, b));
    }
  }
  image(imagenAdd, 0, 0);
  
  xAnterior = mouseX;
  yAnterior = mouseY;
}
