const int triggerPin = 9;
const int responsePin = 10;

const float speedOfSound = 0.034;

void setup() {
  pinMode(triggerPin, OUTPUT);

  pinMode(responsePin, INPUT); 

  Serial.begin(9600); 
}

void loop() {
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);

  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(triggerPin, LOW);

  long durationOfBounceBack = pulseIn(responsePin, HIGH);

  int distance = durationOfBounceBack * speedOfSound / 2;
  
  Serial.write(distance);
  Serial.flush();
  delay(100);
}
