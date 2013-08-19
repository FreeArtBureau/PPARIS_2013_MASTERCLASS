

PMatrix3D transfo;
float xCam, zCam;
float angleCam = 0.0f;

void setup()
{
  size(800, 600, P3D);
  transfo = new PMatrix3D();
}


void draw()
{
  background(0);
  
  // Perspective transform
  perspective( 
              radians(100), 
              float(width)/float(height), 
              10.0,
              1000.0
              );
  
  // View transform
  xCam = 400*cos( radians(angleCam) );
  zCam = 400*sin( radians(angleCam) );
  angleCam+=1;

  beginCamera();
  camera(xCam,-100,zCam, 0,0,0, 0,1,0);
  endCamera();
  
  // Model transformation
  drawAxis(40);  
  noFill();
  stroke(255);
  box(80);


  // Model + View = ModelView
  // gl_ModelView in shader
}

void drawAxis(float l)
{
  stroke(255,0,0); line(0,0,0,l,0,0);
  stroke(0,255,0); line(0,0,0,0,l,0);
  stroke(0,0,255); line(0,0,0,0,0,l);
}

