const int sensorCount = 3;
const int triggerPins[sensorCount] = { 13, 12, 8 };
const int responsePins[sensorCount] = { 11, 10, 9 };


const float speedOfSound = 0.034;

void setup() {
  for (int x = 0; x < sensorCount; x++) {
    pinMode(triggerPins[x], OUTPUT);
    pinMode(responsePins[x], INPUT);
  }

  Serial.begin(9600);
}

void loop() {

int reads[sensorCount];
 for (int x = 0; x < sensorCount; x++) {
  digitalWrite(triggerPins[x], LOW);
  delayMicroseconds(2);

  digitalWrite(triggerPins[x], HIGH);
  delayMicroseconds(10);

  digitalWrite(triggerPins[x], LOW);

  long durationOfBounceBack = pulseIn(responsePins[x], HIGH);

  reads[x] = durationOfBounceBack * speedOfSound / 2;
 }

  int distance = reads[0];
  for (int x = 0; x < sensorCount; x++) {
  distance = min(distance,reads[x]);
  }
  Serial.write(distance);
  Serial.flush();
  delay(100); 
}

long readSensor(int pinIndex) {
  digitalWrite(triggerPins[pinIndex], LOW);
  delayMicroseconds(2);

  digitalWrite(triggerPins[pinIndex], HIGH);
  delayMicroseconds(10);

  digitalWrite(triggerPins[pinIndex], LOW);
  long out = pulseIn(responsePins[pinIndex], HIGH);
  digitalWrite(responsePins[pinIndex], LOW);
  delayMicroseconds(10);

  return out;
}

int calculateDistance(long pulseDuration) {
  return pulseDuration * speedOfSound / 2;
}

void printTestData(int sensorIndex, int distance) {
  Serial.print("Sensor ");
  Serial.print(sensorIndex);
  Serial.print(": ");
  Serial.print(distance);
  Serial.println();
  Serial.println("--------------------");
}
