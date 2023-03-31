
#include "gbafe.h"

// CLib fixes

  // CLib is missing DMA definitions, so:
  #include "DMA.h"

  char* Text_DrawChar_(struct TextHandle*, char*); //! FE8U = 0x8004181
  Proc* StartDialogue_(int xTile, int yTile, const char* cstring, struct Proc* parent); //! FE8U = 0x800698D

// Main hack stuff

  struct ReplacedTextEntry
  {
    union
    {
      s32 terminator;
      struct
      {
        u32 index;
        const char* textPointer;
      };
    };
  };

  extern const struct ReplacedTextEntry gReplacedTextEntryList[];
  #define TERMINATOR (-1)

  extern char gCurrentTextString[];
  extern u16 gCurrentTextIndex;

  extern u8 gLang;

  inline bool IsBadEmulator()
  {
    return (gLang >> 7);
  }

  bool EmulatorCheck()
  {
    /*
     * Returns whether an emulator simulates DMA transfers
     * correctly. See: https://mgba.io/2018/03/09/holy-grail-bugs-revisited/#the-great-gba-dma-disaster
     *
     * Shout out to Leonarth who inspired me to make this, see https://github.com/minishmaker/randomizer/blob/master/RandomizerCore/Resources/Patches/asm/saveTypeCheck.s
     */

    // We're going to use `gCurrentTextString` as a random bit of free space.

    DmaCopy16(3, 0x08000000, &gCurrentTextString, 16);
    DmaCopy16(3, 0x00000000, &gCurrentTextString, 16);

    return (gCurrentTextString[0] ? false : true);
  }

  int GetLang_Replacement()
  {
    /*
     * This function gets the language:
     *   0: SJIS
     *   1: ASCII
     */

    // Reusing the uppermost bit of this as a flag.
    return gLang & 0x7F;
  }

  void SetLang_Replacement(int lang)
  {
    /*
     * This function sets the language:
     *   0: SJIS
     *   1: ASCII
     */

    // Using this as a good time to check if our emulator is bad.
    bool badEmulator = EmulatorCheck();
    gLang = (badEmulator << 7) | lang;
  }

  char* GetStringFromIndexIntercepted(int index)
  {
    /*
     * This function is called instead of GetStringFromIndex
     * in order to load alternate text based on emulator accuracy.
     */

    if (IsBadEmulator())
    {

      // Trawl our list to see if the requested index is in it.

      unsigned i = 0;
      struct ReplacedTextEntry entry = gReplacedTextEntryList[i];
      while (entry.terminator != TERMINATOR)
      {
        if (entry.index == index)
        {
          String_CopyTo(gCurrentTextString, entry.textPointer);
          gCurrentTextIndex = (u16)(-1);
          return gCurrentTextString;
        }

        i += 1;
        entry = gReplacedTextEntryList[i];
      }

    }

    return GetStringFromIndex(index);
  }

// Intercepted vanilla calls to GetStringFromIndex

  // Dialogue-related

    Proc* StartDialogueFromIndex(int x, int y, int index)
    {
      return StartDialogue_(x, y, GetStringFromIndexIntercepted(index), NULL);
    }

    Proc* StartDialogueFromIndexWithParent(int x, int y, int index, Proc* parent)
    {
      return StartDialogue_(x, y, GetStringFromIndexIntercepted(index), parent);
    }

  // Difficulty selection screen

    typedef struct DifficultyTextProc DifficultyTextProc;

    #define TEXT_NEWLINE 0x01

    extern const u16 DifficultyDescriptions[3]; // = {0x0149, 0x014A, 0x014B};

    struct DifficultyTextProc {
      PROC_HEADER;
      u32 unk1;
      u8 difficulty;
      u32 unk3;
      struct TextHandle lines[5];
    };

    void DrawDifficultyDescription(DifficultyTextProc* proc)
    {
      /*
       * This function draws the description text for the selected
       * difficulty.
       */

      char* string;
      int i;
      TextHandle* lines;

      for (i = 0; i <= 4; i++)
      {
        Text_Clear(&proc->lines[i]);
      }

      i = 0;
      lines = proc->lines;

      string = GetStringFromIndexIntercepted(DifficultyDescriptions[proc->difficulty]);

      while (true)
      {
        if (*string == 0) return;
        else if (*string == TEXT_NEWLINE)
        {
          i++;
          string++;
        }
        else
        {
          string = Text_DrawChar_(&lines[i], string);
        }
      }
    }
