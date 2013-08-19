PShader theShader;
float timeReload;
PGL pgl;


void setup() 
{
  size(800, 600, P3D);
  noStroke();
  reloadShader();
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
    //theShader.set("time", millis());
    theShader.set("resolution", float(width), float(height));
    theShader.set("freqx", 10.0);
    theShader.set("freqy", float(height)/float(width)*10.0);
    shader(theShader);
    rect(0,0,width,height);
}


void reloadShader()
{
    theShader = loadShader("cos_xy_frag.glsl");
}


