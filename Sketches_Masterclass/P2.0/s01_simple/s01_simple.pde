PShader theShader;
float timeReload;
PGL pgl;


void setup() 
{
  size(800, 600, P3D);
  noStroke();
  reloadShader();
  theShader.set("resolution", float(width), float(height));
  timeReload = millis();
}

void draw()
{
  // Timing
  float now = millis();
  if (now-timeReload>=500)
  {
    timeReload = now;
    reloadShader();
  }

  // Shader
    theShader.set("time", millis());
    shader(theShader);
    rect(0,0,width,height);
}


void reloadShader()
{
    theShader = loadShader("simple_frag.glsl", "simple_vert.glsl");
}


