import processing.video.*;
import processing.serial.*;

PShader aberration;
PShader noise;

Movie movie;
Serial serialPort;

float targetDistance;
float distance;

float smoothingFactor = 0.03f;
float maxDistance = 180f;

void setup() {
    fullScreen(P2D);
    aberration = loadShader("aberration.glsl");
    noise = loadShader("noise.glsl");
    
    noise.set("sketchSize", float(width), float(height));
    noise.set("interpolationValue", 0.0);
    
    aberration.set("sketchSize", float(width), float(height));
    aberration.set("interpolationValue", 0.0);
    
    String portName = Serial.list()[0]; 
    serialPort = new Serial(this, portName, 9600);
    serialPort.buffer(1);
    movie = new Movie(this, "vid.mp4");
    movie.loop();
}


void draw() {
    background(0);
    distance = lerp(distance,targetDistance,smoothingFactor);
   
    if (movie.available()) {
        movie.read();
    }
    
    float distanceMapped = map(distance, 0, maxDistance, 0, 1.0);
    noise.set("interpolationValue", distanceMapped);
    aberration.set("interpolationValue", distanceMapped);
    noise.set("rando", random(0, 100), random(0, 100));
    image(movie, 0, 0);
    
    filter(noise);
    filter(aberration);
}

void serialEvent(Serial p) {
    int rawDistance = p.read();
     println(rawDistance);
    targetDistance = float(rawDistance);
}

PVector randomVec2() {
    float x = random(0, 1);
    float y = random(0, 1);
    return new PVector(x, y);
}
