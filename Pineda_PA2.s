.global _start


.equ KEY_BASE,    0xFF200050      // Pushbuttons
.equ SW_BASE,     0xFF200040      // Switches 
.equ HEX_BASE,    0xFF200020      // HEX display

// Constants
.equ MAX_COUNT,    59
.equ DEBOUNCE_CNT, 50000
.equ SEC_DELAY,    5000000


_start:
        // Initialize state
        MOV     R4, #0      // Counter value
        MOV     R5, #0      // 
        MOV     R6, #0      // Previous state ng key 
        MOV     R7, #0      // 0 = up, 1 = down

MAIN_LOOP:


        LDR     R0, =KEY_BASE
        LDR     R1, [R0]          
        MVN     R1, R1              
        EOR     R2, R1, R6           
        AND     R2, R2, R1          
        MOV     R6, R1              

        // KEY0 to start and stop
        TST     R2, #1
        BEQ     KEY1_CHECK
        BL      debounce
        EOR     R5, R5, #1

KEY1_CHECK:
        // KEY1 to reset
        TST     R2, #2
        BEQ     READ_SWITCH
        BL      debounce
        MOV     R4, #0
        MOV     R5, #0

READ_SWITCH:
        // Read SW1 for direction: 0=up, 1=down
        LDR     R0, =SW_BASE
        LDR     R1, [R0]
        AND     R7, R1, #2
        LSR     R7, R7, #1           

        //update the 7 segment
        MOV     R0, R4
        BL      display_two_digit

        //to pause
        CMP     R5, #1
        BEQ     COUNT_DIR
        B       MAIN_LOOP

COUNT_DIR:
        // Delay 1 second
        BL      delay_sec
        // Update counter based on direction
        CMP     R7, #0
        BEQ     COUNT_UP

COUNT_DOWN:
        SUB     R4, R4, #1
        CMP     R4, #-1
        BGT     MAIN_LOOP
        MOV     R4, #MAX_COUNT
        B       MAIN_LOOP

COUNT_UP:
        ADD     R4, R4, #1
        CMP     R4, #60
        BLT     MAIN_LOOP
        MOV     R4, #0
        B       MAIN_LOOP


debounce:
        MOV     R0, #DEBOUNCE_CNT
deb_loop:
        SUBS    R0, R0, #1
        BNE     deb_loop
        BX      LR

// 1 Second Delay

delay_sec:
        LDR     R0, =SEC_DELAY //delay 1 sec
delay_loop:
        SUBS    R0, R0, #1
        BNE     delay_loop
        BX      LR


// Display Two Digits on HEX
display_two_digit:
        PUSH {R1-R6, LR}
        MOV     R1, R0      // Copy counter
        MOV     R2, #0      

split_digits:
        CMP     R1, #10
        BLT split_done
        SUB     R1, R1, #10
        ADD     R2, R2, #1
        B split_digits

split_done:
        LDR     R3, =SEG_TABLE
        LDR     R4, [R3, R1, LSL #2]    // Ones digit
        LDR     R5, [R3, R2, LSL #2]    // Tens digit
        LSL     R5, R5, #8
        ORR     R4, R4, R5
        LDR     R6, =HEX_BASE
        STR     R4, [R6]

        POP {R1-R6, LR}
        BX      LR


// 7-Segment Patterns (0-9)

.data
SEG_TABLE:
        .word 0x3F, 0x06, 0x5B, 0x4F, 0x66
        .word 0x6D, 0x7D, 0x07, 0x7F, 0x6F

.end
