/*

The level class is for managing the games level. Basically we would populate this object
with level information from an XML file. We would then use it to create and load the level in the 
fisica world.

Should also have a SaveCurrentLevel method

*/

class Level {

  PVector size;
  ArrayList<FBox> static_objects;
  ArrayList<FBox> static_objects_walls;

  Level() {

    static_objects = new ArrayList<FBox>();
    static_objects_walls = new ArrayList<FBox>();
  }
}
