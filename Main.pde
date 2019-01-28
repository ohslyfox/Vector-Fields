import org.quark.jasmine.*;
import controlP5.*;

public final int TOTAL_FIELDS = 15; //count 0
public final int COLOR_MAX = 6;
public int BALL_COUNT = 50;
public float BALL_VELOCITYLIMIT = 20; // 2 to 50
public int MIN_X = -5;
public int MAX_X = 6;
public int MIN_Y = -5;
public int MAX_Y = 6;
public int MIN_Z = -5;
public int MAX_Z = 6;

Camera camera;
VectorProcessor processor;
Slider opacitySlider;
Slider ballCountSlider;
Slider ballVelocitySlider;
Slider xSlider;
Slider ySlider;
Slider zSlider;
Slider spreadSlider;
DialogBox particleDialogBox;
DialogBox expressionDialogBox;
Textfield expressionTextfield;
Button expressionButtonSubmit;
Button expressionButtonClear;

ControlP5 cp5;

ArrayList<Ball> ballList;
ArrayList<Vector> vectorField;
int fieldCycle = 0;
int colorCycle = 0;
float opacity;
float spread;
boolean ballToggle;
boolean infoBox;
boolean editorError;
boolean keyW, keyA, keyS, keyD, keyQ, keyZ;

 void settings() {
  size(1280,720,P3D);
  PJOGL.setIcon("VectorFieldsIcon.png");
 
 }

void setup() {
  surface.setTitle("Vector Fields");
  frameRate(60);
  smooth(2);
  cp5 = new ControlP5(this);
  
  camera = new Camera();
  infoBox = true;
  opacitySlider = new Slider(33, 135,0,255,100);
  ballCountSlider = new Slider(33,195,1,120,50);
  ballVelocitySlider = new Slider(33, 255,2,50,20);
  vectorField = new ArrayList<Vector>();
  processor = new VectorProcessor(TOTAL_FIELDS);
  ballList = new ArrayList<Ball>();
  ballToggle = false;
  particleDialogBox = new DialogBox(25, 342, 230,280, "Particle Spawn Position");
  expressionDialogBox = new DialogBox((width/2)-150,(height/2)-75,300,150,"Expression Editor");
  expressionTextfield = cp5.addTextfield("expressionTextField")
    .setPosition(expressionDialogBox.getX() + 8, expressionDialogBox.getY() + 60)
    .setSize(280,30)
    .setFont(createFont("arial",20))
    .setColor(color(0))
    .setColorBackground(color(180))
    .setColorForeground(color(0))
    .setColorActive(color(255,0,0))
    .setText(processor.functionName(0))
    .hide()
    .setCaptionLabel("")
    ;
  expressionButtonSubmit = cp5.addButton("Enter")
    .setPosition(expressionDialogBox.getX()+213,expressionDialogBox.getY() + 100)
    .setColorBackground(color(180))
    .setColorForeground(color(0,255,0))
    .setColorCaptionLabel(color(0))
    .setColorActive(color(0,100,0))
    .setSize(75,35)
    .hide()
    ;
  expressionButtonClear = cp5.addButton("Clear")
    .setPosition(expressionDialogBox.getX() + 125, expressionDialogBox.getY() + 100)
    .setColorBackground(color(180))
    .setColorForeground(color(255,0,0))
    .setColorCaptionLabel(color(0))
    .setColorActive(color(100,0,0))
    .setSize(75,35).hide()
    ;
  xSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 60, MIN_X-1, MAX_X, 0);
  ySlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 120, MIN_Y-1, MAX_Y, 0);
  zSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 180, MIN_Z-1, MAX_Z, 0);
  spreadSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 240, 1,300,150);
  spread = 50;
  createBalls();
  opacity = 100;
  genField(0);
  editorError = false;
}

