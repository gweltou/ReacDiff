// Gweltaz Duval-Guennoc 27-04-2021

import controlP5.*;
ControlP5 cp5;
Group g;


import processing.serial.*;

boolean USE_SERIAL = false;  // Set to true if using a hardware controller
int PORT_NUMBER = 32;  // Change ths number according to the array shown in terminal
Serial myPort;
int val;        // Data received from the serial port
int pot1, pot2, pot3, pot4, pot5, pot6, pot7;
int bouton1;

PShader reacdiff;
PShader postproc;
PGraphics pg;

int ITERATIONS = 10;
int counter = 0;



void setup() {
  //size(800, 600, P3D);
  fullScreen(P3D, 1);
  surface.setResizable(true);

  if (USE_SERIAL) {
    printArray(Serial.list());
    String portName = Serial.list()[PORT_NUMBER];
    myPort = new Serial(this, portName, 57600);
    myPort.bufferUntil('\n');
  }

  pg = createGraphics(width, height, P3D);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();

  postproc = loadShader("shaders/postproc.glsl");
  postproc.set("u_resolution", float(pg.width), float(pg.height));

  reacdiff = loadShader("shaders/reacdiff.glsl");
  reacdiff.set("u_resolution", float(pg.width), float(pg.height));
  reacdiff.set("scene", pg);

  cp5 = new ControlP5(this);

  int groupWidth = 170;
  int sliderHeight = 16;
  int sliderWidth = 130;
  g = cp5.addGroup("params")
    .setWidth(groupWidth)
    .setPosition(width-groupWidth-4, 14)
    .setBackgroundColor(color(0, 0, 128, 50))
    ;

  int h = 0;
  cp5.addSlider("mode")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 2)
    .setValue(2)
    .setNumberOfTickMarks(3)
    .setSliderMode(Slider.FLEXIBLE)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("points")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(2, 8)
    .setValue(5)
    .setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("size")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.006f, 0.1f)
    .setValue(0.02f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("feedA")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.01f, 0.1f)
    .setValue(0.0389f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("killB")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.01f, 0.1f)
    .setValue(0.05904f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("diffA")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.1f, 1.5f)
    .setValue(1.0f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("diffB")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.01f, 1.7f)
    .setValue(0.5f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("smoothA")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.0f, 1.0f)
    .setValue(0.4f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  cp5.addSlider("smoothB")
    .setPosition(0, h)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0.0f, 1.0f)
    .setValue(0.5f)
    .setGroup(g)
    ;
  h += sliderHeight + 2;

  g.setBackgroundHeight(h);
}


void updateShader() {
  pg.beginDraw();
  pg.noStroke();
  pg.shader(reacdiff);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
}


void draw() {
  // Framerate optimisation
  if (++counter % 30 == 0) {
    surface.setTitle("Framerate " + String.valueOf(frameRate));
    println(frameRate, ITERATIONS);
    counter = 0;

    if (frameRate < 50)
      ITERATIONS = max(1, ITERATIONS-1);
    else if (frameRate > 58)
      ITERATIONS++;
  }

  if (mousePressed && !insideGroup(g)) {
    float x = map(mouseX, 0, width, 0, 1);
    float y = map(mouseY, 0, height, 1, 0);
    reacdiff.set("mouse", x, y);
    reacdiff.set("spawn", true);
  } else {
    reacdiff.set("spawn", false);
  }

  if (USE_SERIAL) {
    cp5.getController("size").setValue(map(pot3, 1023, 0, cp5.getController("size").getMin(), cp5.getController("size").getMax()));
    cp5.getController("feedA").setValue(map(pot1, 1023, 0, cp5.getController("feedA").getMin(), cp5.getController("feedA").getMax()));
    cp5.getController("killB").setValue(map(pot2, 1023, 0, cp5.getController("killB").getMin(), cp5.getController("killB").getMax()));
    cp5.getController("diffA").setValue(map(pot4, 1023, 0, cp5.getController("diffA").getMin(), cp5.getController("diffA").getMax()));
    cp5.getController("diffB").setValue(map(pot5, 1023, 0, cp5.getController("diffB").getMin(), cp5.getController("diffB").getMax()));
    cp5.getController("smoothA").setValue(map(pot6, 1023, 0, cp5.getController("smoothA").getMin(), cp5.getController("smoothA").getMax()));
    cp5.getController("smoothB").setValue(map(pot7, 1023, 0, cp5.getController("smoothB").getMin(), cp5.getController("smoothB").getMax()));

    if (bouton1 >= 512) {
      reacdiff.set("spawn", true);
      reacdiff.set("mouse", random(1), random(1));
    }
  }

  reacdiff.set("u_feedA", cp5.getController("feedA").getValue());
  reacdiff.set("u_killB", cp5.getController("killB").getValue());
  reacdiff.set("u_diffA", cp5.getController("diffA").getValue());
  reacdiff.set("u_diffB", cp5.getController("diffB").getValue());
  reacdiff.set("u_mode", floor(cp5.getController("mode").getValue()));
  reacdiff.set("u_npoint", floor(cp5.getController("points").getValue()));
  reacdiff.set("u_size", cp5.getController("size").getValue());
  reacdiff.set("u_resolution", float(pg.width), float(pg.height));

  for (int i=0; i<ITERATIONS; i++)
    updateShader();

  shader(postproc);
  postproc.set("scene", pg);
  postproc.set("u_smooth", cp5.getController("smoothA").getValue(), cp5.getController("smoothB").getValue());
  postproc.set("u_resolution", float(pg.width), float(pg.height));
  noStroke();
  rect(0, 0, width, height);

  resetShader();
}


void keyPressed() {
  if (key == 'c') {
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
  } else if (key == 's') {
    String filename = "frames/reacdiff###_";
    filename += String.valueOf(cp5.getController("feedA").getValue()) + '_';
    filename += String.valueOf(cp5.getController("killB").getValue()) + '_';
    filename += String.valueOf(cp5.getController("diffA").getValue()) + '_';
    filename += String.valueOf(cp5.getController("diffB").getValue()) + ".png";
    saveFrame(filename);
    println(filename + " saved");
  }
}


boolean insideGroup(Group group) {
  float x = group.getPosition()[0];
  float y = group.getPosition()[1];
  boolean isInside = false;
  if (group.isOpen()) {
    if (mouseX >= x
      && mouseX <= x + group.getWidth()
      && mouseY >= y
      && mouseY <= y + group.getBackgroundHeight())
      isInside = true;
  }
  isInside |= group.isMouseOver();

  return isInside;
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
              /*
              print("pot 1 : " + pot1 + ", ");
               print("pot 2 : " + pot2 + ", ");
               print("pot 3 : " + pot3 + ", ");
               print("pot 4 : " + pot4 + ", ");
               print("pot 5 : " + pot5 + ", ");
               print("pot 6 : " + pot6 + ", ");
               print("pot 7 : " + pot7 + ", ");
               println("bouton 1 : " + bouton1);
               */
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
