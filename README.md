# Arduino-RGB-led-strip
Arduino + processing rbg led strip controlling 

## Arduino
Receives a xxx.xxx.xxx int value via serial where xxx is a integer between 0 and 255 (the dot is the delimiter, so the value of the three color can be set in a single command).

Color code can be sent by whatever program that can estabilish a serial connection with arduino.

## Processing
Processing code is basically a GUI to set rgb and luminance values easily.

INSERT PICTURE

RGB color mixer and luminance bar.

## Python
Python is used only to generate a cie1931 gamma correction table (8 bit to match arduino pwm)

## Usage
#### On procesing
1. Pick a RGB value from rgb color mixer
2. Apply luminance to rgb values
3. Send values via serial to arduino

#### On arduino
1. Receive rgb values (with luminance applied)
2. Adjust individual rgb colors to reduce color deviance (based on led specific)
3. Adjust gamma to improve color accuracy
4. send values to leds


## Color correction (led specific)
```c++
//max color led values
#define maxRed    255    //165   255   255   255   255   255   255
#define maxGreen  90     //252   230   128   134   120   112   90
#define maxBlue   57     //250   180   76    102   76    76    57
```