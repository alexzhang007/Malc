;
; A test program that simply loops 'count' number of times.
; r0 = the value read from the variable 'count'
; r1 = the current iteration number
;
        .org 0                  ; start the program at address 0
        ld  r0,count            ; load the value of count into r0
        ldi r1,#0               ; initialize r1 to 0
back:   add r1,r1,#1            ; add one to the value in r1
        cmp r1,r0               ; compare iteration number (r1) to count (r0)
        ble back                ; loop if r1 <= r0
        hlt                     ; otherwise, stop execution
;
; Define the storage locations
;
count:
        .word 0xA               ; number of times to loop (in hex)


