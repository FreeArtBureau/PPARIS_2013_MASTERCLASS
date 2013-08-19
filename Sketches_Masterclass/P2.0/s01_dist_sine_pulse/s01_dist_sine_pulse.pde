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
    theShader.set("t", millis()/1000.0);
    theShader.set("resolution", float(width), float(height));
    shader(theShader);
    rect(0,0,width,height);
}


void reloadShader()
{
    theShader = loadShader("dist_sine_pulse.glsl");
}


