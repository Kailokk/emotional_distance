## Emotional Distance
This repository contains code used in an art installation by artist Logan Smith.
The repo consists of a processing sketch for video playback, arduino sketch for sensor reading, and a rust script to assemble the project and flash the connected arduino.

![](resources/demo.gif)

---

### Arduino And Sensor
The sensor component of the installation used a single **HC-SRO4** ultrasonic sensor.

A high signal is sent out from the arduion to a pin on the sensor. This sends a 40khz sonic blast out from it while the signal remains high. A second pin will give a signal of low until the sonic blast is recieved (after bouncing off of surrounding objects). This pin is read waiting for the high signal.

This value is then used to calculate the distance of objects from the sensor by multiplying it by the speed of sound (gets overall distance) and then dividing it by 2 (as we only want to measure the distance from the input to the object that reflected this sound.)

The arduino code then outputs this value on a serial port to be read by the processing program.

### Processing
The processing program will begin playback of a provided video. It will the continuously read the serial port and get the distance of nearby objects. This value will then be provided to a fragment shader which applys a fullscreen filtering effect.

##### The Effects
The effects consist of generated white noise, and a chromatic aberration filter.
These are written in glsl, with some specific syntax to allow them to work with processing.


### The Rust Build System
This aspect of the setup was used to simplify the installation process. The program will build the arduino sketch, upload it to a connected arduino, and then compile the processing sketch into an executable. This program allowed for easy identification of what step in the build was failing at a given moment.

--- 

## Reflections
- The rust build system still relies on a couple cli programs being installed. This isn't ideal.
- The port selection for both the arduino, and by extension processing, was not automated. This is inconvenient as the serial port could differ between machines/usb ports.
- The sensor chosen for this installation was less than ideal. It has a good range, but the axis it can gather data in is only 15°. It also would be inconsistent in its readings (absorbent materials would not reflect the signal as well as hard surfaces.).
- The sensor code would return a default value with nothing in front of it.I never found a cause for this, it seemed that the sensors would send a high signal after around 25cm if nothing was infront of it. This is confusing as if something was in front of it at a farther distance, it would have no issue.

---

## Project Status
This project is now archived. I have kept it up as a reference for myself, and for anyone it may help. If you have any questions please feel free to reach out to me :)
