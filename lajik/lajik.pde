import fisica.*;
//intro screen libraries
import punktiert.math.Vec;
import punktiert.physics.*;
//for the audio manager
import ddf.minim.*;

//A couple states planned to be in use.
//We are going to have a change state method, that will run the start and exit state methods automatically.
final int STATE_INTRO = 0;
final int STATE_GAME = 1;
final int STATE_LEVEL_EDITOR = 2;
final int STATE_CREDITS = 3;

//so, change this to 3 once intro state is done. 
//each state should be stored in a method and whenever this is changed, a state should be capable
//of completely pausing.
int current_state = 0;

float realFrameRate = 400;
//float frameCount;
FBox playerModel;
FBox groundTest;

PVector global_zero;
PVector camera_location;


FWorld world;

float jumpForce = -70;
float jumpVelocity = -210;
float moveSpeed = 250;

Level myLevel;

ParticleSystem ps;

AudioManager audioManager;

boolean debug_level_maker;

void setup() {
  size(1024, 768);
  smooth();

  introScreenSetup();

  Fisica.init(this);

  frameRate(realFrameRate);
  
  Minim minim = new Minim(this);
  audioManager = new AudioManager(minim);
}

boolean keyLeft;
boolean keyRight;
boolean keyUp;
boolean keyDown;

boolean keyPause;
boolean keyToggleLevelModder;

boolean keyEnter;

void keyPressed() {
  if (key == 'W' | key == 'w') {
    keyUp = true;
  }
  if (key == 'A' | key == 'a') {
    keyLeft = true;
  }
  if (key == 'D' | key == 'd') {
    keyRight = true;
  }
  if (keyCode == ENTER) {
    keyEnter = true;
  }
}

void keyReleased() {
  if (key == 'W' | key == 'w') {
    keyUp = false;
  }
  if (key == 'A' | key == 'a') {
    keyLeft = false;
  }
  if (key == 'D' | key == 'd') {
    keyRight = false;
  }
  if (keyCode == ENTER) {
    keyEnter = false;
  }
}

//going to be where we start the level modder. It's going to be a debug option
void state_level_maker() {
}

void state_game_exit() {

  playerModel.removeFromWorld();
}

boolean canGoUp;

void state_game() {
  ps.particle_volume = 1;
  ps.particle_spread = 1;

  if (abs(playerModel.getAngularVelocity()*2) > 0.9) {
    ps.particle_spread = abs(playerModel.getAngularVelocity()*2);
  }
  if (keyLeft) {
    playerModel.addForce(-moveSpeed, 0);
    ps.particle_volume = 2;
  }

  if (keyRight) {
    playerModel.addForce(moveSpeed, 0);
    ps.particle_volume = 2;
  }
  
  if (keyToggleLevelModder){
    
    
  }

  if (keyUp) {
    canGoUp = false;
    playerModel.addTorque(playerModel.getVelocityX()/10);
    if (playerModel.getTouching().size() > 0) {
      for (int i = 0; i < myLevel.static_objects.size(); i++) {
        if (playerModel.isTouchingBody(myLevel.static_objects.get(i))) {

          canGoUp = true;
        }
      }
      if (canGoUp) {
        playerModel.setVelocity(playerModel.getVelocityX(), jumpVelocity);
      }
    }
    ps.particle_volume = 2;
  }

  world.step(0.02);

  //render everything
  if (frameCount % (6) == 0) {
    ps.setColor(120 + random(-5, 5), 120 + random(-5, 5), 120 + random(-5, 5));
    ps.setOrigin(playerModel.getX(), playerModel.getY());
    background(12);
    translate(-(playerModel.getX()-width/2), -(playerModel.getY()-height/2));

    ps.run();
    world.draw();
    translate((playerModel.getX()-width/2), (playerModel.getY()-height/2));
  }
}

//PVector oldMid;
PVector newMid = new PVector();
PVector worldOffset = new PVector();

float half_width = width/2;
float half_height = height/2;

