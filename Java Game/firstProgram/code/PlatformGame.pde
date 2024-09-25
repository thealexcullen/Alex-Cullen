final static float moveSpeed= 5; //<>//
final static float gravity= 0.8;
final static float spriteScale= 50.0/18;
final static float spriteSize= 50.0;
final static float jumpSpeed= 14;
final static float rightMargin= 400;
final static float leftMargin= 60;
final static float verticalMargin= 40;
final static int neutralFacing= 0;
final static int rightFacing= 1;
final static int leftFacing= 2;
final static float WIDTH= spriteSize*16;
final static float HEIGHT= spriteSize*12;
final static float groundLevel= HEIGHT- spriteSize;
Player p; //<>//
Enemy enemy;
PImage snowGround, ice, snowMan, jewel, spike;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
ArrayList<Sprite> enemies;
float viewX= 0;
float viewY= 0;
int numCoins;
boolean gameOver;
void setup(){
  size(800,800);
  imageMode(CENTER);
  PImage guy= loadImage("standRight.png");
  p= new Player(guy,0.8);
  p.setBottom(groundLevel);
  p.changeX= 0;
  p.changeY= 0;
  platforms= new ArrayList<Sprite>();
  coins= new ArrayList<Sprite>();
  enemies= new ArrayList<Sprite>();
  gameOver= false;
  numCoins= 0;
  jewel= loadImage("gem.png");
  snowGround= loadImage("snowTile.png");
  ice= loadImage("iceHump.png");
  snowMan= loadImage("snowMan.png");
  spike= loadImage("enemyFloating1.png");
  createPlatforms("map.csv");
  
}

void draw(){
  
  background(90, 192, 230);
  scroll();

  displayAll();
  if(!gameOver)
    updateAll();
    collectCoins();
    checkDeath();
    

  
  
}
void updateAll(){
  resolvePlatformCollision(p, platforms);
  p.update();
  p.updateAnimation();

  for(Sprite c: coins){
   ((AnimatedSprite)c).updateAnimation();
  }
  
  for(Sprite e: enemies){
   e.update();
   ((AnimatedSprite)e  ).updateAnimation();
  }
}

void displayAll(){
 for(Sprite c: coins){
   c.display();
  } 
  for(Sprite e: enemies){
   e.display();
  } 
  p.display();
  
  for(Sprite s: platforms){
    s.display();
  }
  fill(0,0,0);
  textSize(32);
  text("Gems: "+ numCoins, viewX+50, viewY+50);
  text("Lives: "+ p.lives, viewX+50, viewY+100);
  
  if(gameOver){
   fill(0,0,0);
   textSize(32);
   text("GAME OVER!", viewX+ width/2-100, viewY+ height/2);
   if(p.lives<=0){
    text("YOU LOSE!", viewX+ width/2-100, viewY+ height/2+50); 
   }else{
    text("YOU WIN!", viewX+ width/2-100, viewY+ height/2+50); 
   }
   text("Press SPACE to restart!", viewX+ width/2-100, viewY+ height/2+100);
  }
}

