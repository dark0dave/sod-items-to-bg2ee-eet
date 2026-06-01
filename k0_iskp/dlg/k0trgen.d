EXTEND_BOTTOM TRGENI01 35
  IF ~Global("K0_ITEMS_BDSW1H08","GLOBAL",0)~
    THEN DO ~GiveItemCreate("bdsw1h08",LastTalkedToBy,0,0,0)
    SetGlobal ("K0_ITEMS_BDSW1H08","GLOBAL",1)~ GOTO 36
END

EXTEND_BOTTOM TRGENI01 39
  IF ~Global("K0_ITEMS_BDSW1H08","GLOBAL",0)~
    THEN DO ~TakePartyItem("misc8k")
    GiveItemCreate("bdsw1h08",LastTalkedToBy,0,0,0)
    SetGlobal ("K0_ITEMS_BDSW1H08","GLOBAL",1)~ GOTO 36
END