void draw() {
  if (current_state == STATE_GAME) {
    state_game();
  }
  else if (current_state == STATE_INTRO) {
    introScreenDraw();
  }
  else if (current_state == STATE_CREDITS) {
    creditsDraw();
  }
}

//Intro Screen variables
VPhysics physics;
Vec mouse;
int amount = 100;

void introScreenSetup() {
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
}

void gameSetup() {
  ps = new ParticleSystem(100, 1, 8, 8, 1, 1);

  world = new FWorld();
  world.setGravity(0, 40);

  myLevel = new Level();

  float units = width/30;

  world.setEdges(-width, -height, units*159, units*60);

  //InitPlayerModel
  playerModel = new FBox(units, units);

  //Setup playermodel
  playerModel.setBullet(true);
  playerModel.setNoStroke();
  playerModel.setFill(255, 255, 255);
  playerModel.setPosition(width/2, height/2);
  playerModel.setFriction(0.01);
  playerModel.setDensity(2.0);
  playerModel.setRestitution(0.0);

  createGround();

  //starter platform
  /*groundTest = new FBox(width, 50);
  groundTest.setFillColor(#303030);
  groundTest.setFriction(0.1);
  groundTest.setStatic(true);
  groundTest.setPosition(width/2, height-50);

  myLevel.static_objects.add(groundTest);

  //starter platform bottom and sides.
  groundTest = new FBox(width+2, 50+1);
  groundTest.setFriction(0.1);
  groundTest.setStatic(true);
  groundTest.setPosition(width/2, height-50+2);
  groundTest.setFill(0, 0, 0, 0);
  groundTest.setNoStroke();
  myLevel.static_objects_walls.add(groundTest);

  groundTest = new FBox(3072, 25);
  groundTest.setFillColor(#303030);
  groundTest.setFriction(0.1);
  groundTest.setStatic(true);
  groundTest.setPosition(512, 1501);

  myLevel.static_objects.add(groundTest);*/

  /*groundTest = new FBox(30, 500);
   groundTest.setFillColor(#303030);
   groundTest.setFriction(0.1);
   groundTest.setStatic(true);
   groundTest.setPosition(15, 993);
   
   myLevel.static_objects_walls.add(groundTest);*/

  //create the steps

  /*for (int i = 0;i < 4;i++) {
    groundTest = new FBox(100, 10);
    groundTest.setFillColor(#303030);
    groundTest.setFriction(0.1);
    groundTest.setStatic(true);
    groundTest.setPosition(-150-205*i, 900+185*i);

    myLevel.static_objects.add(groundTest);

    groundTest = new FBox(104, 11);
    groundTest.setFriction(0.1);
    groundTest.setStatic(true);
    groundTest.setPosition(-150-205*i, 900+185*i+2);
    //groundTest.setStroke(255,0,0);
    groundTest.setFill(0, 0, 0, 0);
    groundTest.setNoStroke();
    myLevel.static_objects_walls.add(groundTest);
  }*/

  for (int i=0;i<myLevel.static_objects.size();i++) {
    world.add(myLevel.static_objects.get(i));
  }
  for (int i=0;i<myLevel.static_objects_walls.size();i++) {
    world.add(myLevel.static_objects_walls.get(i));
  }

  world.add(playerModel);


  //Fisica.setScale(1);

  rectMode(RADIUS);
}

void introScreenDraw() {
  if (keyEnter) {
    current_state = STATE_CREDITS;
    introScreenSetup();
  }
  else {
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

    fill(30, 12);
    rect(0, 0, width, height);
  }
}

