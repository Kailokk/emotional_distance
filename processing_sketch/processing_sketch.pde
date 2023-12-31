import processing.video.*;
import processing.serial.*;

PShader noiseShader;
PShader aberrationShader;

Movie video;
Serial serialPort;

float targetDistance;
float distance;

float smoothingFactor = 0.03f;
float maxDistance = 180f;

void setup() {
    fullScreen(P2D);
    aberrationShader = loadShader("aberration.glsl");
    noiseShader = loadShader("noise.glsl");
    
    noiseShader.set("sketchSize", float(width), float(height));
    noiseShader.set("interpolationValue", 0.0);
    
    aberrationShader.set("sketchSize", float(width), float(height));
    aberrationShader.set("interpolationValue", 0.0);
    
    String portName = Serial.list()[0]; 
    serialPort = new Serial(this, portName, 9600);
    serialPort.buffer(1);
    video = new Movie(this, "vid.mp4");
    video.loop();
}


void draw() {
    background(0);
    distance = lerp(distance,targetDistance,smoothingFactor);
   
    if (video.available()) {
        video.read();
    }
    
    float distanceMapped = map(distance, 0, maxDistance, 0, 1.0);
    noiseShader.set("interpolationValue", distanceMapped);
    aberrationShader.set("interpolationValue", distanceMapped);
    noiseShader.set("rando", random(0, 100), random(0, 100));
    image(video, 0, 0);
    
    filter(noiseShader);
    filter(aberrationShader);
}

void serialEvent(Serial p) {
    int rawDistance = p.read();
    targetDistance = float(rawDistance);
}

PVector randomVec2() {
    float x = random(0, 1);
    float y = random(0, 1);
    return new PVector(x, y);
}
