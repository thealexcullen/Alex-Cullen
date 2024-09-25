public class Enemy extends AnimatedSprite{
 float boundaryLeft, boundaryRight;
 public Enemy(PImage img, float scale, float bLeft, float bRight){
  super(img, scale);
  moveRight= new PImage[3];
  moveRight[0]= loadImage("enemyFloating1.png");
  moveRight[1]= loadImage("enemy30deg.png");
  moveRight[2]= loadImage("enemy60deg.png");
  moveLeft= new PImage[3];
  moveLeft[0]= loadImage("enemyFloating1.png");
  moveLeft[1]= loadImage("enemy60deg.png");
  moveLeft[2]= loadImage("enemy30deg.png");
  currentImages= moveLeft;
  direction= rightFacing;
  boundaryLeft= bLeft;
  boundaryRight= bRight;
  changeX= 2;
 }
 
 void update(){
   super.update();
   if(getLeft()<= boundaryLeft){
     setLeft(boundaryLeft);
     changeX*= -1;
   }else if(getRight()>= boundaryRight){
    setRight(boundaryRight); 
    changeX+= -1;
   }
 }
 
 public void updateAnimation(){
  frame++;
  if(frame%15==0){
   selectDirection();
   selectCurrentImages();
   advanceToNextImage();
   
  }
 }
}
