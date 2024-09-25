public class Player extends AnimatedSprite{
 int lives;
 boolean onPlatform, inPlace;
 PImage standLeft[];
 PImage standRight[];
 PImage jumpLeft[];
 PImage jumpRight[];
 PImage moveRight[];
 PImage moveLeft[];
 public Player(PImage img, float scale){
  super(img, scale);
  lives= 3;
  direction= rightFacing;
  onPlatform= false;
  inPlace= true;
  standLeft= new PImage[2];
  standLeft[0]= loadImage("standLeft.png");
  standLeft[1]= loadImage("standLeft.png");
  standRight= new PImage[2];
  standRight[0]= loadImage("standRight.png");
  standRight[1]= loadImage("standRight.png");
  jumpRight= new PImage[2];
  jumpRight[0]= loadImage("jumpRight.png");
  jumpRight[1]= loadImage("jumpRight.png");
  jumpLeft= new PImage[2];
  jumpLeft[0]= loadImage("jumpLeft.png");
  jumpLeft[1]= loadImage("jumpLeft.png");
  moveRight= new PImage[2];
  moveRight[0]= loadImage("walkRight1.png");
  moveRight[1]= loadImage("walkRight2.png");
  moveLeft= new PImage[2];
  moveLeft[0]= loadImage("walkLeft1.png");
  moveLeft[1]= loadImage("walkLeft2.png");
 }
 
 public void updateAnimation(){
  onPlatform= isOnPlatforms(this, platforms); 
  inPlace= changeX==0&&changeY==0;
  super.updateAnimation();
 }
 
 public void selectDirection(){
  if(changeX>0){
     direction= rightFacing;
   }else if(changeX<0){
     direction= leftFacing;
   } 
 }
 
 public void selectCurrentImages(){
  if(direction==rightFacing && inPlace){
      currentImages= standRight; 
  }else if(direction==rightFacing && !onPlatform){
    currentImages= jumpRight;
  }else if(direction== rightFacing){
   currentImages= moveRight; 
  }
  
  if(direction==leftFacing && inPlace){
      currentImages= standLeft; 
  }else if(direction==leftFacing && !onPlatform){
    currentImages= jumpLeft;
  }else if(direction==leftFacing){
   currentImages= moveLeft; 
  }
 }
}
