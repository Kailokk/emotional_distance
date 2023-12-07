import processing.video.*;
import processing.serial.*;

PShader dithering;
PShader noise;
PImage   noiseImage;
String portname;
Movie movie;
Serial myPort;
int distance;

void setup() {  
    fullScreen(P2D);
    noiseImage  = loadImage("noise.png");
    
    //dithering = loadShader("dither.glsl");
    noise = loadShader("noise.glsl");
    
    // dithering.set("sketchSize", float(width), float(height));
    noise.set("sketchSize", float(width), float(height));
    
    //dithering.set("noiseTexture", noiseImage);
    // dithering.set("interpolationValue", 0.0);
    
    noise.set("noiseTexture", noiseImage);
    noise.set("interpolationValue", 0.0);
    
    String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
    myPort = new Serial(this, portName, 9600);
    myPort.buffer(1);
    movie = new Movie(this, "cow.mp4");
    movie.loop();
}


void draw() {
    background(0);
    if (movie.available()) {
        movie.read();
    }
    
    
    float distanceMapped = map(distance,0,69,0,1.0);
    noise.set("interpolationValue", distanceMapped);
    
    print("Distance: ");
    println(distance);
    print("Distance Mapped: ");
    println(distanceMapped);
    println("");
    
    
    //Draw the image on the scene
    //dithering.set("interpolationValue", mouseYMapped);
    
    noise.set("rando", random(0, 100),random(0, 100));
    image(movie, 0, 0);
    
    //Applies the shader to everything that has already been drawn
    // filter(dithering);
    filter(noise);
}
void serialEvent(Serial p) {
    distance = p.read();
}
PVector randomVec2() {
    float x = random(0, 1);
    float y = random(0, 1);
    return new PVector(x, y);
}

