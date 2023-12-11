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
  int distance = 99999999;

  for (int x = 0; x < sensorCount; x++) {
    distance = min(distance, calculateDistance(readSensor(x)));
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
  return out;
}

int calculateDistance(long pulseDuration) {
  return pulseDuration * speedOfSound / 2;
}

void printTestData(long sensorOne, long sensorTwo, long sensorThree) {
/*   Serial.print("Left: ");
  Serial.print(leftDuration * speedOfSound / 2);
  Serial.print(", Right: ");
  // Serial.print(rightDuration* speedOfSound / 2);
  Serial.println(); */
}
