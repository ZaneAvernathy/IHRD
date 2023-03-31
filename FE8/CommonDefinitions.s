
.macro SET_FUNC name, value
  .global \name
  .type   \name, %function
  .set    \name, \value
.endm

.macro SET_DATA name, value
  .global \name
  .type   \name, %object
  .set    \name, \value
.endm

SET_FUNC StartDialogueFromIndexWithParent, 0x08006A51
SET_FUNC StartDialogue_, 0x0800698D
SET_FUNC DrawDifficultyDescription, 0x80ABFE1
SET_FUNC Text_DrawChar_, 0x08004181

SET_DATA DifficultyDescriptions, 0x08A20A08
