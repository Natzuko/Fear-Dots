import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer song;
FFT fft;
AudioInput in;

float[] angle;
float[] y, x;

float camX;
float camSpeed = 2.0;

void setup() {
  fullScreen(P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());

  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  song = minim.loadFile("OST - Fear & Hunger.mp3");
  song.play();

  camX = width / 2; // Posición inicial de la cámara
  colorMode(HSB);
}

void draw() {
  background(20);
  lights(); // Agrega iluminación básica

  // Puedes agregar luces adicionales
  pointLight(255, 255, 255, width / 2, height / 2, 200); // Luz blanca desde el centro
  directionalLight(255, 255, 255, 0, -1, 0); // Luz direccional desde arriba

  // Controlar la posición de la cámara
  if (keyPressed) {
    if (key == 'a' || key == 'A') {
      camX -= camSpeed; // Mover a la izquierda
    } else if (key == 'd' || key == 'D') {
      camX += camSpeed; // Mover a la derecha
    }
  }

  // Colocar la cámara
  camera(camX, height / 2, 500, camX, height / 2, 0, 0, 1, 0);

  fft.forward(in.mix);
  doublemov();
}

void doublemov() {
  noStroke();
  pushMatrix();
  translate(width / 2, height / 2);
  for (int i = 0; i < fft.specSize(); i++) {
    y[i] += fft.getBand(i) * 20;
    x[i] += fft.getFreq(i) * 10;
    angle[i] += fft.getFreq(i) * 200;

    // Guardar estado de transformaciones
    pushMatrix();
    translate((x[i] + 50) % (width / 3) - width / 6, (y[i] + 50) % (height / 3) - height / 6);
    rotateX(sin(angle[i] / 2));
    rotateY(cos(angle[i] / 2));
    fill(255, 255 - fft.getFreq(i) * 2, 255 - fft.getBand(i) * 8);
    switch (i % 3) {
    case 0:
      sphere((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2);
      break;
    case 1:
      box((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2);
      break;
    case 2:
      cylinder((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2, (fft.getBand(i) / 4 + fft.getFreq(i) / 4) * 2);
      break;
    }
    popMatrix();
  }
  popMatrix();

  pushMatrix();
  translate(width / 2, height / 2, 0);
  for (int i = 0; i < fft.specSize(); i++) {
    y[i] += fft.getBand(i) / 100;
    x[i] += fft.getFreq(i) / 100;
    angle[i] += fft.getFreq(i) / 2000;

    // Guardar estado de transformaciones
    pushMatrix();
    translate((x[i] + 150) % (width / 2) - width / 4, (y[i] + 150) % (height / 2) - height / 4);
    rotateX(sin(angle[i] / 2));
    rotateY(cos(angle[i] / 2));
    fill(255, 255 - fft.getFreq(i) * 2, 255 - fft.getBand(i) * 8);
    switch (i % 3) {
    case 0:
      sphere((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2);
      break;
    case 1:
      box((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2);
      break;
    case 2:
      cylinder((fft.getBand(i) / 2 + fft.getFreq(i) / 2) * 2, (fft.getBand(i) / 4 + fft.getFreq(i) / 4) * 2);
      break;
    }
    popMatrix();
  }
  popMatrix();
}

// Función para dibujar un cilindro
void cylinder(float radius, float height) {
  int sides = 36;
  float angle = TWO_PI / sides;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float x = cos(i * angle) * radius;
    float z = sin(i * angle) * radius;
    vertex(x, -height / 2, z);
    vertex(x, height / 2, z);
  }
  endShape();

  beginShape(TRIANGLE_FAN);
  vertex(0, -height / 2, 0);
  for (int i = 0; i <= sides; i++) {
    float x = cos(i * angle) * radius;
    float z = sin(i * angle) * radius;
    vertex(x, -height / 2, z);
  }
  endShape();

  beginShape(TRIANGLE_FAN);
  vertex(0, height / 2, 0);
  for (int i = 0; i <= sides; i++) {
    float x = cos(i * angle) * radius;
    float z = sin(i * angle) * radius;
    vertex(x, height / 2, z);
  }
  endShape();
}

void stop() {
  song.close();
  minim.stop();
  exit();
}
