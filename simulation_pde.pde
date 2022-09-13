import java.util.ArrayList;

  PShape dragon;
  float random, move = 0.0, ballXPos = 300, ballYPos = 400;
  ArrayList<Float> lifeList = new ArrayList();
  ArrayList<Particle> firework = new ArrayList(); 
  ArrayList<Particle> particleList = new ArrayList();
  ArrayList<Particle> spawnParticles = new ArrayList();
  int gridX = 1200, gridY = 900;
  float[][] grid;
  Particle fireworkParticle;
  boolean fireworkflag, waterFlag;
  float t = 0.5;
  
  public void setup() {
    size(800, 800, P3D);
    grid = new float[gridX][gridY];
    dragon = loadShape("Dragon.obj");
    
    PVector fireworkPos = new PVector(600, 700, 10);
    PVector fireworkVel = new PVector(0,random(-10,-5),0);
    PVector fireworkCol = new PVector(random(255), random(255),random(255));
    fireworkParticle = new Particle(fireworkPos,fireworkVel,fireworkCol);
    
  }
  
  public void createFirework() {
    fireworkflag = false;
    boolean explodFlag = false;
    waterFlag = false;
    fireworkParticle.dead = false;
    if (!explodFlag){ //<>//
        moveFirework(fireworkParticle, fireworkflag,true);
        if(frameCount < 222) {
            fireworkParticle.renderParticle(waterFlag/*, explodFlag*/);
        }
        if (frameCount == 220) {
          fireworkflag = true;
          explodFlag = true;
          explosion(fireworkParticle.position);
        }
        for (int k=0; k<spawnParticles.size(); k++){
          moveFirework(spawnParticles.get(k), fireworkflag, explodFlag);
          renderFirework(spawnParticles.get(k), explodFlag);
          explodFlag = false;
        } 
    }
}
  public void renderFirework(Particle sp ,boolean explodFlag) {
    color col;
    col = color(random(255),random(255),random(255));
    noStroke();
    fill(sp.pColor.x, sp.pColor.y, sp.pColor.z, sp.life);
    ellipse(sp.position.x, sp.position.y, 10, 10);
    sp.life -= 5.0f;
    stroke(0, sp.life);
    noFill();
  }
  
  public void moveFirework(Particle sp, boolean fireworkflag, boolean explodFlag) { 
      if (fireworkflag == false){
          sp.gravity(0.04);
      } else {
        sp.gravity(0.02);
      }
      PVector acc = new PVector(0,0.04,0);
      acc.x = 0.5*sp.acceleration.x*t*t;
      acc.y = 0.5*sp.acceleration.y*t*t;
      acc.z = 0.5*sp.acceleration.z*t*t;
      
      PVector vel = new PVector(0,0,0);
      vel.x = sp.velocity.x*t;
      vel.y = sp.velocity.y*t;
      vel.z = sp.velocity.z*t;
    
      vel.add(acc);
     
      sp.position.add(vel);
  }
   

  public void explosion(PVector pos) {
    
    for (int i=0;i<100;i++){
      PVector spawnVel = PVector.random3D().mult(5);
      PVector spawnCol = new PVector(random(255), random(255), random(255));
      PVector rand = new PVector(random(pos.x-10,pos.x+10), random(pos.y-10,pos.y+10),random(pos.z-10,pos.z+10));
      Particle spawnP = new Particle(rand,spawnVel,spawnCol);
      spawnParticles.add(spawnP);
    }  
  }
  
  public void createParticles() {
      PVector c;
      for (int i=0; i<25;i++){   // create 25 particles in each frame
        PVector p = new PVector(300,60,5);
        PVector v = new PVector(random(-1,1),random(5,1),0);
        c = new PVector(0,0,225);
        Particle particle = new Particle(p,v,c);
        particleList.add(particle);
      }
      waterFlag = true;
      for (int i=0; i<particleList.size(); i++) {
        float distance = dist(particleList.get(i).position.x,particleList.get(i).position.y,ballXPos,ballYPos);
        if (distance > 37){
          particleList.get(i).moveParticles();
          particleList.get(i).renderParticle(waterFlag);          
        }
      }
  }

  void mouseDragged() {
    ballXPos = mouseX-0; 
    ballYPos = mouseY-0; 
  }
 
  public void draw(){
    background(204, 229, 255);
    stroke(0f);
    noFill();
            
    beginCamera();
    camera(300, 300, 700.0, // eyeX, eyeY, eyeZ
         300, 300, 1.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
    rotateX(-PI/24);
    translate(-200,-10,1);
    endCamera();
         
    beginShape();
    rotateY(radians(20));
    shape(dragon, 300, 100, 300, -50);  // Draw dragon
    endShape();
    
    pushMatrix();
    fill(255,0,0);
    ellipse(ballXPos, ballYPos, 50, 50);
    
    popMatrix();
    noFill();
 
    createFirework();
    createParticles();  // Create the Particles

    move += 0.1; // The following for loop is for the fly functionality
    float delta_y = move;
    for (int y=0;y< 299;y++){
      float delta_x = 0.0;
      for (int x=0;x<399;x++){
        grid[x][y] = map(noise(delta_x, delta_y), 0.0, 1.0, -50.0, 50.0);
        delta_x += 0.2;
      }
      delta_y += 0.2;
    }
    
    /* This Section of the code is for creating the ground as grid*/
    translate(width/2, height/2);
    rotateX(PI/3);
    translate(-gridX/2, -gridY/2);
    //sframeRate(30);
    noFill();
    for (int j=0;j< 399;j++){
      beginShape();
      for (int i=0;i<299;i++){
        stroke(52,101,0);        
        vertex(i*20, (j+1)*20, grid[i][j+1]);
      }
      endShape();
    }
   
  }
