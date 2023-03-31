
.weak
  WARNINGS :?= "None"
.endweak

GUARD_VERSUS_MODE :?= false
.if (!GUARD_VERSUS_MODE)
  GUARD_VERSUS_MODE := true

  ; Fixed-location inclusions

  * := $02004A
  .logical mapped($02004A)

    ; This is a hacky peephole edit to the chapter data table.

    .for _i in range($22)

      .fill structChapterDataTableEntry.EnemyController
      .byte CD_PlayerControlled

    .endfor

  .endlogical

.endif ; GUARD_VERSUS_MODE
