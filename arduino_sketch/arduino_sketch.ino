const int triggerPin = 13;
const int responsePin = 11;
const float speedOfSound = 0.034;

void setup()
{
  pinMode(triggerPin, OUTPUT);
  pinMode(responsePin, INPUT);

  Serial.begin(9600);
}

void loop()
{
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);

  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);

  digitalWrite(triggerPin, LOW);

  long durationOfBounceBack = pulseIn(responsePin, HIGH);

  int distance = calculateDistance(durationOfBounceBack);

  Serial.write(distance);
  Serial.flush();
  delay(100);
}

int calculateDistance(long pulseDuration)
{
  return pulseDuration * speedOfSound / 2;
}
