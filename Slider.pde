class Slider {
  
 float x;
 float y;
 
 float oX;
 float oY;
 float progress;
 float oProgress;
 float oMouseX;
 float firstProgress;
 int max;
 int min;
 int len;
 int hig;
 boolean pressed;
 
 Slider(int x, int y, int min, int max, float progress) {
   this.len = 25;
   this.hig = 25;
   this.x = x + (int)(map(progress, min, max, this.x, this.x+190));
   this.y = y;
   this.oX = x;
   this.oY = y;
   this.min = min;
   this.max = max;
   this.progress = progress;
   this.oProgress = progress;
   this.firstProgress = progress;
   
 }
 
 
 void update() {
   if ((this.x <= (this.oX + 190)) && (this.x >= (this.oX))){
     this.x += (mouseX - this.oMouseX);
     this.oMouseX = mouseX;
   }
   if (this.x < this.oX) {
     this.x = this.oX;
   }
   if (this.x > this.oX + 190) {
     this.x = this.oX + 190;
   }
   
   progress = this.oProgress + this.x - this.oX;
   progress = map(progress, (firstProgress), (firstProgress+190), min, max);
 }
 
 void setPressed(boolean input) {
   if (input == true && this.pressed == false) {
     this.oMouseX = mouseX; 
   }
   this.pressed = input;
 }
 
 boolean isPressed() {
   return this.pressed;
 }
 
 boolean collision() {
   if (dist(this.x,this.y, mouseX, mouseY) < 30) {
     return true; 
   }
   return false;
 }
 
 void display() {
   fill(0);
   rect(x,y,len,hig);
 }

  float getProgress() {
    return progress;
  }
}
