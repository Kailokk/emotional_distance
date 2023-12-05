const int triggerPin = 9;
const int responsePin = 10;

const float speedOfSound = 0.034

void setup() {
  pinMode(triggerPin, OUTPUT);

  pinMode(responsePin, INPUT); 

  Serial.begin(9600); 
}

void loop() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(trigPin, LOW);

  long durationOfBounceBack = pulseIn(echoPin, HIGH);

  int distance = (durationOfBounceBack * speedOfSound) / 2;
  
  Serial.write(distance);
  delay(100);
}