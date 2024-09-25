public class AnimatedSprite extends Sprite{ 
 PImage[] currentImages;
 PImage[] standNeutral;
 PImage[] moveLeft;
 PImage[] moveRight;
 PImage[] move;
 int direction;
 int index;
 int frame;
 
 public AnimatedSprite(PImage img, float scale){
   super(img, scale);
   direction= neutralFacing;
   index= 0;
   frame= 0;
 }
 
 public void updateAnimation(){
  frame++;
  if(frame%6==0){
   selectDirection();
   selectCurrentImages();
   advanceToNextImage();
   
  }
 }
 
 public void selectDirection(){
   if(changeX>0){
     direction= rightFacing;
   }else if(changeX<0){
     direction= leftFacing;
   }else{
     direction= neutralFacing;
   }
 }
 
 public void selectCurrentImages(){
   if(direction == rightFacing){
    currentImages= moveRight; 
   } else if(direction == leftFacing){
    currentImages= moveLeft; 
   } else {
    currentImages= standNeutral; 
   }
 }
 
 public void advanceToNextImage(){
   index++;
   if(index == currentImages.length){
    index= 0; 
   }
   image= currentImages[index];
 }
  
}
