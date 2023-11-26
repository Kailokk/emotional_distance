import processing.video.*;

PShader dithering;
PImage   noiseImage;

Movie movie;

void setup() {
    
    fullScreen(P2D);
    noiseImage  = loadImage("noise.png");
    
    dithering = loadShader("dither.glsl");
    
    dithering.set("sketchSize", float(width), float(height));
    
    dithering.set("noiseTexture", noiseImage);
    
    movie = new Movie(this, "cow.mp4");
    movie.loop();
}


void draw() {
    
    background(0);
    if (movie.available()) {
        movie.read();
    }
        //Draw the image on the scene
        
        image(movie, 0, 0);
        
        //Applies the shader to everything that has already been drawn
        filter(dithering);
        
    }
