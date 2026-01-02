# DEBOUNCING

Why debouncing is essential in embedded systems.

In embedded systems, debouncing ensures that a single press of a button or switch is registered as one digital event, preventing errors caused by the microscopic bouncing of metal contacts. This bounce, lasting 1 to 10 milliseconds, can be seen by a fast microcontroller as multiple presses, leading to logic errors, repeated inputs, or interrupt overloads. A common solution is a timer-based debounce that ignores further changes for a short period, ensuring only one clean event per press.


# METHOD IMPLEMENTED

**DEBOUNCING**

To eliminate the effect of mechanical bouncing in switches, a software debounce delay is used. This small delay prevents multiple triggers from a single press, making the input readings stable and reliable.

**Direction Control**

A switch is read to determine the counting direction. The system interprets the switch state to decide whether the counter should increment (up) or decrement (down).

**Counter Logic**

The counter value is updated based on the chosen direction, with wrap-around behavior so that it cycles between 0 and 59. This ensures continuous counting without exceeding the defined limits.
