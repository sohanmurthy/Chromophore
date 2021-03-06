
/******************
Spirals
*******************/

class Spirals extends LXPattern {
  class Wave extends LXLayer {
    
    final private SinLFO rate1 = new SinLFO(200000*2, 290000*2, 17000);
    final private SinLFO off1 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate1);
    final private SinLFO wth1 = new SinLFO(7, 12, 30000);

    final private SinLFO rate2 = new SinLFO(228000*1.6, 310000*1.6, 22000);
    final private SinLFO off2 = new SinLFO(-4*TWO_PI, 4*TWO_PI, rate2);
    final private SinLFO wth2 = new SinLFO(15, 20, 44000);

    final private SinLFO rate3 = new SinLFO(160000, 289000, 14000);
    final private SinLFO off3 = new SinLFO(-2*TWO_PI, 2*TWO_PI, rate3);
    final private SinLFO wth3 = new SinLFO(12, 140, 40000);

    final private float hOffset;
    
    Wave(LX lx, float o) {
      super(lx);
      hOffset = o;
      addModulator(rate1.randomBasis()).start();
      addModulator(rate2.randomBasis()).start();
      addModulator(rate3.randomBasis()).start();
      addModulator(off1.randomBasis()).start();
      addModulator(off2.randomBasis()).start();
      addModulator(off3.randomBasis()).start();
      addModulator(wth1.randomBasis()).start();
      addModulator(wth2.randomBasis()).start();
      addModulator(wth3.randomBasis()).start();
    }

    public void run(double deltaMs) {
      for (LXPoint p : model.points) {
        
        float vy1 = model.yRange/4 * sin(off1.getValuef() + (p.x - model.cx) / wth1.getValuef());
        float vy2 = model.yRange/4 * sin(off2.getValuef() + (p.x - model.cx) / wth2.getValuef());
        float vy = model.ay + vy1 + vy2;
        
        float thickness = 4 + 2 * sin(off3.getValuef() + (p.x - model.cx) / wth3.getValuef());
        float ts = thickness/1.2;

        blendColor(p.index, LXColor.hsb(
        (lx.getBaseHuef() + hOffset + (p.x / model.xRange) * 160) % 360,
        min(65, (100/ts)*abs(p.y - vy)), 
        max(0, 40 - (40/thickness)*abs(p.y - vy))
        ), LXColor.Blend.ADD);
      }
    }
   
  }

  Spirals(LX lx) {
    super(lx);
    for (int i = 0; i < 6; ++i) {
      addLayer(new Wave(lx, i*6));
    }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(9.67*MINUTES);
  }
}





/******************
Color Swatches
*******************/

class ColorSwatches extends LXPattern{


  class Swatch extends LXLayer {

    private final SinLFO sync = new SinLFO(8*SECONDS, 14*SECONDS, 39*SECONDS);
    private final SinLFO bright = new SinLFO(-80,100, sync);
    private final SinLFO sat = new SinLFO(35,55, sync);
    private final TriangleLFO hueValue = new TriangleLFO(0, 44, sync);

    private int sPixel;
    private int fPixel;
    private float hOffset;

    Swatch(LX lx, int s, int f, float o){
      super(lx);
      sPixel = s;
      fPixel = f;
      hOffset = o;
      addModulator(sync.randomBasis()).start();
      addModulator(bright.randomBasis()).start();
      addModulator(sat.randomBasis()).start();
      addModulator(hueValue.randomBasis()).start();
    }

    public void run(double deltaMs) {
      float s = sat.getValuef();
      float b = constrain(bright.getValuef(), 0, 100);

      for(int i = sPixel; i < fPixel; i++){
        blendColor(i, LXColor.hsb(
          lx.getBaseHuef() + hueValue.getValuef() + hOffset,
          //lx.getBaseHuef() + hOffset,
          s,
          b
          ), LXColor.Blend.LIGHTEST);
        }
    }

  }

  ColorSwatches(LX lx, int num_sec){
   super(lx);
   //size of each swatch in pixels
    final int section = num_sec;
   for(int s = 0; s <= model.size-section; s+=section){
     if((s+section) % (section*2) == 0){
     addLayer(new Swatch(lx, s, s+section, 28));
     }else{
       addLayer(new Swatch(lx, s, s+section, 0));
     }
   }
  }

  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(3.37*MINUTES);
  }

}


/******************
Salmon
*******************/


class Salmon extends LXPattern {
  
  final float size = 6;
  final float vLow = 8;
  final float vHigh = 20;
  final int bright = 16;
  final int num = 3;
  
   Salmon(LX lx) {
    super(lx);
    for (int i = 0; i < num; ++i) {
      addLayer(new Fish(lx));
      addLayer(new RightFish(lx));
      lx.cycleBaseHue(12.33*MINUTES);
      
    }
  }
  
  public void run(double deltaMs) {
    LXColor.scaleBrightness(colors, max(0, (float) (1 - deltaMs / 100.f)), null);
  }
  
  
  
  class Fish extends LXLayer {
    
    private final Accelerator xPos = new Accelerator(0, 0, 0);
    private final Accelerator yPos = new Accelerator(0, 0, 0);
     
