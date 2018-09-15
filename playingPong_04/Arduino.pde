import processing.serial.*;
 
Serial alice;                      // Create object from Serial class
Serial bob;

void setupArduino() {  
  // Open the port that the board is connected to and use the same speed (9600 bps) 
  println(Serial.list());
  alice = new Serial(this, "/dev/ttyUSB0", 115200); 
  
  for(String port : Serial.list())
  {
    if(port.equals("/dev/ttyUSB2")) bob = new Serial(this, "/dev/ttyUSB2", 115200);  
    if(port.equals("/dev/ttyUSB1")) bob = new Serial(this, "/dev/ttyUSB1", 115200);  
  
  }
  
  

  
  
}

void updateServo(String pad, float val) {
  int angle = int(map(val, 0.0, 1.0, 0, 180));  // Scale the value to the range 0-180
  if(alice != null && pad.equals("A")) alice.write(pad+":"+angle+'\n');                        // Write the angle to the serial port
  if(bob != null && pad.equals("B")) bob.write(pad+":"+angle+'\n');                        // 
}
