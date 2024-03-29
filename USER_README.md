# :couple: User Documentation

This is a guide to using the controller.

Included is how to [install](#Installation) the app, [connect](#Connecting) to the car, how to [control](#Controlling) the car, and how to adjust [settings](#Settings).

## Requirements

- :iphone: iPhone running iOS 13
- :computer: Computer running macOS

## Installation

1. Download XCode.
2. Download this source code.
3. Open app in XCode.
4. Plug your phone into the computer. 
5. Build the app on your phone.

## Connecting

1. Connect the adafruit microcontroller to power.
2. Open the controller app.
3. Controller will auto connect to the car, displaying `Connected: true` at the top.

## Controlling

To move the car forward, press the two forward arrows simultaneously.

![Move forward](/images/forward.jpg)

To move the car backwards, press the two back arrows simultaneously.

![Move backward](/images/backward.jpg)

To turn, either press the forward arrow on one side alone.

![Turn](/images/turn.jpg)

To rotate, press the forward arrow on one side, and the back arrow on the other side.

![Rotate](/images/rotate.jpg)

## Settings

To adjust the main speed of the car, use the speed slider.

![Speed slider](/images/speed_slider.jpeg)

Alternatively, for quick speed selection, use the "Go Fast" and "Go Slow" buttons.

![Speed quick toggles](/images/speed_toggles.jpeg)

To account for uneven motor powers, use the individual left and right speed steppers. This will allow you to lower speed on motors that are more powerful than the other.

![Motor adjustment](/images/steppers.jpeg)

To access more settings, press the gear icon in the top right corner.

![More settings](/images/gear.jpeg)

The motor pins can be changed here, if you change which motor pins the motors are connected to.

![Motor pins](/images/pins.jpeg)

The forward direction can also be changed here, if one motor is spinning the wrong direction, it can be toggled to spin the correct direction.

![Motor directions](/images/direction.jpeg)

## :tada: Finished!

Now you are ready to control the Honey Badger!