void checkDeath(){
 boolean collideEnemy= false;
  for(Sprite e: enemies){
   collideEnemy= checkCollision(p, e);
   if(collideEnemy)
     break;
 }
 
 boolean fallOffCliff= p.getBottom()> groundLevel;
 if(collideEnemy || fallOffCliff){
   p.lives--;
   if(p.lives==0){
     gameOver= true;
   }else{
       p.x= 100;
       p.setBottom(platforms.get(0).getTop());
     }
   }
}
void collectCoins(){
  ArrayList<Sprite> coinL= checkCollisionList(p, coins);
  if(coinL.size()>0){
    for(Sprite l:coinL){
      numCoins++;
      coins.remove(l);
      
  }
  if(coins.size()==0){
   gameOver=true; 
  }
}
}
void scroll(){
 float rightBound= viewX+ width-rightMargin;
 if(p.getRight()>rightBound){
  viewX+= p.getRight()- rightBound; 
 }
 
 float leftBound= viewX+leftMargin;
 if(p.getLeft()<leftBound){
  viewX-= leftBound-p.getLeft(); 
 }
 
 float bottomBound= viewY+height-verticalMargin;
 if(p.getBottom()>bottomBound){
  viewY+= p.getBottom()-bottomBound; 
 }
 
 float topBound= viewY+verticalMargin;
 if(p.getTop()<topBound){
  viewY-= p.getTop()+topBound; 
 }
 
   
  translate(-viewX, -viewY);
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
 s.y+= 5;
 ArrayList<Sprite> colList= checkCollisionList(s, walls);
 s.y-=5;
 if(colList.size()>0){
   return true;
 }
 return false;
}
void createPlatforms(String fileName){
 String[] lines= loadStrings(fileName);
 for(int row= 0; row<lines.length; row++){
  String values[]= split(lines[row], ",");
  for(int col= 0; col<values.length; col++){
   if(values[col].equals("1")){
    Sprite s= new Sprite(snowGround, spriteScale);
    s.x= spriteSize/2+col*spriteSize;
    s.y= spriteSize/2+row*spriteSize;
    platforms.add(s);
   }else if(values[col].equals("2")){
    Sprite s= new Sprite(ice, spriteScale);
    s.x= spriteSize/2+col*spriteSize;
    s.y= spriteSize/2+row*spriteSize;
    platforms.add(s);
   }else if(values[col].equals("3")){
    Sprite s= new Sprite(snowMan, spriteScale);
    s.x= spriteSize/2+col*spriteSize;
    s.y= spriteSize/2+row*spriteSize;
    platforms.add(s);
   }else if(values[col].equals("4")){
    Coin c= new Coin(jewel, 120/50);
    c.x= spriteSize/2+col*spriteSize;
    c.y= spriteSize/2+row*spriteSize;
    coins.add(c);
   }else if(values[col].equals("5")){
    float bLeft= col*spriteSize;
    float bRight= bLeft+4*spriteSize;
    enemy= new Enemy(spike, 50.0/55, bLeft, bRight);
    enemy.x= spriteSize/2+col*spriteSize;
    enemy.y= spriteSize/2+row*spriteSize;
    enemies.add(enemy);
   }
  }
 }
}
void keyPressed(){
  if(key=='d'){
    p.changeX= moveSpeed; 
  } else if(key== 'a'){
    p.changeX= -moveSpeed; 
  }else if(key== 's'){
   p.changeY= moveSpeed; 
  }else if(key== ' ' && isOnPlatforms(p,platforms)){
   p.changeY= -jumpSpeed;
  }else if(gameOver&& key== ' '){
    setup();
  }
}
void keyReleased(){
  if(key=='d'){
   p.changeX= 0; 
  } else if(key== 'a'){ 
   p.changeX= 0; 
  }else if(key== 's'){
   p.changeY= 0; 
  }else if(key== 'w'){
   p.changeY= 0; 
  }
}

Boolean checkCollision(Sprite s1, Sprite s2){
 boolean jame= true;
  if(s1.getLeft()>=s2.getRight()){
      jame= false;
 }else if(s1.getRight()<=s2.getLeft()){
      jame= false;
 }else if(s1.getBottom()<=s2.getTop()){
      jame= false;  
 }else if(s1.getTop()>=s2.getBottom()){
      jame= false;
 }
      return jame;
}

public ArrayList<Sprite> checkCollisionList(Sprite jame, ArrayList<Sprite> list){
  ArrayList<Sprite> collisionList= new ArrayList<Sprite>();
    for(Sprite i: list){
      if(checkCollision(jame, i)){
        collisionList.add(i);
      }
    }
    return collisionList;
}

public void resolvePlatformCollision(Sprite jame, ArrayList<Sprite> things){
   jame.changeY+= gravity;
   jame.y+= jame.changeY;

  
   ArrayList<Sprite> colList= checkCollisionList(jame, things);

   if(colList.size()> 0){
     Sprite collided= colList.get(0);
   
     if(jame.changeY> 0){
       jame.setBottom(collided.getTop());
       
     }else{
       jame.setTop(collided.getBottom());
     }
     jame.changeY= 0;
   }
 
   jame.x+= jame.changeX;
   
    colList= checkCollisionList(jame, things);
   if(colList.size()> 0){
     Sprite collided= colList.get(0);
   
     if(jame.changeX < 0){
         jame.setLeft(collided.getRight());
       
     }else{
       jame.setRight(collided.getLeft());
     }
     jame.changeX= 0;
  }
}
