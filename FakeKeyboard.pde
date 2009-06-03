/**
 * Fake Keyboard
 *
 * Enumerates itself as a HID (Human Interface Device) to a host
 * computer using a USB shield. The Arduino then appears to the host to
 * be a keyboard and keypress events can be sent on demand.
 *
 * This example watches the state of 6 push buttons and when a button
 * is pressed it sends a matching keypress event to the host.
 *
 * Copyright 2009 Jonathan Oxer <jon@oxer.com.au>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version. http://www.gnu.org/licenses/
 *
 * www.practicalarduino.com/projects/easy/fake-keyboard-and-mouse
 *
 * UsbKeyboard.sendKeyStroke(KEY_B, MOD_GUI_LEFT);
 */

// Requires the use of the "UsbKeyboard" library available from
//   http://code.rancidbacon.com/ProjectLogArduinoUSB
#include "UsbKeyboard.h"

// Define the inputs to use for buttons
#define BUTTON1 6
#define BUTTON2 7
#define BUTTON3 8
#define BUTTON4 9
#define BUTTON5 10
#define BUTTON6 11

// Use the on-board LED as an activity display
int ledPin = 13;

/**
 * Configure button inputs and set up the USB connection to the host
 */
void setup()
{
  // Set up the activity display LED
  pinMode (ledPin, OUTPUT);
  digitalWrite (ledPin, HIGH);

  // Set the button pins to inputs
  pinMode (BUTTON1, INPUT);
  pinMode (BUTTON2, INPUT);
  pinMode (BUTTON3, INPUT);
  pinMode (BUTTON4, INPUT);
  pinMode (BUTTON5, INPUT);
  pinMode (BUTTON6, INPUT);

  // Enable the CPU's internal 20k pull-up resistors on the button
  // inputs so they default to a "high" state
  digitalWrite (BUTTON1, HIGH);
  digitalWrite (BUTTON2, HIGH);
  digitalWrite (BUTTON3, HIGH);
  digitalWrite (BUTTON4, HIGH);
  digitalWrite (BUTTON5, HIGH);
  digitalWrite (BUTTON6, HIGH); 

  // Disable timer0 since it can mess with the USB timing. Note that
  // this means some functions such as delay() will no longer work.
  TIMSK0&=!(1<<TOIE0);

  // Clear interrupts while performing time-critical operations
  cli();

  // Force re-enumeration so the host will detect us
  usbDeviceDisconnect();
  delayMs(250);
  usbDeviceConnect();

  // Set interrupts again
  sei();
}


/**
 * Main program loop. Scan for keypresses and send a matching keypress
 * event to the host
 * FIXME: currently repeats as fast as it can. Add transition detection
 */
void loop()
{
  UsbKeyboard.update();

  if (digitalRead(BUTTON1) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_A);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON2) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_B);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON3) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_C);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON4) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_D);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }
  
  if (digitalRead(BUTTON5) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_E);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }
  
  if (digitalRead(BUTTON6) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_H, MOD_SHIFT_LEFT);
    UsbKeyboard.sendKeyStroke(KEY_E);
    UsbKeyboard.sendKeyStroke(KEY_L);
    UsbKeyboard.sendKeyStroke(KEY_L);
    UsbKeyboard.sendKeyStroke(KEY_O);
    UsbKeyboard.sendKeyStroke(KEY_SPACE);
    UsbKeyboard.sendKeyStroke(KEY_W, MOD_SHIFT_LEFT);
    UsbKeyboard.sendKeyStroke(KEY_O);
    UsbKeyboard.sendKeyStroke(KEY_R);
    UsbKeyboard.sendKeyStroke(KEY_L);
    UsbKeyboard.sendKeyStroke(KEY_D);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }
}


/**
 * Define our own delay function so that we don't have to rely on
 * operation of timer0, the interrupt used by the internal delay()
 */
void delayMs(unsigned int ms)
{
  for (int i = 0; i < ms; i++) {
    delayMicroseconds(1000);
  }
}
