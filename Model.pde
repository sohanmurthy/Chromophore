//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;
public static final int TUBE_ANGLE = 165;
public static final int X_SPACING = 26;
public static final int Y_SPACING = -3;
public static final int ROW_2_OFFSET_X = 3;
public static final int ROW_2_OFFSET_Y = 14/2;

public static final int ROW_3_OFFSET_X = 32;
public static final int ROW_3_OFFSET_Y = 11;


static class Model extends LXModel {

  Model() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {
      //angled tubes with an irregular offset pattern
      for (int i = 0; i < 1; i++) {
        addPoints(new TubeAngle(0, 0, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING, Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING*2, Y_SPACING*2, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING*3, Y_SPACING*3, TUBE_ANGLE));
        
        addPoints(new TubeAngle(ROW_2_OFFSET_X,               ROW_2_OFFSET_Y, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+X_SPACING,     ROW_2_OFFSET_Y+Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+(X_SPACING*2), ROW_2_OFFSET_Y+(Y_SPACING*2), TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+(X_SPACING*3), ROW_2_OFFSET_Y+(Y_SPACING*3), TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+(X_SPACING*4), ROW_2_OFFSET_Y+(Y_SPACING*4), TUBE_ANGLE));
        
        addPoints(new TubeAngle(ROW_3_OFFSET_X,               ROW_3_OFFSET_Y, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_3_OFFSET_X+X_SPACING,     ROW_3_OFFSET_Y+Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_3_OFFSET_X+(X_SPACING*2), ROW_3_OFFSET_Y+(Y_SPACING*2), TUBE_ANGLE));

      }
      
    }
  }
}


//Tubes that are oriented left-to-right at a specified angle (theta)
static class TubeAngle extends LXAbstractFixture {

  private TubeAngle(int xP, int yP, int theta) {
    for (int i = 0; i < TUBE_PIXELS; ++i) {
      addPoint(
        new LXPoint(xP+i*(PIXEL_SPACING*cos(radians(theta))), yP+i*(PIXEL_SPACING*sin(radians(theta))))
      );
    }
  }
  
}
