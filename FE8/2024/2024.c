
#include "gbafe.h"

// Make nonplayer unit ranges unviewable

  enum
  {
      PLAYER_SELECT_NOUNIT     = 0,
      PLAYER_SELECT_TURNENDED  = 1,
      PLAYER_SELECT_CONTROL    = 2,
      PLAYER_SELECT_NOCONTROL  = 3,
      PLAYER_SELECT_4          = 4,
  };

  enum BmSt_gameStateBits
  {
    BM_FLAG_0 = (1 << 0),
    BM_FLAG_1 = (1 << 1),
    BM_FLAG_2 = (1 << 2),
    BM_FLAG_3 = (1 << 3),
    BM_FLAG_4 = (1 << 4),
    BM_FLAG_5 = (1 << 5),   /* Maybe mute battle-anim BGM ? */
    BM_FLAG_LINKARENA = (1 << 6),
  };

  bool CanCharacterBePrepMoved(int unitId);
  u8 IsDifficultMode(void);

  int GetUnitSelectionValueThing(struct Unit * unit)
  {
    /*
     * FE8U calls this `GetPlayerSelectKind`.
     *
     * This returns what type of unit was just selected.
     * We're going to edit this to make it so that you can't select
     * units that aren't part of your faction on hard mode.
     */

    u8 faction = gChapterData.currentPhase;

    if (!unit)
    {
      return PLAYER_SELECT_NOUNIT;
    }

    if (gGameState.statebits & BM_FLAG_4)
    {
      if (!CanCharacterBePrepMoved(unit->pCharacterData->number))
      {
        return PLAYER_SELECT_4;
      }

      faction = FACTION_BLUE;
    }

    if (!unit)
    {
      return PLAYER_SELECT_NOUNIT;
    }

    if (UNIT_FACTION(unit) != faction)
    {

      if ( IsDifficultMode() )
        return PLAYER_SELECT_NOUNIT;

      return PLAYER_SELECT_NOCONTROL;
    }

    if (unit->state & US_UNSELECTABLE)
    {
      return PLAYER_SELECT_TURNENDED;
    }

    if (UNIT_CATTRIBUTES(unit) & CA_UNSELECTABLE)
    {
      return PLAYER_SELECT_TURNENDED;
    }

    if ((unit->statusIndex != UNIT_STATUS_SLEEP) && (unit->statusIndex != UNIT_STATUS_BERSERK))
    {
      return PLAYER_SELECT_CONTROL;
    }

    return PLAYER_SELECT_NOCONTROL;
  }

// Remove the weapon triangle on hard mode

  struct WeaponTriangleRule {
      s8 attackerWeaponType;
      s8 defenderWeaponType;
      s8 hitBonus;
      s8 atkBonus;
  };

  extern struct WeaponTriangleRule sWeaponTriangleRules[];
  void BattleApplyReaverEffect(struct BattleUnit* attacker, struct BattleUnit* defender);

  void BattleApplyWeaponTriangleEffect(struct BattleUnit* attacker, struct BattleUnit* defender)
  {
    /*
     * This checks for weapon triangle effects and adjusts hit rates.
     * We're going to make it so that the triangle doesn't apply on hard mode.
     */

    if ( IsDifficultMode() )
      return;

    const struct WeaponTriangleRule* it;

    for (it = sWeaponTriangleRules; it->attackerWeaponType >= 0; ++it) {
      if ((attacker->weaponType == it->attackerWeaponType) && (defender->weaponType == it->defenderWeaponType)) {
        attacker->wTriangleHitBonus = it->hitBonus;
        attacker->wTriangleDmgBonus = it->atkBonus;

        defender->wTriangleHitBonus = -it->hitBonus;
        defender->wTriangleDmgBonus = -it->atkBonus;

        break;
      }
    }

    if (attacker->weaponAttributes & IA_REVERTTRIANGLE)
      BattleApplyReaverEffect(attacker, defender);

    if (defender->weaponAttributes & IA_REVERTTRIANGLE)
      BattleApplyReaverEffect(attacker, defender);
  }
