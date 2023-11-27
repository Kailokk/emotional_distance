import processing.video.*;

PShader dithering;
PShader aberration;
PImage   noiseImage;

Movie movie;

void setup() {
    
    fullScreen(P2D);
    noiseImage  = loadImage("noise.png");
    
    dithering = loadShader("dither.glsl");
    aberration = loadShader("aberration.glsl");
    
    dithering.set("sketchSize", float(width), float(height));
    aberration.set("sketchSize", float(width), float(height));
    
    dithering.set("noiseTexture", noiseImage);
    dithering.set("interpolationValue", 0.0);
    
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
         dithering.set("interpolationValue", mouseYMapped);
        image(movie, 0, 0);
        
        //Applies the shader to everything that has already been drawn
        filter(aberration);
        filter(dithering);
       
    }
