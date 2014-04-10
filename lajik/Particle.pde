class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;// this is the counter, as it was originally without the deathcounter float
  float deathCounter;//for keeping track of the originallifespan
  float r;
  float g;
  float b;
  float rEnd;
  float gEnd;
  float bEnd;
  private float rIncrement;
  private float gIncrement;
  private float bIncrement;
  boolean changeColor;
  float startX;
  float startY;
  float endX;
  float endY;
  float incrementX;
  float incrementY;

  Particle(PVector l, float life, float spread, float sX, float sY, float eX, float eY, float r, float b, float g) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-spread, spread), random(-spread, spread));
    location = l.get();
    lifespan = life;
    deathCounter = life;
    this.r = r;
    this.g = g;
    this.b = b;
    changeColor = false;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;

    incrementX = (startX-endX)/lifespan;
    incrementY = (startY-endY)/lifespan;
  }
  Particle(PVector l, float life, float spread, float sX, float sY, float eX, float eY) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-spread, spread), random(-spread, spread));
    location = l.get();
    lifespan = life;
    deathCounter = life;
    this.r = r;
    this.g = g;
    this.b = b;
    changeColor = false;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
    incrementX = (startX-endX)/lifespan;
    incrementY = (startY-endY)/lifespan;
  }
  Particle(PVector l, float life, float spread, float sX, float sY, float eX, float eY, float r, float b, float g, float rEnd, float gEnd, float bEnd) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-spread, spread), random(-spread, spread));
    location = l.get();
    lifespan = life;
    deathCounter = life;
    this.r = r;
    this.g = g;
    this.b = b;
    this.rEnd = rEnd;
    this.gEnd = gEnd;
    this.bEnd = bEnd;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
    incrementX = (startX-endX)/lifespan;
    incrementY = (startY-endY)/lifespan;

    rIncrement = (r-rEnd)/life;
    gIncrement = (g-gEnd)/life;
    bIncrement = (b-bEnd)/life;

    changeColor = true;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    if (changeColor) {

      r -= rIncrement;
      g -= gIncrement;
      b -= bIncrement;
    }
    startX -= incrementX;
    startY -= incrementY;
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(r, g, b, (255.0*(lifespan/deathCounter)));
    fill(r, g, b, (255.0*(lifespan/deathCounter)));
    //ellipse(location.x,location.y,8,8);
    rect(location.x, location.y, startX, startY);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

