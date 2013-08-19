PShader theShader;
PGraphics offscreen;
void setup() 
{
  size(800, 600, P3D);
  offscreen = createGraphics(width,height,P3D);
  theShader = loadShader("dither_frag.glsl");
  theShader.set("scale", 1.0);
}

void draw()
{
  offscreen.beginDraw();
  offscreen.background(0);
  offscreen.lights();
  float r = radians(frameCount)/2;
  offscreen.translate(width/2, height/2);
  offscreen.rotateX(r);
  offscreen.rotateY(r);
  offscreen.noStroke();
  offscreen.fill(255);
  //box(160);
  offscreen.sphereDetail(6);
  offscreen.sphere(160);
  offscreen.endDraw();

  shader(theShader);
  image(offscreen,0,0);
}


