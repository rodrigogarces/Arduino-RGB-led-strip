import processing.serial.*;

//instance arduino on serial port
Serial arduino;

//GUI variables
PFont f;
boolean inCircle = true;
//Luminance slider
float temp;
float w1 = 530;
float h1 = 80;
float w2 = 570;
float h2 = 530;
float sliderH = 450;

//Colors
float red =255;//Red
float green = 255;//Green
float blue = 255;//Blue
float mL = 128;//Luminance
float normLum = 0.5;//Normalized luminance 0-1
float lR,lG,lB=255;//Temp values with luminance
color c;//Color preview (rgb)



void setup(){
  //Initialize arduino via serial
  String portName = Serial.list()[0];
  arduino = new Serial(this, portName, 9600);
  
  //instance GUI
  f = loadFont("Ubuntu-48.vlw");
  background(255);
  colorMode(HSB);
  size(590,562);
  translate(256,306);
  smooth();
  noStroke();
  saturationChanger(128,256);
  colorMode(RGB);
  
  
  //apply luminance to rgb values
  lR = red * normLum;
  lG = green * normLum;
  lB = blue * normLum;
  c = color(lR,lG,lB);
  
  //send values with luminance to arduino
  arduino.write(int(lR) + "." + int(lG) + "." + int(lB));
  //println(int(lR) + "." + int(lG) + "." + int(lB));
  
}

//GUI
void saturationChanger(int i, int initial){
  if(i > 0){
    colorTriangle(256,0,initial,initial);
    saturationChanger(i-1, initial-2);
  }
}
void colorTriangle(int iteration, int h, int s,int height){
  if(iteration > 0){
    fill(h%256,s,256);
    triangle(0,0,128*tan(radians(5.625/4)),height,-128*tan(radians(5.625/4)),height);
    rotate(radians(5.625/4));
    colorTriangle(iteration-1, h+1, s, height);
  }
}

//GUI
void draw() {
  fill(255);
  rect(0,0,600,40);
  textFont(f,20);
  fill(0);
  text("R:",10,30);
  text("G:",150,30);
  text("B:",300,30);
  text("L:",480,30);
  
  for(int i=0; i<sliderH; i++){
    temp=map(i,0,sliderH,255,0);
    stroke(temp,temp,temp);
    line(w1,h1+i, w2, h1+i);
  }
  line(w1,h1,w2,h1);
  line(w2,h1,w2,h2);
  line(w2,h2,w1,h2);
  line(w1,h2,w1,h1);
  
  noStroke();
  
  if (inCircle) {
    text(int(red),40,30);
    text(int(green),180,30);
    text(int(blue),330,30);
    text(int(mL),510,30);
    fill(c);
    stroke(0);
    rect(420,5,30,30);
    noStroke();
  }
}


void mouseClicked() {
  // Get mouse x,y
  // mouseX mouseY
  // Check if in circle
  // center of circle is 256,306
  if (dist(mouseX,mouseY,256,306) < 255) {
    //print("in circle ");
    //Get colors
    c = get(mouseX,mouseY);
    red = c >> 16 & 0xFF;
    green = c >> 8 & 0xFF;
    blue = c & 0xFF;
    inCircle = true;
    
    //apply luminance to rgb values
    lR = red * normLum;
    lG = green * normLum;
    lB = blue * normLum;
    c = color(lR,lG,lB);

    //send values with luminance to arduino
    arduino.write(int(lR) + "." + int(lG) + "." + int(lB));
    //println(int(lR) + "." + int(lG) + "." + int(lB));
  }
  else if (mouseX>w1 && mouseX<w2 && mouseY>h1 && mouseY<h2){
    //luminance slider
    mL = map(mouseY,h1+sliderH,h1,0,255);
    //Normalize luminance
    normLum = mL/255;
    
    //apply luminance to rgb values
    lR = red * normLum;
    lG = green * normLum;
    lB = blue * normLum;
    c = color(lR,lG,lB);
  
  //send values with luminance to arduino
  arduino.write(int(lR) + "." + int(lG) + "." + int(lB));
  //println(int(lR) + "." + int(lG) + "." + int(lB));
  }
  
  

}

void exit(){
  arduino.write("0.0.0");
  print ("quit");
}
