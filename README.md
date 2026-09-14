This Quartus Prime project is my first experience with VHDL. It is a PWM generator for a cheap devboard containing an Altera EP4CE6E22C8N.
<img width="1470" height="846" alt="Image" src="https://github.com/user-attachments/assets/e82d2471-3c8a-4948-8a6c-4e08271b7021" />
It allows you to cycle the pwm period (from 1 μs to 10 μs in 1 μs steps) and duty cycle (from 0 to 100 % in 10 % steps) by two buttons. The project uses the onboard 50 MHz oscillator to feed an ALTPLL Altera IP module, creating a 100 MHz clock.

On the board the 50 MHz clock is connected to PIN 24.

PWM output --> PIN 60

Duty cycle change button --> PIN 73

Period change button --> PIN 114

Reset button --> PIN 88

PLL lock state --> PIN 1 = led

The frequency of pwm is determined by the length of a counter, that increments each clock cycle. The button (on PIN 114) changes at what value does this counter reset. This counter acts as a variable frequency
sawtooth waveform. The duty cycle is determined by a variable (button on PIN 73) threshold. When the counter reaches/exceeds this threshold, the output pin is set low and otherwise it is set high.
So the duty cycle is a result of the calculation threshold = period * duty /100. "Period" is the value at which the counter resets, so changing "duty" determines how much of the period the pin is high or low.

The button inputs go through a "debounce" module that starts/resets a counter (1E+6 cycles of 100 MHz = 10 ms) when a button is pressed and ignores any change to the button until the counter reaches the 1E+6 cycles.

The default values after a reset are 1 μs period (1 MHz) and 50 % duty cycle. They are set in the top entity generics (pwm_gen.vhd file).

The project is compiled in Quartus Prime lite v25.1. A .jic file is created using the included conversion setup file (jic_conversion_setup.cof) and the EPCS4 device is programmed with USB Blaster 2 through the jtag interface of the board.

A few measurements, demonstrating the pwm generation and parameter change, are included. The CH1 of the scope is connected through a 10x probe to PIN 60 and the ground of the scope is connected to an available ground on the board.

This video shows cycling through all duty_cycle values for the 1MHz frequency, then the frequency is reduced to 100 kHz and the duty is cycled again. 
<video src="https://github.com/user-attachments/assets/a9a36d39-4ed0-43b7-a384-90eaa6b5015e" />

In this image the transition from 50% duty to 60 % is captured using a pulse width trigger condition.
<img width="1068" height="643" alt="Image" src="https://github.com/user-attachments/assets/0ab0e5c6-68aa-4799-ab60-70fe09f2aad8" />

Here the period transition from 1 μs to 2 μs is captured using the same trigger condition.
<img width="1064" height="641" alt="Image" src="https://github.com/user-attachments/assets/660ba613-38c8-498c-841d-b2566cdf5f38" />

Finally the default board operation is captured after a release of the reset button.
<img width="1065" height="642" alt="Image" src="https://github.com/user-attachments/assets/70838a5a-e498-4ec1-aacb-2da5c630881e" />


As a note, here is a picture of faulty operation, before thrsh_sync was included in pwm_simple_block.vhd. The short pulse was a result of the unsynchronized (to the "sawtooth waveform") change of the threshold value.
<img width="1066" height="641" alt="Image" src="https://github.com/user-attachments/assets/0ad9f749-b081-4f19-aded-ce71aa1e69f2" />


