import processing.video.*;

PShader dithering;
PShader noise;
PImage   noiseImage;

Movie movie;

void setup() {
    
    fullScreen(P2D);
    noiseImage  = loadImage("noise.png");
    
  //  dithering = loadShader("dither.glsl");
    noise = loadShader("noise.glsl");
    
   // dithering.set("sketchSize", float(width), float(height));
    noise.set("sketchSize", float(width), float(height));
    
    //dithering.set("noiseTexture", noiseImage);
   // dithering.set("interpolationValue", 0.0);
    
    noise.set("noiseTexture", noiseImage);
    noise.set("interpolationValue", 0.0);
    
    movie = new Movie(this, "cow.mp4");
    movie.loop();
}


void draw() {
    background(0);
    if (movie.available()) {
        movie.read();
    }
    float mouseYMapped = map(mouseY, 0, height, 0, 1.0);
    //Draw the image on the scene
    //dithering.set("interpolationValue", mouseYMapped);
    noise.set("interpolationValue", mouseYMapped);
    noise.set("rando", random(0, 100),random(0, 100));
    image(movie, 0, 0);
    
    //Applies the shader to everything that has already been drawn
    // filter(dithering);
    filter(noise);
}
PVector randomVec2() {
  float x = random(0, 1);
  float y = random(0, 1);
  return new PVector(x, y);
}
