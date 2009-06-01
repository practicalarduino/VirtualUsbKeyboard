/**
 * FakeKeyboard
 *
 * Copyright 2009 Jonathan Oxer <jon@oxer.com.au>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3.
 *
 * Enumerates itself as a HID (Human Interface Device) to a host
 * computer using a USB shield. The Arduino then appears to the host to
 * be a keyboard and keypress events can be sent on demand.
 *
 * This example watches the state of 4 push buttons and when a button
 * is pressed it sends a matching keypress event to the host.
 *
 * http://www.practicalarduino.com/projects/easy/fake-keyboard-and-mouse
 *
 * UsbKeyboard.sendKeyStroke(KEY_B, MOD_GUI_LEFT);
 */

// Requires the use of the "UsbKeyboard" library available from
//   http://code.rancidbacon.com/ProjectLogArduinoUSB
#include "UsbKeyboard.h"

// Define the inputs to use for buttons
#define BUTTON1 9
#define BUTTON2 10
#define BUTTON3 11
#define BUTTON4 12

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

  // Enable the CPU's internal 20k pull-up resistors on the button
  // inputs so they default to a "high" state
  digitalWrite (BUTTON1, HIGH);
  digitalWrite (BUTTON2, HIGH);
  digitalWrite (BUTTON3, HIGH);
  digitalWrite (BUTTON4, HIGH);

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
    UsbKeyboard.sendKeyStroke(KEY_L);
    // Toggle the status LED
    digitalWrite(ledPin, !digitalRead(ledPin));
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON2) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_S);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON3) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_ENTER);
    digitalWrite(ledPin, !digitalRead(ledPin)); // Toggle status LED
  }

  if (digitalRead(BUTTON4) == LOW) {
    UsbKeyboard.sendKeyStroke(KEY_SPACE);
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
