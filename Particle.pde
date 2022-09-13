import java.util.ArrayList;

import processing.core.PVector;

public class Particle {
  PVector position;
  PVector velocity ;
  PVector pColor;
  Float life;
  PVector acceleration = new PVector(0,0.01,0);
  boolean dead;
  
  public Particle() {}
  
  public Particle(PVector pos, PVector vel, PVector col) {
    this.position = pos;
    this.velocity = vel;
    this.pColor = col;
    this.life = 255f;
  }
  
  public void moveParticles() {    
    (this.position).add(this.velocity);
    if (this.position.y > 500) {
      this.velocity.y *= 1; //bounce factor
      this.life -= 2.0f;
    }      
  }
 
 public void renderParticle(boolean flag) {
    color col;
    if (flag == false){
      col = color(0,0,0);
    } else {
      col = color(65,105,225);
    }
    stroke(col, this.life);
    fill(this.pColor.x, this.pColor.y, this.pColor.z, this.life);
    ellipse(this.position.x, this.position.y, 16, 16);
  }

  public void gravity(float g){
    this.acceleration.y += g;
  }

}
