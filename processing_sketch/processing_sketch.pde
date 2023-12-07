import processing.video.*;
import processing.serial.*;

PShader dithering;
PShader noise;
PImage   noiseImage;
String portname;
Movie movie;
Serial myPort;
float distance;

float smoothingFactor = 0.3f;
float maxDistance = 180f;

void setup() {  
    fullScreen(P2D);
    noiseImage  = loadImage("noise.png");
 
    noise = loadShader("noise.glsl");
    
    noise.set("sketchSize", float(width), float(height));
    noise.set("interpolationValue", 0.0);
    
    String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
    myPort = new Serial(this, portName, 9600);
    myPort.buffer(1);
    movie = new Movie(this, "vid.mp4");
    movie.loop();
}


void draw() {
    background(0);
    if (movie.available()) {
        movie.read();
    }
    
    float distanceMapped = map(distance,0,maxDistance,0,1.0);
    noise.set("interpolationValue", distanceMapped);
    
    noise.set("rando", random(0, 100),random(0, 100));
    image(movie, 0, 0);
    
    filter(noise);
}

void serialEvent(Serial p) {
    int rawDistance = p.read();
    float floatyDistance = float(rawDistance);
    distance = lerp(distance,floatyDistance,smoothingFactor);
}

PVector randomVec2() {
    float x = random(0, 1);
    float y = random(0, 1);
    return new PVector(x, y);
}
