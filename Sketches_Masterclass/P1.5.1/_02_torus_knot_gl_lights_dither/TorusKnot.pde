char drawFlag_Line    = 0x01;
char drawFlag_Tangent = 0x02;

class TorusKnot
{
  public float m_R,m_P,m_Q;

  TriangleMesh mesh;
  // GLModel glModel;
  
  Vec3D points[][];
  Vec3D normals[][];

  // Constructor
  TorusKnot(float R, float P, float Q)
  {
    m_R = R;
    m_P = P;
    m_Q = Q;
    
    mesh = new TriangleMesh();

    int res = 200;
    int res2 = 30;
    
    PVector A,B;
    float[] b;
    Matrix4x4 transfo = new Matrix4x4();
    Matrix4x4 basisM = new Matrix4x4();
    float r2 = 20.0;
    float th  = 0.0;
    float dth = 360.0/(res) ;
    
    points = new Vec3D[res][res2];
    normals = new Vec3D[res][res2];

    for (int i=0 ; i<res ; i++)
    {
      A = getPointAt(th);
      b = getTangentBasis(th);
      
      transfo.identity();
      transfo.translateSelf(A.x,A.y,A.z);
      
      basisM.set(
                      b[0], b[3], b[6], 0.0,
                      b[1], b[4], b[7], 0.0,
                      b[2], b[5], b[8], 0.0,
                      0.0,  0.0, 0.0, 1.0
        );

      transfo.multiplySelf(basisM);


      points[i] = new Vec3D[res2];      
      normals[i] = new Vec3D[res2];

      Vec3D A2 = new Vec3D(A.x,A.y,A.z);

      float a = 0.0f;
      for (int j=0; j<res2; j++)
      {
        points[i][j] = transfo.applyTo( new Vec3D( r2*cos(a), r2*sin(a), 0.0 ) );
        normals[i][j] = points[i][j].sub(A2).normalize();

        a+=TWO_PI/(res2);
      }
      th+=dth;
    }

        Vec3D n1 = new Vec3D(), n2 = new Vec3D();

        for (int i=0;i<points.length;i++){
          
          for (int j=0;j<points[i].length;j++){

//            n1 = normals[i][j].add( normals[i][j+1] ).add( points[i+1][j] );
//            n2 = normals[i][j+1].add( normals[i+1][j+1] ).add( points[i+1][j] );
  
              n1 = ( points[i][(j+1)%res2].sub(points[i][j]) ).cross( points[(i+1)%res][j].sub(points[i][j]) );
              n2 = ( points[(i+1)%res][(j+1)%res2].sub(points[i][(j+1)%res2]) ).cross( points[(i+1)%res][j].sub(points[(i+1)%res][(j+1)%res2]) );
            
            n1 = n1.normalize();
            n2 = n2.normalize();
            
            
            mesh.addFace( points[i][j], points[i][(j+1)%res2], points[(i+1)%res][j], n1);
            mesh.addFace( points[i][(j+1)%res2], points[(i+1)%res][(j+1)%res2], points[(i+1)%res][j], n2 );
            
          }
        }
        
        mesh.computeVertexNormals();


    


  }

  // Methods
  PVector getPointAt(float th)
  {
    PVector p = new PVector();
    float   rA	= 0.5*(2.0+sin(radians(m_Q*th)));
    p.x	= m_R*rA*cos(radians(m_P*th));
    p.y	= m_R*rA*cos(radians(m_Q*th));
    p.z	= m_R*rA*sin(radians(m_P*th));

    return p;
  }

  PVector getTangentAt(float th)
  {
    float dth = 360.0 / 10000.0f;

    PVector A = this.getPointAt(th);
    PVector B = this.getPointAt(th+dth);
    PVector T = new PVector(B.x - A.x, B.y - A.y, B.z - A.z);
    
    T.normalize();

    return T;
  }

  float[] getTangentBasis(float th)
  {
    float[] b = new float[9];
    float dth = 360.0/10000.0;

    PVector T  = new PVector();
    PVector N  = new PVector();
    PVector B_ = new PVector();

    PVector A = getPointAt(th);
    PVector B = getPointAt(th+dth);

    T.set(B.x - A.x, B.y - A.y, B.z - A.z);
    N.set(B.x + A.x, B.y + A.y, B.z + A.z);

    B_ = T.cross(N);
    N  = B_.cross(T);

    N.normalize();
    B_.normalize();
    T.normalize();

    b[0] = N.x ; 
    b[1] = N.y ; 
    b[2] = N.z ; 

    b[3] = B_.x ; 
    b[4] = B_.y ; 
    b[5] = B_.z ; 

    b[6] = T.x ;
    b[7] = T.y ;
    b[8] = T.z ;

    return b;
  }

  void draw(int res, char drawFlag)
  {
    float   th, dth,dth2;
    PVector A,B,T;

    th  = 0.0;
    dth = 360.0/(res-1) ;

        Vec3D p;
        Vec3D n;
        float nl = 10.0;
        for (int i=0;i<points.length;i++){
          
          for (int j=0;j<points[i].length;j++){
            p = points[i][j];
            n = normals[i][j];
            stroke(255);
            point(p.x,p.y,p.z);
            stroke(0,0,255);
//            line(p.x,p.y,p.z, p.x+nl*n.x,p.y+nl*n.y,p.z+nl*n.z);
            
          }
        }


    for (int i=0 ; i<res ; i++)
    {
      A = getPointAt(th);
      B = getPointAt(th+dth);
      th+=dth;

      // Line Drawing
//      if ( (drawFlag & drawFlag_Line) ==1)
      {
        stroke(140);
        line(A.x, A.y, A.z, B.x, B.y, B.z);
      }

      // Tangent Drawing
//      if ((drawFlag & drawFlag_Tangent)==1)
      {
        float[] b = getTangentBasis(th) ; 
        
        float l = 10.0f;
        pushMatrix();
//        translate(A.x,A.y,A.z);
/*        applyMatrix(
                      b[0], b[3], b[6], 0.0,
                      b[1], b[4], b[7], 0.0,
                      b[2], b[5], b[8], 0.0,
                      0.0,  0.0, 0.0, 1.0
                    );
*/
/*        stroke(255,0,0); line(0,0,0,l*b[0],l*b[1],l*b[2]);
        stroke(0,255,0); line(0,0,0,l*b[3],l*b[4],l*b[5]);
        stroke(0,0,255); line(0,0,0,l*b[6],l*b[7],l*b[8]);
*/
        noFill();
//        ellipse(0,0,40,40);
        popMatrix();
        
        
/*        T = getTangentAt(th);
        B.x = A.x + 10.0*T.x;
        B.y = A.y + 10.0*T.y;
        B.z = A.z + 10.0*T.z;
*/
        stroke(255, 0, 0);
        line(A.x, A.y, A.z, B.x, B.y, B.z);

      }

    }
  }
};

