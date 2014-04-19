/*

 The level class is for managing the games level. Basically we would populate this object
 with level information from an XML file. We would then use it to create and load the level in the 
 fisica world.
 
 Should also have a SaveCurrentLevel method
 
 Earch level should be stored in an XML file
 This level file will contain:
 
 background colour
 a list of pbody objects with paramaters - details like location, size, etc~
 key objects - their locations and which doors they unlock, and colours
 door objects
 "finish line" for the level
 Starting location for the player
 
 */

class Level {

  PVector size;
  ArrayList<FBox> static_objects;
  ArrayList<FBox> static_objects_walls;
  String levelFile;

  Level() {

    static_objects = new ArrayList<FBox>();
    static_objects_walls = new ArrayList<FBox>();
  }

  Level(String levelFile) {

    static_objects = new ArrayList<FBox>();
    static_objects_walls = new ArrayList<FBox>();
    this.levelFile = levelFile;
  }

  void loadLevelFromXML() {
    
  }

  void saveLevelToXML() {
    
  }
}

