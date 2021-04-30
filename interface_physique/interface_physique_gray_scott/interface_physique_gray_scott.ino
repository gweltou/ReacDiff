/*
 * Interface physique de contrôle pour manipuler un algorithme 
 *   de réaction diffusion Gray-Scot, dans une application Processing
 * 7 potentiomètres, 1 boutons
 * les données sont envoyées en JSON à processing
 * Résidence «se défiler du travail»
 * Quimper, La Baleine, 28 avril 2021
 * Pierre Commenge, pierre@les porteslogiques.net
 * arduino 1.8.5 @ kirin / debian 9.5 stretch 
 */

#define BROCHE_POT_1     A0
#define BROCHE_POT_2     A1
#define BROCHE_POT_3     A2
#define BROCHE_POT_4     A3
#define BROCHE_POT_5     A4
#define BROCHE_POT_6     A5
#define BROCHE_POT_7     A6

#define BROCHE_BOUT_1    4

boolean DEBUG = false;

int val1, val2, val3, val4, val5, val6, val7;    
int b1;

void setup()
{
  Serial.begin(57600);
  pinMode(BROCHE_POT_1,  INPUT);
  pinMode(BROCHE_POT_2,  INPUT);
  pinMode(BROCHE_POT_3,  INPUT);
  pinMode(BROCHE_POT_4,  INPUT);
  pinMode(BROCHE_POT_5,  INPUT);
  pinMode(BROCHE_POT_6,  INPUT);
  pinMode(BROCHE_POT_7,  INPUT);
  pinMode(BROCHE_BOUT_1, INPUT);
}

void loop() {
  val1 = analogRead(BROCHE_POT_1);
  delay(10);
  val2 = analogRead(BROCHE_POT_2);
  delay(10);
  val3 = analogRead(BROCHE_POT_3);
  delay(10);
  val4 = analogRead(BROCHE_POT_4);
  delay(10);
  val5 = analogRead(BROCHE_POT_5);
  delay(10);
  val6 = analogRead(BROCHE_POT_6);
  delay(10);
  val7 = analogRead(BROCHE_POT_7);
  delay(10);

  if (digitalRead(BROCHE_BOUT_1) == HIGH) { 
    b1 = 1023;
  } else {
    b1 = 0;
  }

  if (DEBUG) {  // Pour tester avec le traceur série  
    Serial.print(val1);
    Serial.print(",");
    Serial.print(val2);
    Serial.print(",");
    Serial.print(val3);
    Serial.print(",");
    Serial.print(val4);
    Serial.print(",");
    Serial.print(val5);
    Serial.print(",");
    Serial.print(val6);
    Serial.print(",");
    Serial.print(val7);
    Serial.print(",");
    Serial.print(b1);
    Serial.println("");
  }

  if (!DEBUG) { // Pour envoyer les valeurs à Processing
    
    String json;
    
    json = "{\"pot1\":";
    json = json + val1;
    json = json + ",\"pot2\":";
    json = json + val2;
    json = json + ",\"pot3\":";
    json = json + val3;
    json = json + ",\"pot4\":";
    json = json + val4;
    json = json + ",\"pot5\":";
    json = json + val5;
    json = json + ",\"pot6\":";
    json = json + val6;
    json = json + ",\"pot7\":";
    json = json + val7;
    json = json + ",\"bouton1\":";
    json = json + b1;
    json = json + "}";
  
    Serial.println(json);
  }
}
