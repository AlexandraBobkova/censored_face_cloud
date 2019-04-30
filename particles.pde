class P {
  float X;
  float Y;

  P(float xpos, float ypos) {
    X=xpos;
    Y=ypos;
  }
  float x() {
    return X;
  }
  float y() {
    return Y;
  }
}
class crystal {
  float maxSize;
  float maxL;

  float L;
  float size;
  float angle;

  float endPX;
  float endPY;

  int branchCount=0;

  crystal[] branches;

  P middleP;
  P endP;
  P one;
  P two;
  P three;


  crystal(P p1) {



    branches= new crystal[maxbranch];


    endPX=p1.x()+cos(angle);
    endPY=p1.y()+sin(angle);

    if ( endPX>width) {
      endPX=width;
    }
    if ( endPX<0) {
      endPX=0;
    }
    if ( endPY>height) {
      endPY=height;
    }
    if ( endPY<0) {
      endPY=0;
    }

    one= new P(endPX, endPY);

    L= random(20, 40);
    angle=random(2/3*PI, 4/3*PI);

    endPX=p1.x()+cos(angle)*L;
    endPY=p1.y()+sin(angle)*L;

    if ( endPX>width) {
      endPX=width;
    }
    if ( endPX<0) {
      endPX=0;
    }
    if ( endPY>height) {
      endPY=height;
    }
    if ( endPY<0) {
      endPY=0;
    }

    two= new P(endPX, endPY);

    L= random(10, 40);
    angle=random(4/3*PI, 2*PI);

    endPX=p1.x()+cos(angle)*L;
    endPY=p1.y()+sin(angle)*L;

    if ( endPX>width) {
      endPX=width;
    }
    if ( endPX<0) {
      endPX=0;
    }
    if ( endPY>height) {
      endPY=height;
    }
    if ( endPY<0) {
      endPY=0;
    }

    three= new P(endPX, endPY);
  }
  P endP() {
    return endP;
  }

  void branch() {
    if (branchCount<maxbranch) {
      branchCount++;
      if (branchCount % 3==0) {
        branches[branchCount-1]= new crystal(this.one);
      }
      if ( branchCount % 3==1) {
        branches[branchCount-1]= new crystal(this.two);
      }
      if ( branchCount % 3==2) {
        branches[branchCount-1]= new crystal(this.three);
      }
    }
  }


  void TimerTime() {
    if (ampt>0.004) { 
      start = millis();
    }
  }

  void effect() {
    PImage rgb = kinect2.getVideoImage();
    image(rgb, 560, 320, 512, 424);


    image(frames[index], 560, 320, 512, 424);
    for (int i = 0; i < frame_count; i++)
    {
      pushMatrix();
      pushStyle();

      tint(255, 255 / frame_count);
      image(frames[(index + i) % frame_count], 560, 320, 512, 424);

      popStyle();
      popMatrix();
    }
    filter(BLUR, 4); //blur effect
    PImage p = rgb;
    frames[index] = p.copy();
    index += 1;
    if (index == frame_count)
    {
      index = 0;
    }
  }

  void showcrystal() {
    noStroke();
    color c;
    if (ampt>0.009 && millis() > lasttimecheck + timeinterval) {
      c = color(random(160, 190), 0, 0, 17); //red

      // c = color(random(1, 15), 30); //black - later change to light gray/white
      this.effect();
    } else {
      // c = color(random(160, 190), 0, 0, 17); //red
      c = color(random(1, 15), 30); //black - later change to light gray/white
    }
    fill(c);


    beginShape();
    vertex(one.x(), one.y());
    vertex(two.x(), two.y());
    vertex(three.x(), three.y());

    endShape();
  }



  void display() {

    this.showcrystal();  
    for (int i=0; i<branchCount; i++) {
      branches[i].display();
    }

    this.branch();
  }
}
