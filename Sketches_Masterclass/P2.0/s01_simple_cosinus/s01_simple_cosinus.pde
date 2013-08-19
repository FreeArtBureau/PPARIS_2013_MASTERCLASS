PShader theShader;
float timeReload;
PGL pgl;


void setup() 
{
  size(800, 600, P3D);
  noStroke();
  loadShader();
  timeReload = millis();
}

void draw()
{
  // Timing
  float now = millis();
  if (now-timeReload>=500)
  {
    timeReload = now;
    loadShader();
  }

  // Shader
    //theShader.set("time", millis());

    theShader.set("freq", 6.0);
    shader(theShader);
    rect(0,0,width,height);
}


void loadShader()
{
    theShader = loadShader("cos_frag.glsl");
}


