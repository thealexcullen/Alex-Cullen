public class Sprite{
PImage image;
float x,y,h,w;
float changeX, changeY;
   public Sprite(String fileName, float scale, float ecks, float why){
     image= loadImage(fileName);
     x= ecks;
     y= why;
     changeX= 0.0;
     changeY= 0.0;
     w= image.width*scale;
     h= image.height*scale;
   }
   
   public Sprite(String fileName, float scale){
     this(fileName, scale, 0, 0);
   }
   
   public Sprite(PImage img, float scale){
    image= img; 
    w= image.width*scale;
    h= image.height*scale;
    x= 0; 
    y= 0;
    changeX=0;
    changeY=0;
   }
   public void changeFile(String file){
    image= loadImage(file); 
   }
   
   public void display(){
     image(image, x, y, w ,h);
   }
   public void update(){
    x+= changeX;
    y+= changeY;
   }
   
   public float getLeft(){
     return x-(w/2);
   }
   
   public float getRight(){
     return x+(w/2);
   }
   
   public float getTop(){
     return y-(h/2);//used w instead of h
   }
   
   
   public float getBottom(){
     return y+(h/2);//used w instead of h
   }
   
  public void setLeft(float newLeft){
      x= newLeft+(w/2);
   }
   
   public void setRight(float newRight){
      x= newRight-(w/2);
   }
   
   public void setTop(float newTop){
      y= newTop+(h/2);
   }
   
   public void setBottom(float newBottom){
      y= newBottom-(h/2);
   }
}
