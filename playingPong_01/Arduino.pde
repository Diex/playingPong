/*
arduino_servo

Demonstrates the control of servo motors connected to an Arduino board
running the StandardFirmata firmware.  Moving the mouse horizontally across
the sketch changes the angle of servo motors on digital pins 4 and 7.  For
more information on servo motors, see the reference for the Arduino Servo
library: http://arduino.cc/en/Reference/Servo

To use:
* Using the Arduino software, upload the StandardFirmata example (located
  in Examples > Firmata > StandardFirmata) to your Arduino board.
* Run this sketch and look at the list of serial ports printed in the
  message area below. Note the index of the port corresponding to your
  Arduino board (the numbering starts at 0).  (Unless your Arduino board
  happens to be at index 0 in the list, the sketch probably won't work.
  Stop it and proceed with the instructions.)
* Modify the "arduino = new Arduino(...)" line below, changing the number
  in Arduino.list()[0] to the number corresponding to the serial port of
  your Arduino board.  Alternatively, you can replace Arduino.list()[0]
  with the name of the serial port, in double quotes, e.g. "COM5" on Windows
  or "/dev/tty.usbmodem621" on Mac.
* Connect Servos to digital pins 4 and 7.  (The servo also needs to be
  connected to power and ground.)
* Run this sketch and move your mouse horizontally across the screen.
  
For more information, see: http://playground.arduino.cc/Interfacing/Processing
*/



Arduino arduino;

void setupArduino() {
   // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
  // Configure digital pins 4 and 7 to control servo motors.
  arduino.pinMode(9, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
}

void updateServoR(float val) {
 arduino.servoWrite(9, (int) val); // constrain((int) map(val, 0, 1, 0, 180), 0, 180)
}

void updateServoL(float val) {
 arduino.servoWrite(11, (int) val); // constrain((int) map(val, 0, 1, 0, 180), 0, 180)
}
