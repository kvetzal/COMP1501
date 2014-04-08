class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float particle_spread=1;
  float particle_lifespan=255;
  int particle_volume = 1;
  float r=170;
  float g=170;
  float b=170;
  float startX;
  float startY;
  float endX;
  float endY;

  ParticleSystem(float lifespan, float spread, float sX, float sY, float eX, float eY, int volume) {
    //origin = location.get();
    particles = new ArrayList<Particle>();
    origin = new PVector();
    particle_spread = spread;
    particle_lifespan = lifespan;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
  }
  ParticleSystem(float lifespan, float spread, float sX, float sY, float eX, float eY) {
    //origin = location.get();
    particles = new ArrayList<Particle>();
    origin = new PVector();
    particle_volume = 1;
    particle_lifespan = lifespan;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
  }
  ParticleSystem(float lifespan, float spread, float sX, float sY, float eX, float eY, float r, float g, float b, int volume) {
    //origin = location.get();
    particles = new ArrayList<Particle>();
    origin = new PVector();
    particle_spread = spread;
    particle_volume = volume;
    particle_lifespan = lifespan;
    this.r = r;
    this.g = g;
    this.b = b;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
  }
  ParticleSystem(float lifespan, float spread, float sX, float sY, float eX, float eY, float r, float g, float b) {
    //origin = location.get();
    particles = new ArrayList<Particle>();
    origin = new PVector();
    this.r = r;
    this.g = g;
    this.b = b;
    particle_volume = 1;
    particle_lifespan = lifespan;
    startX = sX;
    startY = sY;
    endX = eX;
    endY = eY;
  }

  void setColor(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  void setOrigin(float x, float y) {

    origin.x = x;
    origin.y = y;
  }
  void run() {
    if (particle_volume > 1) {
      for (int i = 0;i<particle_volume;i++) {
        particles.add(new Particle(origin, particle_lifespan, particle_spread, startX, startY, endX, endY, r, g, b));
      }
    } 
    else {
      particles.add(new Particle(origin, particle_lifespan, particle_spread, startX, startY, endX, endY, r, g, b));
    }


    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

