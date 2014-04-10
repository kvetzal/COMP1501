/*

import punktiert.math.Vec;
import punktiert.physics.*;

//world object
VPhysics physics;

Vec mouse;

//number of particles in the scene
int amount = 100;

public void setup() {
  size(800, 600);
  fill(255, 255);

  physics = new VPhysics();

  BWorldBox boxx = new BWorldBox(new Vec(), new Vec(width, height, 500));
  boxx.setWrapSpace(true);
  physics.addBehavior(boxx);

  for (int i = 0; i < amount; i++) {
    //val for arbitrary radius
    float rad = random(2, 20);
    //vector for position
    Vec pos = new Vec (random(rad, width-rad), random(rad, height-rad));
    //create particle (Vec pos, mass, radius)
    VParticle particle = new VParticle(pos, 1, rad);
    //add Collision Behavior
    particle.addBehavior(new BCollision());

    particle.addBehavior(new BWander(1, 1, 1));
    //add particle to world
    physics.addParticle(particle);
  }
  PFont font;
  //font = loadFont("LiberationSerif-Bold.ttf");
  font = createFont("SourceCodePro-Regular.ttf", 48);
  textFont(font);
  textSize(100);
  //textFont(font);
}

int state = 0;
int STATE_TITLE_SCREEN = 0;
int STATE_CREDITS = 1;


void state_title_screen() {

  //background(0,0,0,12);


  physics.update();

  for (VParticle p : physics.particles) {
    drawRectangle(p);
  }
  textSize(100);

  fill(12);
  text("läjik", (width/2)-(150)+5, (height/2)+5); 

  fill(225, 223, 222);
  text("läjik", (width/2)-(150), (height/2));  
  textSize(30);

  fill(12);
  text("Press Enter", (width/2)-(95)+3, (height*3/4)+3); 

  fill(225, 223, 222);
  text("Press Enter", (width/2)-(95), (height*3/4)); 

  //}
  fill(30, 12);
  rect(0, 0, width, height);
}

void state_credits() {

  //background(0,0,0,12);


  physics.update();

  for (VParticle p : physics.particles) {
    drawRectangle(p);
  }



  fill(12);
  text("By:", (width/2)-20+3, (height*1/8)+3); 

  fill(225, 223, 222);
  text("By:", (width/2)-20, (height*1/8));

  textSize(30);

  fill(12);
  text("Nicholas Hylands", (width/2)-(125)+3, (height*1/4)+3); 

  fill(225, 223, 222);
  text("Nicholas Hylands", (width/2)-(125), (height*1/4)); 

  fill(12);
  text("Katrina Vetzal", (width/2)-(105)+3, (height*2/4)+3); 

  fill(225, 223, 222);
  text("Katrina Vetzal", (width/2)-(105), (height*2/4)); 

  fill(12);
  text("Matthew McMurray", (width/2)-(125)+3, (height*3/4)+3); 

  fill(225, 223, 222);
  text("Matthew McMurray", (width/2)-(125), (height*3/4)); 

  //}
  fill(30, 12);
  rect(0, 0, width, height);
}

public void draw() {
  if (state == STATE_TITLE_SCREEN) {

    state_title_screen();
  } 
  else if (state == STATE_CREDITS) {

    state_credits();
  }
}

void keyPressed() {

  if (key == ENTER) {
    state = (state + 1) % 2;
  }
}


int y = 0;

void drawRectangle(VParticle p) {
  stroke(255, 0);

  fill(255, 150);
  float deform = p.getVelocity().mag();
  float rad = p.getRadius();
  deform = map(deform, 0, 1.5f, rad, 0);
  deform = max (rad *.2f, deform);

  float rotation = p.getVelocity().heading();    

  pushMatrix();
  translate(p.x, p.y);
  rotate(HALF_PI*.5f+rotation);
  beginShape();
  vertex(-rad, +rad);
  vertex(deform, deform);
  vertex(rad, -rad);
  vertex(-deform, -deform);
  endShape(CLOSE);
  popMatrix();
}
*/
