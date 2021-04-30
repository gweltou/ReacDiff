/*
 * Sketch de base pour la récupération des données venues de l'interface physique 
 * Résidence «se défiler du travail»
 * Quimper, La Baleine, 28 avril 2021
 * Pierre Commenge, pierre@les porteslogiques.net
 * processing 3.5.4 @ kirin / debian 9.5 stretch 
 */

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
int pot1, pot2, pot3, pot4, pot5, pot6, pot7;
int bouton1;

void setup() 
{
  size(400, 200);
  // ATTENTION à bien utiliser le port adapté
  printArray(Serial.list());
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 57600);
  myPort.bufferUntil('\n'); 
}

void draw()
{
  background(255);             
  fill(0);
  stroke(0);
  text("truc", 40, 40);
}


void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');
      //println(inBuffer);
      if (inBuffer != null) {
        try {
          if (inBuffer.substring(0, 1).equals("{")) {

            JSONObject json = parseJSONObject(inBuffer);

            if (json == null) {
              println("JSONObject could not be parsed");
            } else {
              //println("json ok");
              pot1    = json.getInt("pot1");
              pot2    = json.getInt("pot2");
              pot3    = json.getInt("pot3");
              pot4    = json.getInt("pot4");
              pot5    = json.getInt("pot5");
              pot6    = json.getInt("pot6");
              pot7    = json.getInt("pot7");
              bouton1 = json.getInt("bouton1"); 
              print("pot 1 : " + pot1 + ", ");
              print("pot 2 : " + pot2 + ", ");
              print("pot 3 : " + pot3 + ", ");
              print("pot 4 : " + pot4 + ", ");
              print("pot 5 : " + pot5 + ", ");
              print("pot 6 : " + pot6 + ", ");
              print("pot 7 : " + pot7 + ", ");
              println("bouton 1 : " + bouton1);
            }
          }
        }
        catch (Exception e) {
        }
      } else {
      }
    }
  } 
  catch (Exception e) {
  }
}