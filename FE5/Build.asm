
.cpu "65816"

.weak
  WARNINGS :?= "None"
.endweak

GUARD_IHRD :?= false
.if (GUARD_IHRD && (WARNINGS == "Strict"))

  .warn "File included more than once."

.elsif (!GUARD_IHRD)
  GUARD_IHRD := true

  .include "BaseROM.asm"

  USE_ALL :?= false

  .if (USE_ALL)

    USE_2019 :?= true
    USE_2022 :?= true

  .else

    USE_2019 :?= false
    USE_2022 :?= false

  .endif ; USE_ALL

  .if (USE_2019)

    .include "2019/2019.asm"

  .endif ; USE_2019

  .if (USE_2022)

    .include "2022/2022.asm"

  .endif ; USE_2022

  * := $1FB704
  .logical mapped($1FB704)

    .dsection IHRD_2022_Section

  .endlogical

.endif ; GUARD_IHRD
