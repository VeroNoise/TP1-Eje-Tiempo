class Lineas {

  float x = 0;
  float y = 0;
  float centroX;
  float centroY;
  
  float radio = 0;
  float angulo = 0;
  float anguloRadio = 0;
  float velocidad = 0;
  float velocidadRadio = 0;
  //----------------------------------------------------
  Lineas() {//Constructor
    centroX = 0 ;
    centroY = 0 ;
    radio =  random(50, 100);
    velocidad =  random(-0.05,0.05);
    velocidadRadio =  random(-0.1,0.1);
  }
  //----------------------------------------------------
  void update(float _radio) {
    centroX = mouseX;
    centroY = mouseY;
    angulo += velocidad;
    anguloRadio += velocidadRadio;
    float auxRadio = (sin(anguloRadio) * _radio);
    x = (sin(angulo) * auxRadio) + centroX;
    y = (cos(angulo) * auxRadio) + centroY; 
  }
  //----------------------------------------------------
  void draw(float _x, float _y, float _alfa) {
    float d = 150 - dist(x, y, _x, _y);
     mascara.stroke(255, d *_alfa);
     mascara.line(x, y, _x, _y);
  }
}