void creditsDraw() {
  if (keyEnter) {
    current_state = STATE_GAME;
    gameSetup();
  }
  else {
    fill(255, 255);

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
    text("Nicholas Hylands", (width/2)-(125)+3, (height*1/5)+3); 

    fill(225, 223, 222);
    text("Nicholas Hylands", (width/2)-(125), (height*1/5)); 

    fill(12);
    text("Katrina Vetzal", (width/2)-(105)+3, (height*2/5)+3); 

    fill(225, 223, 222);
    text("Katrina Vetzal", (width/2)-(105), (height*2/5)); 

    fill(12);
    text("Matthew McMurray", (width/2)-(125)+3, (height*3/5)+3); 

    fill(225, 223, 222);
    text("Matthew McMurray", (width/2)-(125), (height*3/5)); 

    fill(12);
    text("Press Enter", (width/2)-(95)+3, (height*4/5)+3); 

    fill(225, 223, 222);
    text("Press Enter", (width/2)-(95), (height*4/5)); 

    fill(30, 12);
    rect(0, 0, width, height);
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

void createGround() {
  float units = width/30;
  FBox oldBox;
  
  float boxWidth = units*30;
  float boxHeight = units*60;
  float boxX = 0;
  float boxY = (boxHeight/2)+playerModel.getHeight();
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*28;
  boxHeight = units/8;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*16);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()+(units*3);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()-(units*3);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()+(units*3);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth -= (units*18)-(units/8);
  boxX = oldBox.getX()-(oldBox.getWidth()/2)+(boxWidth/2)-(units*3);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units/8;
  boxHeight = (units*24);
  boxX = oldBox.getX()-(oldBox.getWidth()/2)+(boxWidth/2);
  boxY = oldBox.getY()-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units/8;
  boxHeight = (units*7);
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*5);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*124;
  boxHeight = units/8;
  boxX = oldBox.getX()-(oldBox.getWidth()/2)+(boxWidth/2)-(units*21);
  boxY = oldBox.getY()+(oldBox.getHeight()/2)+(units*39)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*5;
  boxHeight = boxWidth;
  boxX = oldBox.getX()-(oldBox.getWidth()/2)+(boxWidth/2)+(units*21)+(units/8);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxHeight *= 2;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*8);
  boxY = oldBox.getY()+(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxHeight /= 2;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2);
  boxY = oldBox.getY()+(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxHeight = (units*39);
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*3);
  boxY = oldBox.getY()+(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxHeight -= units*6;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2);
  boxY = oldBox.getY()+(oldBox.getHeight()/2)-(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*3;
  boxHeight = boxWidth;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*14);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*14);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*14);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxHeight = units/8;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)+(boxWidth/2)+(units*14);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*10;
  boxHeight = units*18;
  boxX = oldBox.getX()+(oldBox.getWidth()/2)-(boxWidth/2);
  boxY = oldBox.getY()+(units*39)+(units/8);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*3;
  boxHeight = units/8;
  boxX = oldBox.getX()-(oldBox.getWidth()/2)-(boxWidth/2)-(units*16);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()-(oldBox.getWidth()/2)-(boxWidth/2)-(units*16);
  boxY = oldBox.getY()+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxX = oldBox.getX()-(oldBox.getWidth()/2)-(boxWidth/2)-(units*12);
  boxY = oldBox.getY()-(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*5;
  boxHeight = units*18;
  boxX = oldBox.getX()-(oldBox.getWidth()/2)-(boxWidth/2)-(units*12);
  boxY = oldBox.getY()-(oldBox.getHeight()/2)+(boxHeight/2)+(units*6);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
  
  boxWidth = units*159;
  boxHeight = units/8;
  boxX = oldBox.getX()-(oldBox.getWidth()/2)-(units*30)+(boxWidth/2);
  boxY = oldBox.getY()+(oldBox.getHeight()/2);
  oldBox = makeBox(boxWidth, boxHeight, boxX, boxY);
}

FBox makeBox(float boxWidth, float boxHeight, float boxX, float boxY) {
  FBox box = new FBox(boxWidth, boxHeight);
  box.setFillColor(color(150, 150, 150));
  box.setFriction(0.1);
  box.setStatic(true);
  box.setPosition(boxX, boxY);
  myLevel.static_objects.add(box);
  FBox wall = new FBox(box.getWidth()+4, box.getHeight()+1);
  wall.setFriction(0.1);
  wall.setStatic(true);
  wall.setPosition(box.getX()+1, box.getY()+1);
  wall.setFill(0, 0, 0, 0);
  wall.setNoStroke();
  myLevel.static_objects_walls.add(wall);
  return box;
}
