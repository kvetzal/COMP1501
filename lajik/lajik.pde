import fisica.*;

//A couple states planned to be in use.
//We are going to have a change state method, that will run the start and exit state methods automatically.
int STATE_GAME = 1;
int STATE_LEVEL_EDITOR = 2;
int STATE_INTRO = 3;

//so, change this to 3 once intro state is done. 
//each state should be stored in a method and whenever this is changed, a state should be capable
//of completely pausing.
int current_state = 1;

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

void setup() {
  size(1024, 768);
  smooth();
  Fisica.init(this);

  ps = new ParticleSystem(100, 1, 8, 8, 1, 1);


  world = new FWorld();
  world.setGravity(0, 40);

  myLevel = new Level();


  world.setEdges(-1024, -768, 2048, 1536);

  //InitPlayerModel
  playerModel = new FBox(40, 40);

  //Setup playermodel
  playerModel.setBullet(true);
  playerModel.setNoStroke();
  playerModel.setFill(255, 255, 255);
  playerModel.setPosition(width/2, height/2);
  playerModel.setFriction(0.01);
  playerModel.setDensity(2.0);
  playerModel.setRestitution(0.0);

  //starter platform
  groundTest = new FBox(width, 50);
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

  myLevel.static_objects.add(groundTest);

  /*groundTest = new FBox(30, 500);
   groundTest.setFillColor(#303030);
   groundTest.setFriction(0.1);
   groundTest.setStatic(true);
   groundTest.setPosition(15, 993);
   
   myLevel.static_objects_walls.add(groundTest);*/

  //create the steps

  for (int i = 0;i < 4;i++) {
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
  }

  for (int i=0;i<myLevel.static_objects.size();i++) {
    world.add(myLevel.static_objects.get(i));
  }
  for (int i=0;i<myLevel.static_objects_walls.size();i++) {
    world.add(myLevel.static_objects_walls.get(i));
  }

  world.add(playerModel);


  //Fisica.setScale(1);

  rectMode(RADIUS);

  frameRate(realFrameRate);
}


boolean keyLeft;
boolean keyRight;
boolean keyUp;

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
}

//going to be where we start the level modder. It's going to be a debug option
void state_create_level() {
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
}

