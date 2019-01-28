class Camera{
  PVector location;
  float cameraX; //camera x and camera y are backwards XD
  float cameraY;
  float zoomX;
  float zoomZ;
  float zoomY;
  
  Camera(){
    location = new PVector(0, 0);
    cameraX = -0.34347826;
    cameraY = -2.372144;
    zoomX = -1790;
    zoomZ = 880;
    zoomY = 920;
  }
  
  void setLocation(int x, int y){
    location.x = x;
    location.y = y;
    
  }
  
  void setCameraX(float x){
    //if(x > .15){
    //  this.setCameraX(.15);
    //}
    //else if(x < -.5){
    //  this.setCameraX(-.5);
    //}
    //else{
      cameraX = x;
    //}  
  }
  
  void setCameraY(float y){
    cameraY = y;
    //if(y > .75){
    //  this.setCameraY(.75);
    //}
    //else if(y < -.75){
    //  this.setCameraY(-.75);
    //}
    //else{
    //  cameraY = y;
    //}
  }
  
  void walk(float amount) {
    zoomZ += amount;
  }
  
  void slide(float amount) {
    zoomX += amount;
    if ((zoomX > 2999)) {
      zoomX = 3000;
    }
    if ((zoomX < -2899)) {
      zoomX = -2900;
    }
  }
  
  void zoomOut(float amount){
      this.zoomZ -= amount;
      if (this.zoomZ < -3299) {
      this.zoomZ = -3300;
    }

  }
  
  void zoomIn(float amount){
    this.zoomZ += amount;
    
    if (this.zoomZ > 3399) {
      this.zoomZ = 3400;
    }
  }
  
  void vert(float amount) {
    this.zoomY += amount;
    if (this.zoomY < -1449) {
      this.zoomY = -1450;
    }
    if (this.zoomY > 2999) {
      this.zoomY = 3000;
    }
  }
  
  
  float getZoomZ(){
    return zoomZ;
  }
  
  float getZoomY(){
    return zoomY;
  }
  
  float getCameraX(){
    return cameraX;
  }
  
  float getCameraY(){
    return cameraY;
  }
  
  void run(){
    rotateX(this.getCameraX());
    rotateY(this.getCameraY());
    translate(zoomX, zoomY, zoomZ);
  }
  
  PVector getLocation(){
    return location;
  }
  
}
