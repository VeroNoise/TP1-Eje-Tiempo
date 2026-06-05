float iniX;
float iniY;
float x;
float y;

int vertices = 15;
void setup() {
  size(400, 400);
  background(255);

  strokeWeight(1);
  noFill();
  
  for(int i = 0; i < 20; i++) {
   for (int j= 0; j<20; j++) {
     pushMatrix();
     translate(i*40,j*40);
     dibujarFigura();
     popMatrix();
   }
  }
}

void draw() {
 
}

void mousePressed() {
 setup(); 
}
void dibujarFigura() {
    iniX = random(0, 30);
  iniY = random(0, 30);
  x = iniX;
  y = iniY;
 beginShape();
  for (int i = 0; i <vertices; i++) {
    if (i < vertices-1) {
      vertex(x, y);
    } else {
      vertex(iniX, iniY);
    }
    if (i %2 == 0) {
      x= random(30);
    } else {
      y = random(30);
    }
  }

  endShape(); 
  
}
