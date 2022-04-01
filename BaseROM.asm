
.weak
  WARNINGS :?= "None"
.endweak

GUARD_BASEROM :?= false
.if (GUARD_BASEROM && (WARNINGS == "Strict"))

  .warn "File included more than once."

.elsif (!GUARD_BASEROM)
  GUARD_BASEROM := true

  ; Fill the base ROM in parts to prevent
  ; pc wrap warnings.

  * := $000000

  .for bank in range($000000, $400000, $8000)
    * := bank
    .binary BASEROM, bank, $8000
  .next

.endif ; GUARD_BASEROM
