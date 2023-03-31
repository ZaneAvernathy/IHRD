
.weak
  WARNINGS :?= "None"
.endweak

GUARD_REVERSE_INPUTS :?= false
.if (!GUARD_REVERSE_INPUTS)
  GUARD_REVERSE_INPUTS := true

  ; Fixed-location inclusions

  * := $00000E
  .logical mapped($00000E)

    ; Hook overwrites

    ; lda JOY1,b
    ; sta wJoy1Input

    jsl rlReverseJoy1Input
    nop

    .checkfit mapped($000013)

    .databank ?

  .endlogical

  * := $000044
  .logical mapped($000044)

    ; Hook overwrites

    ; lda JOY2,b
    ; sta wJoy2Input

    jsl rlReverseJoy2Input
    nop

    .checkfit mapped($000049)

    .databank ?

  .endlogical

  ; Freespace inclusions

    .section IHRD_2022_Section

      rlReverseJoy1Input

        .al
        .xl
        .autsiz
        .databank ?

        ; Inputs:
        ; None

        ; Outputs:
        ; A: modified joypad value
        ; wJoy1Input: modified joypad value

        lda JOY1,b

        jsl rlReverseJoypad

        sta wJoy1Input

        rtl

        .databank 0

      rlReverseJoy2Input

        .al
        .xl
        .autsiz
        .databank ?

        ; Inputs:
        ; None

        ; Outputs:
        ; A: modified joypad value
        ; wJoy2Input: modified joypad value

        lda JOY2,b

        jsl rlReverseJoypad

        sta wJoy2Input

        rtl

        .databank 0

      rlReverseJoypad

        .al
        .xl
        .autsiz
        .databank ?

        ; Inputs:
        ; A: joypad reading

        ; Outputs:
        ; A: modified joypad

        phx

        ; This should be a cheap way to check if
        ; we're on the map.

        pha

        lda wUnknown000E23,b
        bne +

          pla
          plx
          rtl

        +

        lda wEventEngineStatus,b
        beq +

          pla
          plx
          rtl

        +

        pla

        ldx wR0
        phx

        ldx wR1
        phx

        ; Keep the normal in wR0, and new in wR1

        sta wR0

        and #JOY_ID
        sta wR1

        ; Really ugly to do, but we have to check
        ; for each bit in both directions and set
        ; the corresponding bit.

        ReversedJoypadList  := [(JOY_A, JOY_B)]
        ReversedJoypadList ..= [(JOY_B, JOY_A)]

        ReversedJoypadList ..= [(JOY_X, JOY_Y)]
        ReversedJoypadList ..= [(JOY_Y, JOY_X)]

        ReversedJoypadList ..= [(JOY_L, JOY_R)]
        ReversedJoypadList ..= [(JOY_R, JOY_L)]

        ReversedJoypadList ..= [(JOY_Start, JOY_Select)]
        ReversedJoypadList ..= [(JOY_Select, JOY_Start)]

        ReversedJoypadList ..= [(JOY_Up, JOY_Down)]
        ReversedJoypadList ..= [(JOY_Down, JOY_Up)]

        ReversedJoypadList ..= [(JOY_Left, JOY_Right)]
        ReversedJoypadList ..= [(JOY_Right, JOY_Left)]

        .for Original, Reversed in ReversedJoypadList

          lda #Original
          bit wR0
          beq +

            lda #Reversed
            ora wR1
            sta wR1

          +

        .endfor

        ; Clean up and return

        lda wR1

        plx
        stx wR1

        plx
        stx wR0

        plx

        rtl

        .databank 0

    .endsection IHRD_2022_Section

.endif ; GUARD_REVERSE_INPUTS
