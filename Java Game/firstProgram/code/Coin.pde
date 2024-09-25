public class Coin extends AnimatedSprite{
  public Coin(PImage image, float scale){
    super(image, scale);
    standNeutral= new PImage[2];
    standNeutral[0]= loadImage("gem.png");
    standNeutral[1]= loadImage("gem2.png");
    currentImages= standNeutral;
  }
  
  public void updateAnimation(){
  frame++;
  if(frame%25==0){
   selectDirection();
   selectCurrentImages();
   advanceToNextImage();
   
  }
 }
}
