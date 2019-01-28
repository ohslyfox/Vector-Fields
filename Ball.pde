class Ball {
  
  //PShape model;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float airResistance;
  float velocityLimit;
  float mass;
  float r,g,b;
  int colorChoice; //(int)rand(0,4)
  
  Ball(PVector position, float velocityLimit, int colorChoice) {
    // model = loadShape("ballofweirdshapes.obj");
    position.mult(100);
    this.position = position;
    velocity = new PVector(0,0,0);
    acceleration = new PVector(0,0,0);
    airResistance = 0.35;
    this.velocityLimit = velocityLimit;
    mass = 1000;
    //r = random(0,100);
    //g = random(180,255);
    //b = random(0,100);
    this.colorChoice = colorChoice;
    if (colorChoice == 0) {
      r = random(0,70);
      g = random(180,255);
      b = random(0,100);
    }
    if (colorChoice == 1) {
      r = random(0,0);
      g = random(120,255);
      b = random(221,255);
    }
    if (colorChoice == 2) {
      r = random(0,115);
      g = random(0,100);
      b = random(255,255);
    }
    if (colorChoice == 3) {
      r = random(180,255);
      g = random(0,0);
      b = random(0,255);
    }
    if (colorChoice == 4) {
      r = random(255,255);
      g = random(0,144);
      b = random(0,0);
    }
    if (colorChoice == 5) {
      r = random(165,255);
      g = random(165,255);
      b = random(0,0); 
    }
    if (colorChoice == 6) {
      r = random(0,255);
      g = random(0,255);
      b = random(0,255);
    }
    
  }
  
  PVector getPosition() {
    return this.position;
  }
  
  void setVelocityLimit(float input) {
    this.velocityLimit = input;
  }
  
  //F = MA
  //A = F / M
  void applyForce(PVector force) {
    force.div(this.mass);
    acceleration.set(force);
  }
  
  void act() {
    position.add(velocity);
    velocity.add(acceleration.mult(10));
    velocity.limit(velocityLimit);
    if (velocity.mag() > 1) {
      velocity.mult(airResistance);
    }
    
  }
  
  void display() {
    pushMatrix();
    translate(position.x, -position.z, -position.y);
    noStroke();
    fill(r,g,b);
    sphere(10);
    //scale(250);
    //model.setFill(color(0,255,0));
    //shape(model);
    popMatrix();
  }
  
  
}