void keyPressed() {
  if (!expressionTextfield.isActive()){
  if (key == 'r' || key == 'R') {
    camera = new Camera();
  }
  if (key == 't' || key == 'T') {
    ballToggle = !ballToggle;
    if (ballToggle == false) {
      if (colorCycle == COLOR_MAX) {
        colorCycle = 0;  
      }
      else {
        colorCycle++;
      }
      createBalls();
    }
  }
  if (key == 'x' || key == 'X') {
    particleDialogBox.visible();
  }
  if (key == 'e' || key == 'E') {
    expressionDialogBox.visible();
    expressionTextfield.setVisible(!expressionTextfield.isVisible());
    expressionButtonSubmit.setVisible(!expressionButtonSubmit.isVisible());
    expressionButtonClear.setVisible(!expressionButtonClear.isVisible());
  }
  if (key == '`') {
   infoBox = !infoBox;
  }
  if (key == '1') {
    vectorField.clear();
    if (fieldCycle == 0) {
      fieldCycle = TOTAL_FIELDS;
    }
    else {
      fieldCycle--;
    }
    genField(fieldCycle); 
    expressionTextfield.setText(processor.functionName(fieldCycle));
  }
  if (key == '2') {
    vectorField.clear();
    if (fieldCycle == TOTAL_FIELDS) {
      fieldCycle = 0;
    }
    else {
      fieldCycle++;
    }
    genField(fieldCycle); 
    expressionTextfield.setText(processor.functionName(fieldCycle));
  }
  
  if (key == '[') {
    if (!(MAX_X - MIN_X <= 1)) {
      if (MIN_X != 0) {
        MIN_X++;
      }
      if (MAX_X != 1) {
        MAX_X--;
      }
      xSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 60, MIN_X-1, MAX_X, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
  if (key == ']') {
    if (!(MAX_X - MIN_X >=21)) {
      MIN_X--;
      MAX_X++;
      xSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 60, MIN_X-1, MAX_X, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
  if (key == ';') {
    if (!(MAX_Y - MIN_Y <= 1)) {
      if (MIN_Y != 0) {
        MIN_Y++;
      }
      if (MAX_Y != 1) {
        MAX_Y--;
      }
      ySlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 120, MIN_Y-1, MAX_Y, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
  if (key == '\'') {
    if (!(MAX_Y - MIN_Y >= 21)) {
      MIN_Y--;
      MAX_Y++;
      ySlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 120, MIN_Y-1, MAX_Y, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
    if (key == '.') {
    if (!(MAX_Z - MIN_Z <= 1)) {
      if (MIN_Z != 0) {
        MIN_Z++;
      }
      if (MAX_Z != 1) {
        MAX_Z--;
      }
      zSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 180, MIN_Z-1, MAX_Z, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
  if (key == '/') {
    if (!(MAX_Z - MIN_Z >= 21)) {
      MIN_Z--;
      MAX_Z++;
      zSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 180, MIN_Z-1, MAX_Z, 0);
      vectorField.clear();
      genField(fieldCycle);
    }
  }
  if (key == 'd' || key == 'D') {
    keyD = true;
  }
  if (key == 'a' || key == 'A') {
    keyA = true;
  }
  if (key == 'w' || key == 'W') {
    keyW = true;
  }
  if (key == 's' || key == 'S') {
    keyS = true;
  }
  if (key == 'q' || key == 'Q' || keyCode == UP) {
    keyQ = true;
  }
  if (key == 'z' || key == 'Z' || keyCode == DOWN) {
    keyZ = true;
  }
  
  }

}

void keyReleased() {
  keyW = false;
  keyA = false;
  keyS = false;
  keyD = false;
  keyQ = false;
  keyZ = false;
}

void mousePressed() {
  camera.setLocation(mouseX,mouseY);
}

void mouseReleased() {
  if (opacitySlider.isPressed()) {
    opacitySlider.setPressed(false);
  }
  
  if (ballCountSlider.isPressed()) {
    BALL_COUNT = (int)ballCountSlider.getProgress();
    createBalls();
    ballCountSlider.setPressed(false); 
  }
  
  if (ballVelocitySlider.isPressed()) {
    ballVelocitySlider.setPressed(false);
  }
  
  if (particleDialogBox.isPressed()) {
    particleDialogBox.setPressed(false);
  }
  
  if (xSlider.isPressed()) {
    xSlider.setPressed(false);
  }
  
  if (ySlider.isPressed()) {
    ySlider.setPressed(false);
  }
  
  if(zSlider.isPressed()) {
    zSlider.setPressed(false);
  }
  
  if (spreadSlider.isPressed()) {
    spreadSlider.setPressed(false);
  }
  
  if (expressionDialogBox.isPressed()) {
    expressionDialogBox.setPressed(false);
  }
}

void createBalls() {
  ballList.clear();
  if (particleDialogBox.isVisible()) {
    float finalSpread = spread/100;
    for (int i = 0; i < BALL_COUNT; i++) {
      ballList.add(new Ball(new PVector((xSlider.getProgress())+random(-finalSpread,finalSpread), (ySlider.getProgress())+random(-finalSpread,finalSpread), (zSlider.getProgress())+random(-finalSpread,finalSpread)), BALL_VELOCITYLIMIT, colorCycle)); 
    }
  }
  else {
    for (int i = 0; i < BALL_COUNT; i++) {
      ballList.add(new Ball(new PVector(random(MIN_X+200, MAX_X-200), random(MIN_Y+200, MAX_Y-200), random(MIN_Z+200, MAX_Z-200)), BALL_VELOCITYLIMIT, colorCycle)); 
    }
  }
}

void genField(int function) {
  for (int i = MIN_X; i < MAX_X; i++) {
    for (int j = MIN_Y; j < MAX_Y; j++) {
      for (int z = MIN_Z; z < MAX_Z; z++) {
        PVector currentPoint = new PVector(i, j, z);
        PVector outputVector = processor.calculateEnd2(currentPoint,function);
        
        Vector resultVector = new Vector(currentPoint, outputVector);
        resultVector.setOpacity(opacity);
        vectorField.add(resultVector);
      }
    }
  }
}

public void Enter(int buttonVal) {
  Object originalField = vectorField.clone();
  String theExpression = expressionTextfield.getText();
  processor.editFunction(fieldCycle, theExpression);
  while(originalField.equals(vectorField)) {
    vectorField.clear();
    genField(fieldCycle);
  }
}

public void Clear(int buttonVal) {
  expressionTextfield.setText("");
}

void draw() {
  background(200);
  lights();
  //camera rotate
  if(mousePressed && (mouseButton == LEFT) && !opacitySlider.isPressed() && !ballCountSlider.isPressed() && !ballVelocitySlider.isPressed() && !particleDialogBox.isPressed() && !xSlider.isPressed() &&
  !ySlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed() && !expressionDialogBox.isPressed()){
    PVector pLocation = camera.getLocation();
      
    float currentLocationX = mouseX - pLocation.x;
    float currentLocationY = mouseY - pLocation.y;
    camera.setCameraX(camera.getCameraX() + currentLocationY*PI/75000);
    camera.setCameraY(camera.getCameraY() + currentLocationX*PI/75000);
  }
  //camera key check
  if (keyPressed && !expressionTextfield.isActive()) {
    if (keyD) {
      camera.zoomIn(10);
    }
    if (keyA) {
      camera.zoomOut(10);
    }
    if (keyW) {
      camera.slide(10);
    }
    if (keyS) {
      camera.slide(-10);
    }
    if (keyQ) {
      camera.vert(10);
    }
    if (keyZ) {
      camera.vert(-10);
    }
  }
  ////camera values
  //println(camera.getCameraX());
  //println(camera.getCameraY());
  //println(camera.zoomX);
  //println(camera.zoomY);
  //println(camera.zoomZ);
  //Particle Dialog Box
  if (particleDialogBox.isVisible()) {
  fill(0);
  strokeWeight(2);
  stroke(0,0,0,255);
  if ((particleDialogBox.collision() && mousePressed) && !xSlider.isPressed() && !ySlider.isPressed() && !zSlider.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed()
  && !ballVelocitySlider.isPressed()&& !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    particleDialogBox.setPressed(true);
  }
  particleDialogBox.move();
  particleDialogBox.display();
  
  //xSlider
  fill(180);
  rect(particleDialogBox.getX() + 8, particleDialogBox.getY() +60, 215,25);
  fill(0);
  text("X Spawn: " + String.format("%.1f", xSlider.getProgress()), particleDialogBox.getX() + 13, particleDialogBox.getY() + 50);
  
  if (((xSlider.collision() && mousePressed) || xSlider.isPressed()) && !particleDialogBox.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed() && !ballVelocitySlider.isPressed() &&
  !ySlider.isPressed() && !zSlider.isPressed()&& !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    xSlider.setPressed(true);
    xSlider.update();
  }
  
  //change slider pos if box moves
  if (particleDialogBox.isPressed() && !xSlider.isPressed() && !ySlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed()) {
    float oProgress = (xSlider.getProgress());
    xSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 60, MIN_X-1, MAX_X, oProgress);
  }
  xSlider.display();
  
  
  //ySlider
  fill(180);
  rect(particleDialogBox.getX() + 8, particleDialogBox.getY() + 120, 215,25);
  fill(0);
  text("Y Spawn: " + String.format("%.1f", ySlider.getProgress()), particleDialogBox.getX() + 13, particleDialogBox.getY() + 110);
  
  if (((ySlider.collision() && mousePressed) || ySlider.isPressed()) && !particleDialogBox.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed() && !ballVelocitySlider.isPressed() &&
  !xSlider.isPressed() && !zSlider.isPressed()&& !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    ySlider.setPressed(true);
    ySlider.update();
  }
  
  //change slider pos if box moves
  if (particleDialogBox.isPressed() && !ySlider.isPressed() && !xSlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed()) {
    float oProgress = (ySlider.getProgress());
    ySlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 120, MIN_Y-1, MAX_Y, oProgress);
  }
  ySlider.display();
  
  
  //zSlider
  fill(180);
  rect(particleDialogBox.getX() + 8, particleDialogBox.getY() + 180, 215,25);
  fill(0);
  text("Z Spawn: " + String.format("%.1f", zSlider.getProgress()), particleDialogBox.getX() + 13, particleDialogBox.getY() + 170);
  
  if (((zSlider.collision() && mousePressed) || zSlider.isPressed()) && !particleDialogBox.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed() && !ballVelocitySlider.isPressed() &&
  !xSlider.isPressed() && !ySlider.isPressed()&& !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    zSlider.setPressed(true);
    zSlider.update();
  }
  
  //change slider pos if box moves
  if (particleDialogBox.isPressed() && !zSlider.isPressed() && !xSlider.isPressed() && !ySlider.isPressed() && !spreadSlider.isPressed()) {
    float oProgress = (zSlider.getProgress());
    zSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 180, MIN_Z-1, MAX_Z, oProgress);
  }
  zSlider.display();
  
  
  //spread slider
  fill(180);
  rect(particleDialogBox.getX() + 8, particleDialogBox.getY() + 240,215,25);
  fill(0);
  text("Particle Spread: " + String.format("%.1f", map(spreadSlider.getProgress(),0,300,0,3)) + " units", particleDialogBox.getX() +13, particleDialogBox.getY()+230);
  
  if (((spreadSlider.collision() && mousePressed) || spreadSlider.isPressed()) && !particleDialogBox.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed() &&
  !ballVelocitySlider.isPressed() && !xSlider.isPressed() && !ySlider.isPressed() && !zSlider.isPressed() && !expressionDialogBox.isPressed()) {
    spreadSlider.setPressed(true);
    spreadSlider.update();
  }
  //change slider pos if box moves
  if (particleDialogBox.isPressed() && !spreadSlider.isPressed() && !xSlider.isPressed() && !ySlider.isPressed() && !zSlider.isPressed() && !expressionDialogBox.isPressed()) {
    float oProgress = (spreadSlider.getProgress());
    spreadSlider = new Slider(particleDialogBox.getX() +8, particleDialogBox.getY() + 240, 1, 300, oProgress);
  }
  spreadSlider.display();
  spread = spreadSlider.getProgress();
  
  }
  //end dialog box
  
  
  //Expression Editor Dialog Box
  if (expressionDialogBox.isVisible()) {
    fill(0);
    strokeWeight(2);
    stroke(0,0,0,255);
    
    if ((expressionDialogBox.collision() && mousePressed) && !xSlider.isPressed() && !ySlider.isPressed() && !zSlider.isPressed() && !opacitySlider.isPressed() && !ballCountSlider.isPressed() &&
    !ballVelocitySlider.isPressed() && !spreadSlider.isPressed() && !particleDialogBox.isPressed()) {
      expressionDialogBox.setPressed(true);
    }
    expressionDialogBox.move();
    expressionDialogBox.display();
    expressionTextfield.setPosition(expressionDialogBox.getX() + 8, expressionDialogBox.getY() + 60);
    expressionButtonSubmit.setPosition(expressionDialogBox.getX()+213,expressionDialogBox.getY() + 100);
    expressionButtonClear.setPosition(expressionDialogBox.getX() + 125, expressionDialogBox.getY() + 100);
    text("Vector Valued Function:",expressionDialogBox.getX() + 8, expressionDialogBox.getY() + 50);
    //text("Vector Valued Function:",expressionDialogBox.getX() + 9, expressionDialogBox.getY() + 50);
    
    //info button
    fill(255,255,0,100);
    rect(expressionDialogBox.getX() + 11, expressionDialogBox.getY()+113,20,20);
    fill(0);
    text("?",expressionDialogBox.getX() + 19,expressionDialogBox.getY()+127);
    //check if mouse is hovering
    if (dist(mouseX,mouseY,expressionDialogBox.getX() + 21,expressionDialogBox.getY() + 123) < 11) {
      fill(255,255,0,100);
      rect(mouseX+20,mouseY+40,235,200);
      fill(0);
      text("OPERATORS:\n+,    -,    *,    /,    %,    ^\n\nFUNCTIONS:\nabs(x),    cbrt(x),    ceil(x),    exp(x),\nfloor(x),    log10(x),    log(x),\nmax(x,y),    min(x,y),    random(x,y),\nround(x),    sqrt(x),    cos(x),\ncosh(x),    acos(x),    sin(x),    sinh(x),\nasin(x),    tan(x),    tanh(x),    atan(x)\n\nCONSTANTS:\nPI,    E",mouseX+30,mouseY+60);
      text("OPERATORS:\n\n\nFUNCTIONS:\n\n\n\n\n\n\n\nCONSTANTS:",mouseX+31,mouseY+60);
    }
    
    //error button
    if (editorError) {
      fill(255,50,50,100);
      strokeWeight(2);
      rect(expressionDialogBox.getX() + 40, expressionDialogBox.getY() + 113, 20,20);
      fill(0);
      text("!", expressionDialogBox.getX() + 48, expressionDialogBox.getY() + 127);
      //check if mouse is hovering
      if (dist(mouseX,mouseY,expressionDialogBox.getX()+50,expressionDialogBox.getY()+123) < 11) {
       fill(255,50,50,100);
       rect(mouseX+20,mouseY+40,230,105);
       fill(0);
       text("An error occured when attempting\nto edit the vector field. Be sure that\neach component is seperated by a\ncomma, function parameters are\nenclosed by parenthesis, and the\nfunction begins with < and ends in >",mouseX+28,mouseY+60);
      }
    }
  }
  //end dialog box
  
  
  
  //info box
  if (infoBox) {
  fill(255);
  stroke(0,0,0,255);
  strokeWeight(2);
  rect(25, 25, 230,300);
  fill(0);
  text("Dimensions: " + (MAX_X-MIN_X) + " X " + (MAX_Y-MIN_Y) + " X " + (MAX_Z-MIN_Z), 37,50);

  text("F(x,y,z)", 37, 80);
  String functionDisplay = processor.functionName(fieldCycle);
  if (functionDisplay.length() > 20) {
    functionDisplay = functionDisplay.substring(0,20) + "\n" + functionDisplay.substring(20,functionDisplay.length());
  }
  text("F(x,y,z) = " +functionDisplay, 38, 80);
  
  //OPACITY SLIDER
  fill(180);
  rect(32, 135, 215,25);
  fill(0);
  text("Field Opacity: " + (int)map(opacitySlider.getProgress(),0,255,0,100) + " %", 37, 125);

  opacitySlider.display();
  if (((opacitySlider.collision() && mousePressed) || opacitySlider.isPressed()) && !ballCountSlider.isPressed() && !ballVelocitySlider.isPressed() && !particleDialogBox.isPressed() && !xSlider.isPressed() &&
  !ySlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed() && !expressionDialogBox.isPressed()){
    opacitySlider.setPressed(true);
    opacitySlider.update();
  }
  
  //BALL COUNT SLIDER
  fill(180);
  rect(32,195,215,25);
  fill(0);
  text("Particle Count: " + (int)ballCountSlider.getProgress(), 37, 185);
  
  ballCountSlider.display();
  if (((ballCountSlider.collision() && mousePressed) || ballCountSlider.isPressed()) && !opacitySlider.isPressed() && !ballVelocitySlider.isPressed() && !particleDialogBox.isPressed() && !xSlider.isPressed() &&
  !ySlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    ballCountSlider.setPressed(true);
    ballCountSlider.update();
  }
  
  //BALL SPEED SLIDER
  fill(180);
  rect(32,255,215,25);
  fill(0);
  text("Particle Velocity: " + (int)map(ballVelocitySlider.getProgress(),2,50,1,100) + " %", 37, 245);
  
  ballVelocitySlider.display();
  if (((ballVelocitySlider.collision() && mousePressed) || ballVelocitySlider.isPressed()) && !opacitySlider.isPressed() && !ballCountSlider.isPressed() && !particleDialogBox.isPressed() && !xSlider.isPressed() &&
  !ySlider.isPressed() && !zSlider.isPressed() && !spreadSlider.isPressed() && !expressionDialogBox.isPressed()) {
    ballVelocitySlider.setPressed(true);
    ballVelocitySlider.update();
  }
  
  //INFO BUTTON
  fill(255,255,0,100);
  rect(226,297,20,20);
  fill(0);
  text("?",234,311);
  //check if mouse is hovering
  if (dist(mouseX,mouseY,236,307) < 11) {
   fill(255,255,0,100);
   rect(mouseX+20,mouseY+20,225,170);
   fill(0);
   text("W/S key for RED (x) axis\nA/D key for BLUE (y) axis\nQ/Z or Up/Down for GREEN (z) axis\nClick and drag to adjust camera\nR to reset camera\nE to toggle expression editor\nT to toggle particle simulator\nX to toggle particle position control\n1 and 2 to cycle fields\n[] ;' ./ to adjust dimensions\nTILDE ` to toggle info box",mouseX+30,mouseY+40);
  }
  
  //FPS
  fill(0);
  text("FPS: " + round(frameRate), width - 55, 27);
  
  }
  fill(0,0,0,75);
  text("by slyfox", 25, height-10);
  //end info box

  //AXES
  pushMatrix();
  camera.run();
  strokeWeight(0);
  fill(255,0,0);
  box(10000,2,2);
  fill(0,255,0);
  box(2,10000,2);
  fill(0,0,255);
  box(2,2,10000);
  popMatrix();


  //Vector Field 
  opacity = opacitySlider.getProgress();
  for(Vector current : vectorField) {
    pushMatrix();
    camera.run();
    current.setOpacity(opacity);
    current.display();
    popMatrix();
  }
  
  //Balls
  if (ballToggle) {
    pushMatrix();
    camera.run();
    for (int i = 0; i < ballList.size(); i++) {
      Ball thisBall = ballList.get(i); 
      //gravity
      //thisBall.applyForce(new PVector(0, 0, -9.8));
      
      //vector force
      PVector pos = thisBall.getPosition().copy();
      pos.div(100);
      PVector fieldForce = processor.calculateEnd2(pos, fieldCycle);
      fieldForce.sub(pos);
      fieldForce.mult(1000);

      BALL_VELOCITYLIMIT = ballVelocitySlider.getProgress();
      thisBall.setVelocityLimit(BALL_VELOCITYLIMIT);
      thisBall.applyForce(fieldForce);
      thisBall.act();
      thisBall.display();
      //BALL RESPAWN
      // there are two methods here, one is commented out
      // the second method checks the boundary of the square which is containing the vector field
      // the first method uses the distance function to simplify the amount of position checking necessary for one ball
      // sqrt(MAX_X^2 + MAX_Y^2) is the distance to one edge of the square, using this as a max distance has the trade off 
      // of allowing straight up, down, left, right, in, and out to exceed the boundary of the square slightly
      // to illustrate this, draw a circle of radius 1 in R^2, then contain it in the smallest possible square
      // the circle represents distance function, the square is the vector field. Checking the distance to the edge of
      // the circle will leave out part of the square, so we check to the corner of the square; however, this distance is the largest
      // possible distance within the square so when you apply it to the distance function your region exceeds the boundary of the field
      // +.5 is to allow slightly more exceeding to happen, and *100 scales the value to the scale of our project
      
      //if (dist(0, 0, 0, thisBall.getPosition().x, thisBall.getPosition().y, thisBall.getPosition().z) > (sqrt(pow(MAX_X+1,2) + pow(MAX_Y+1,2)))*100) {
      //  if (particleDialogBox.isVisible()) {
      //    float finalSpread = spread/100;
      //    ballList.set(i, new Ball(new PVector((xSlider.getProgress())+random(-finalSpread,finalSpread), (ySlider.getProgress())+random(-finalSpread,finalSpread), (zSlider.getProgress())+random(-finalSpread,finalSpread)), BALL_VELOCITYLIMIT, colorCycle));
      //  }
      //  else {
      //    ballList.set(i, new Ball(new PVector(random(MIN_X, MAX_X), random(MIN_Y, MAX_Y), random(MIN_Z, MAX_Z)), BALL_VELOCITYLIMIT, colorCycle));
      //  }
      //}
      
      if ((thisBall.getPosition().x > (MAX_X*100)+50) || (thisBall.getPosition().x < (MIN_X*100)-50) || (thisBall.getPosition().y > (MAX_Y*100)+50)
         || (thisBall.getPosition().y < (MIN_Y*100)-50) || (thisBall.getPosition().z > (MAX_Z*100)+50) || (thisBall.getPosition().z < (MIN_Z*100)-50)) {
        
        if (particleDialogBox.isVisible()) {
          float finalSpread = spread/100;
          ballList.set(i, new Ball(new PVector((xSlider.getProgress())+random(-finalSpread,finalSpread), (ySlider.getProgress())+random(-finalSpread,finalSpread), (zSlider.getProgress())+random(-finalSpread,finalSpread)), BALL_VELOCITYLIMIT, colorCycle));
        }
        else {
          ballList.set(i, new Ball(new PVector(random(MIN_X, MAX_X), random(MIN_Y, MAX_Y), random(MIN_Z, MAX_Z)), BALL_VELOCITYLIMIT, colorCycle));
        }
      }
      
    }
    popMatrix();
  }
  
  
  //Particle Position Visualizer
  if (xSlider.isPressed() || ySlider.isPressed() || zSlider.isPressed() || spreadSlider.isPressed()) {
    pushMatrix();
    camera.run();
    translate(xSlider.getProgress()*100,-zSlider.getProgress()*100,-ySlider.getProgress()*100);
    noStroke();
    fill(255,0,0,100);
    float radius = spreadSlider.getProgress()+10;
    if (radius < 20) {
      radius = 20;
    }
    sphere(radius);
    popMatrix();
  }
  
}
