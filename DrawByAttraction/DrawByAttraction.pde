import controlP5.*;

ArrayList<Mover> movers = new ArrayList<Mover>();
ArrayList<PShape> shapes = new ArrayList<PShape>();
Attractor attractor;
PGraphics canvas;
PImage source;
float shapeStrokeAlpha, shapeFillAlpha, shapeStrokeWeight;
int shapesPerClick, shapeSpeed;
boolean isShapeRotationRandom, isShapeFillWhite, isShapeStrokeWhite;
private ControlP5 cp5;

//----------------------------------------------------------------------
// SETUP
//----------------------------------------------------------------------

void setup() {
  background(255);
  source = loadImage("bitmap/5318251512_66245243d7_o.jpg");
  size(source.width, source.height, P2D);
  canvas = createGraphics(width, height);
  attractor = new Attractor();
  //loadVectors("birds", false);
  //loadVectors("strokes", false);
  //loadVectors("mold",true);
  loadVectors("joshuadavis", false);
  //loadVectors("letters", true);
  //loadVectors("arrows",true);
  defaults();
  setupCP5();
}

//----------------------------------------------------------------------
// DRAW
//----------------------------------------------------------------------

void draw() {
  background(255);
  image(canvas, 0, 0);
  if (mousePressed) {
    canvas.beginDraw();
    for (int i = 0; i < shapeSpeed; i++) {
      update();
    }
    canvas.endDraw();
  }
  if (cp5.isVisible()) {
    noStroke();
    fill(255, 225);
    rect(0, 0, width, 150);
  }
}

//----------------------------------------------------------------------
// Set up our control panel
//----------------------------------------------------------------------

void setupCP5() {
  String helpText = "H - Show/hide this control panel.\n";
  helpText += "[SPACE] - Clear the canvas.\n";
  helpText += "R - Randomize all parameters.\n";
  helpText += "D - Set all parameters back to defaults.\n";
  helpText += "S - Save the canvas to a PNG file.\n";
  helpText += "P - Save the current properties.\n";
  cp5 = new ControlP5(this);
  cp5.setColor(new CColor(0xffaa0000, 0xff330000, 0xffff0000, 0xff000000, 0xffffffff));
  cp5.addSlider("shapeStrokeAlpha").plugTo("shapeStrokeAlpha").setPosition(10, 10).setSize(200, 10).setRange(0, 255);
  cp5.addSlider("shapeFillAlpha").setPosition(10, 25).setSize(200, 10).setRange(0, 255);
  cp5.addSlider("shapesPerClick").setPosition(10, 40).setSize(200, 10).setRange(1, 15);
  cp5.addSlider("shapeSpeed").setPosition(10, 55).setSize(200, 10).setRange(1, 15);
  cp5.addSlider("shapeStrokeWeight").setPosition(10, 70).setSize(200, 10).setRange(0.1, 15);
  cp5.addToggle("isShapeRotationRandom").setPosition(10, 85).setSize(10, 10).setValue(false);
  cp5.addToggle("isShapeStrokeWhite").setPosition(10, 110).setSize(10, 10).setValue(false);
  cp5.addToggle("isShapeFillWhite").setPosition(150, 85).setSize(10, 10).setValue(false);
  cp5.addTextlabel("misc").setPosition(400, 10).setColorValue(0xff000000).setText(helpText);
  cp5.loadProperties("data/settings/app.properties");
}

//----------------------------------------------------------------------
// Set our particles in motion
//----------------------------------------------------------------------

void update() {
  for (int i = 0; i < movers.size(); i++) {
    Mover m = movers.get(i);
    m.applyForce(attractor.attract(m));
    m.update();
    int c = source.get((int) m.location.x, (int) m.location.y);
    PShape shape = shapes.get((int) random(shapes.size()));
    shape.resetMatrix();
    shape.disableStyle();
    shape.scale(m.radius);
    canvas.stroke(red(c), green(c), blue(c), shapeStrokeAlpha);
    canvas.fill(red(c), green(c), blue(c), shapeFillAlpha);
    canvas.strokeWeight(shapeStrokeWeight * (1 / m.radius));
    if (!isShapeRotationRandom) shape.rotate(m.velocity.heading2D());
    if (isShapeRotationRandom) shape.rotate(random(360));
    if (isShapeStrokeWhite) canvas.stroke(255, shapeStrokeAlpha);
    if (isShapeFillWhite) canvas.fill(255, shapeFillAlpha);
    canvas.shape(shape, m.location.x, m.location.y);
  }
  attractor.updateLocation(new PVector(mouseX, mouseY));
}

//----------------------------------------------------------------------
// Load vectors from given files and folders
//----------------------------------------------------------------------

void loadVectors(String folderName, boolean loadChildrenAsShapes) {
  File folder = new File(this.sketchPath+"/data/vector/" + folderName);
  File[] listOfFiles = folder.listFiles();
  for (File file : listOfFiles) {
    if (file.isFile()) {
      PShape shape = loadShape(file.getAbsolutePath());
      if (loadChildrenAsShapes) {
        for (PShape layer : shape.getChildren()) {
          if (layer!=null) shapes.add(layer);
        }
      } 
      else {
        shapes.add(shape);
      }
    }
  }
}

//----------------------------------------------------------------------
// Randomize or generate defaults for the app's parameters
//----------------------------------------------------------------------

void randomize() {
  shapeStrokeAlpha = random(255);
  shapeFillAlpha = random(255);
  shapesPerClick = (int) random(1, 30);
  shapeSpeed = (int) random(1, 10);
  isShapeRotationRandom = (random(1)>0.5) ? true : false;
  isShapeFillWhite = (random(1)>0.5) ? true : false;
  isShapeStrokeWhite = (random(1)>0.5) ? true : false;
  shapeStrokeWeight = random(5);
}

void defaults() {
  shapeStrokeAlpha = 255;
  shapeFillAlpha = 255;
  shapesPerClick = 5;
  shapeSpeed = 2;
  isShapeRotationRandom = false;
  isShapeFillWhite = false;
  shapeStrokeWeight = 1;
  isShapeStrokeWhite = true;
}

//----------------------------------------------------------------------
// Key Events
//----------------------------------------------------------------------

void keyPressed() {
  if (key == ' ') {
    background(255);
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
  }
  if (key == 'h') {
    if (cp5.isVisible()) cp5.hide();
    else cp5.show();
  }
  if (key =='b') {
    canvas.blend(source, 0, 0, width, height, 0, 0, width, height, OVERLAY);
  }
  if (key == 'r') {
    randomize();
  }
  if (key == 'd') {
    defaults();
  }
  if (key == 's') {
    canvas.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png");
  }
  if (key == 'p') {
    cp5.saveProperties("data/settings/app.properties");
  }
}

//----------------------------------------------------------------------
// Mouse Events
//----------------------------------------------------------------------

void mouseReleased() {
  movers.clear();
}

void mousePressed() {
  if (cp5.isMouseOver()) return;
  for (int i = 0; i < shapesPerClick; i++) {
    movers.add(new Mover(1.0, new PVector(mouseX, mouseY), random(0.01)));
  }
}

