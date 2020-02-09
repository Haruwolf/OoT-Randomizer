SHUFFLE_MEDIGORON:
.byte 0x00
.align 4

; Override the inital check that determines which state to initialize medigoron with
; v0 = value based on which medigoron will act for its initial message
medigoron_inital_check:
    ; displaced code
    lui     v1, 0x8012
    addiu   v1, v1, 0xA5D0
    lw      t6, 0x0004(v1)      ; current age
    addiu   at, zero, 0x0005

    lb      t0, SHUFFLE_MEDIGORON
    beqz    t0, @@return        ; skip if the salesman isn't randomized
    li      v0, 0               ; returning with v0 = 0 by default to continue with normal checks

    bnez    t6, @@return        ; skip as child to continue with the normal child behavior

    la      t1, GLOBAL_CONTEXT
    lw      t0, 0x1D44(t1)      ; load scene collectible flags (Goron City)
    andi    t0, t0, 0x1         ; check 0x1 flag (normally unused flag)
    beqz    t0, @@return        
    li      v0, 1               ; if the flag is not set, return with v0 = 1 to offer a purchase
    li      v0, 3               ; else, return with v0 = 3 to display the "sold out" message

@@return:
    jr      ra
    lui     a0, 0x8010          ; displaced code

; Set the medigoron scene collectible flag on purchase if medigoron is randomized
medigoron_buy_item_hook:
    lb      t0, SHUFFLE_MEDIGORON
    beqz    t0, @@return        ; skip if medigoron isn't randomized

    la      t1, GLOBAL_CONTEXT
    lw      t0, 0x1D44(t1)      ; load scene collectible flags (Goron City)
    ori     t0, t0, 0x1         ; set 0x1 flag (custom medigoron flag)
    sw      t0, 0x1D44(t1)

@@return:
    jr      ra
    ori     a3, a3, 0x8000      ; displaced code
