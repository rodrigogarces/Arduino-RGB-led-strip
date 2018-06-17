#include "cie1931.h"

//led ports
#define ledRed   10
#define ledGreen 8
#define ledBlue  9

//max color led values
#define maxRed    255    //165   255   255   255   255   255   255
#define maxGreen  90     //252   230   128   134   120   112   90
#define maxBlue   57     //250   180   76    102   76    76    57

int red, green, blue = 0;

void setup() {
  Serial.begin(9600);
  Serial.setTimeout(10);

  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);
  pinMode(blue, OUTPUT);
}

void loop() {
  if (Serial.available()){
    //read int values from serial
    red = Serial.parseInt();
    green = Serial.parseInt();
    blue = Serial.parseInt();



    //convert rgb to valid values (0-255)
    if (red > 255){
      red = 255;
    }
    else if (red < 0){
      red = 0;
    }

    if (green > 255){
      green = 255;
    }
    else if (green < 0){
      green = 0;
    }

    if (blue > 255){
      blue = 255;
    }
    else if (blue < 0){
      blue = 0;
    }

    Serial.println("Original values: " + String(red) + " " + String(green) + 
    " " + String(blue));

    //remap color values to improve color precision
    red = map(red, 0, 255, 0, maxRed);
    green = map(green, 0, 255, 0, maxGreen);
    blue = map(blue, 0, 255, 0, maxBlue);

    //PWM
    //common anode
    /*analogWrite(ledRed, cie[red]);
    analogWrite(ledGreen, cie[green]);
    analogWrite(ledBlue, cie[blue]);*/

    //common cathode
    analogWrite(ledRed, cie[255 - red]);
    analogWrite(ledGreen, cie[255 - green]);
    analogWrite(ledBlue, cie[255 - blue]);
    
    //print rgb values
    Serial.println("remaped values: " + String(red) + " " + String(green) + 
    " " + String(blue));
  }
}
