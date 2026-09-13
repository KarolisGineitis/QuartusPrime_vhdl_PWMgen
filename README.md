This Quartus Prime project is my first experience with VHDL. It is a PWM generator for a cheap devboard containing an Altera EP4CE6E22C8N.
<img width="1470" height="846" alt="Image" src="https://github.com/user-attachments/assets/e82d2471-3c8a-4948-8a6c-4e08271b7021" />
It allows you to cycle the pwm period (from 1 μs to 10 μs in 1 μs steps) and duty cycle (from 0 to 100 % in 10 % steps) by two buttons. The project uses the onboard 50 MHz oscillator to feed an ALTPLL Altera IP module, creating a 100 MHz clock.

On the board the 50 MHz clock is connected to PIN 24.

PWM output --> PIN 60

Duty cycle change button --> PIN 73

Period change button --> PIN 114

Reset button --> PIN 88

The frequency of pwm is determined by the length of a counter, that increments each clock cycle. The button (on PIN 114) changes at what value does this counter reset. This counter acts as a variable frequency
sawtooth waveform. The duty cycle is determined by a variable (button on PIN 73) threshold. When the counter reaches/exceeds this threshold, the output pin is set low and otherwise it is set high.
So the duty cycle is a result of the calculation threshold = period * duty /100. "Period" is the value at which the counter resets, so changing "duty" determines how much of the period the pin is high or low.

The button inputs go through a "debounce" module that starts/resets a counter (1E+6 cycles of 100 MHz = 10 ms) when a button is pressed and ignores any change to the button until the counter reaches the 1E+6 cycles.

The default values after a reset are 1 μs period (1 MHz) and 30 % duty cycle. They are set in the top entity generics (pwm_gen.vhd file).

The board is programmed with USB Blaster 2 through the jtag interface of the board.
