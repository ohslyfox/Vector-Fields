class Vector {
  
  PVector location;
  PVector outputVector;
  float opacityV;
  
  public Vector(PVector location, PVector outputVector) {
    location.mult(100);
    outputVector.mult(100);
    this.location = location;
    this.outputVector = outputVector;
    opacityV = 60;
  }
  
  public void setOpacity(float input) {
    this.opacityV = input;
  }
  
  public void display() {
    pushMatrix();
    
    //Main Vector Body
    PVector shell = outputVector.copy();
    shell = PVector.lerp(location, outputVector, .2);
    stroke(0,0,0,opacityV);
    strokeWeight(4);
    line(location.x, -location.z, -location.y, shell.x, -shell.z, -shell.y);
    
    //Red Vector Tip
    PVector shell2 = shell.copy();
    shell2.lerp(outputVector, .05);
    
    if (opacityV+35 > 255) {
      stroke(255,0,0,255);
    }
    else if (opacityV == 0) {
      stroke(255,0,0,0);
    }
    else {
      stroke(255,0,0,opacityV+35);
    }

    strokeWeight(3);
    line(shell.x, -shell.z, -shell.y, shell2.x, -shell2.z, -shell2.y);

    
    
    ////arrow head 
    //PVector temp = outputVector.copy();
    //temp.mult(.9);
    //strokeWeight(2);
    //line(outputVector.x, -outputVector.z, -outputVector.y, outputVector.x-5, -temp.z, -temp.y); 
    //line(outputVector.x, -outputVector.z, -outputVector.y, outputVector.x+5, -temp.z, -temp.y); 
    

    //line(outputVector.x, -outputVector.z, -outputVector.y, outputVector.x, -temp.z, (-temp.y)+10); 
    //line(outputVector.x, -outputVector.z, -outputVector.y, outputVector.x, -temp.z, (-temp.y)-10); 

    popMatrix();
  }
}
