//Defines the model with a few parameters for tube size/pixel density and orientation
// 0.65625 inches between pixels = 60 LEDs per meter
// 1.325 inches between pixels = 30 LEDs per meter

public static final int TUBE_PIXELS = 64;
public static final float PIXEL_SPACING = 0.65625;
public static final int TUBE_ANGLE = 173;
public static final int X_SPACING = 27;
public static final int Y_SPACING = 1;
public static final int ROW_2_OFFSET_X = 0;
public static final int ROW_2_OFFSET_Y = 17/2;

public static final int ROW_3_OFFSET_X = 27;
public static final int ROW_3_OFFSET_Y = 17;


static class Model extends LXModel {

  Model() {
    super(new Fixture());
  }

  private static class Fixture extends LXAbstractFixture {

    Fixture() {

        //first row
        addPoints(new TubeAngle(0, 0, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING, Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING*2, Y_SPACING*2, TUBE_ANGLE));
        addPoints(new TubeAngle(X_SPACING*3, Y_SPACING*3, TUBE_ANGLE));

        ////second row
        addPoints(new TubeAngle(ROW_2_OFFSET_X,               ROW_2_OFFSET_Y, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+X_SPACING,     ROW_2_OFFSET_Y+Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+(X_SPACING*2), ROW_2_OFFSET_Y+(Y_SPACING*2), TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_2_OFFSET_X+(X_SPACING*3), ROW_2_OFFSET_Y+(Y_SPACING*3), TUBE_ANGLE));
        addPoints(new TubeAngleRev(ROW_2_OFFSET_X+(X_SPACING*4), ROW_2_OFFSET_Y+(Y_SPACING*4), TUBE_ANGLE)); //reverse tube for easier wire routing

        //third row
        addPoints(new TubeAngle(ROW_3_OFFSET_X,               ROW_3_OFFSET_Y, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_3_OFFSET_X+X_SPACING,     ROW_3_OFFSET_Y+Y_SPACING, TUBE_ANGLE));
        addPoints(new TubeAngle(ROW_3_OFFSET_X+(X_SPACING*2), ROW_3_OFFSET_Y+(Y_SPACING*2), TUBE_ANGLE));

    }
  }
}


//Tubes that are oriented at a specified angle (theta)
static class TubeAngle extends LXAbstractFixture {

  private TubeAngle(int xP, int yP, int theta) {
    for (int i = 0; i < TUBE_PIXELS; ++i) {
      addPoint(
        new LXPoint(xP+i*(PIXEL_SPACING*cos(radians(theta))), yP+i*(PIXEL_SPACING*sin(radians(theta))))
      );
    }
  }

}

//Tubes that are oriented at a specified angle (theta), but with pixels in reverse order 
static class TubeAngleRev extends LXAbstractFixture {

  private TubeAngleRev(int xP, int yP, int theta) {
    for (int i = TUBE_PIXELS-1; i >= 0; --i) {
      addPoint(
        new LXPoint(xP+i*(PIXEL_SPACING*cos(radians(theta))), yP+i*(PIXEL_SPACING*sin(radians(theta))))
      );
    }
  }

}