    Fish(LX lx) {
      super(lx);
      addModulator(xPos).start();
      addModulator(yPos).start();
      
      xPos.setValue(random(model.xMin, model.cx));
      xPos.setVelocity(random(vLow, vHigh));
      yPos.setValue(random(model.yMin-5, model.yMax+5));
      yPos.setVelocity(random(0,0));
      
    }
    
    private void init_touch() {

      xPos.setValue(random(model.xMin-3, model.xMin));
      xPos.setVelocity(random(vLow, vHigh));
      yPos.setValue(random(model.yMin, model.yMax));
      yPos.setVelocity(random(-5,5));

    }
    
    private void init_fish() {
      
       for (LXPoint p : model.points) {
          float b = bright - (bright / size)*dist(p.x/4, p.y, xPos.getValuef(), yPos.getValuef());
          float s = b/3;
        if (b > 0) {
          blendColor(p.index, LXColor.hsb(
            (lx.getBaseHuef() + (p.y / model.yRange) * 120) % 360,
            min(65, (100/s)*abs(p.y - yPos.getValuef())), 
            b), LXColor.Blend.ADD);
          }
        } 
      
      }

      public void run(double deltaMs) {
        init_fish();
      
      if (xPos.getValue() > model.cx) {
        init_touch();
      }

    }
    
  }
  
  
  class RightFish extends LXLayer {
    
    private final Accelerator xPos = new Accelerator(0, 0, 0);
    private final Accelerator yPos = new Accelerator(0, 0, 0);
     
    RightFish(LX lx) {
      super(lx);
      addModulator(xPos).start();
      addModulator(yPos).start();
      
      xPos.setValue(random(model.cx, model.xMax));
      xPos.setVelocity(random(-vHigh, -vLow));
      yPos.setValue(random(model.yMin-5, model.yMax+5));
      yPos.setVelocity(random(-5,5));
      
    }
    
    private void init_touch() {

      xPos.setValue(random(model.cx, model.cx+3));
      xPos.setVelocity(random(-vHigh, -vLow));
      yPos.setValue(random(model.yMin, model.yMax));
      yPos.setVelocity(random(0,0));

    }
    
    private void init_fish() {
      
       for (LXPoint p : model.points) {
          float b = bright - (bright / size)*dist(p.x/4, p.y, xPos.getValuef(), yPos.getValuef());
          float s = b/3;
        if (b > 0) {
          blendColor(p.index, LXColor.hsb(
            (lx.getBaseHuef() + (p.y / model.yRange) * 90) % 360,
            min(65, (100/s)*abs(p.y - yPos.getValuef())), 
            b), LXColor.Blend.ADD);
          }
        } 
      
      }

      public void run(double deltaMs) {
        init_fish();
      
      if (xPos.getValue() < model.xMin) {
        init_touch();
      }

    }
    
  }
    
}

/**********************
Jellyfish
**********************/


class Jellyfish extends LXPattern {
  Jellyfish(LX lx) {
    super(lx);
    for (int i = 0; i < 8; ++i) {
      addLayer(new Jelly(lx, i*7.625));
    }
  }
  
  public void run(double deltaMs) {
    setColors(#000000);
    lx.cycleBaseHue(6.33*MINUTES);
  }
  
  class Jelly extends LXLayer {
    
    private SinLFO xp = new SinLFO(random(19000*5, 28000*5), random(32000*5, 43000*5), random(31000, 53000));
    private SinLFO yp = new SinLFO(random(19000, 28000), random(32000, 43000), random(31000, 53000));
    private SinLFO x = new SinLFO(model.xMin, model.xMax, xp);
    private SinLFO y = new SinLFO(model.yMin, model.yMax, yp);
    private SinLFO r = new SinLFO(2, random(7, 9), random(2500, 3500));
    final SinLFO breath;
    private float hOffset;
    
    //noise saturation
    private float accum = 0;
    final float spd = 0.5;
    final float range = 100;
    final float scale = 0.2;
    
    Jelly(LX lx, float o) {
      super(lx);
      startModulator(xp.randomBasis());
      startModulator(yp.randomBasis());
      startModulator(x.randomBasis());
      startModulator(y.randomBasis());
      startModulator(r.randomBasis());
      startModulator(breath = new SinLFO(0, startModulator(new SinLFO(0, 3, random(9000, 17000))), random(5000, 9000)));
      
      hOffset = o;
    }
    
    public void run(double deltaMs) {
      float xf = x.getValuef();
      float yf = y.getValuef();
      float rf = r.getValuef();
      float bf = breath.getValuef();
      
      float falloff = 22;
      
      accum += deltaMs/1000. * spd;
      float sv = scale;
      
      for (LXPoint p : model.points) {
        float b = 100 - falloff*abs(dist(p.x, p.y, xf, yf) - (rf + bf));
        float s = constrain(50 + range*(-1 + 2*noise(sv*p.x, sv*p.y, accum)), 0, 100);
        if (b > 0) {
            blendColor(p.index,
                       LXColor.hsb(
                                   lx.getBaseHuef() + hOffset,
                                   s, //complex noise pattern
                                   //80-(rf*6), //simple saturation scaled to radius,
                                   b
                                 ),
                       LXColor.Blend.LIGHTEST);
        }
      }
    }
  }
  
}
