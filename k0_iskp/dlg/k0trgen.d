EXTEND_BOTTOM TRGENI01 35

IF ~Global("BD_HAVE_SOD","GLOBAL",1)
    Global("K0_SOD_IMPORT_30","GLOBAL",1)~

THEN DO ~GiveItemCreate("bdsw1h08",LastTalkedToBy,0,0,0)
         SetGlobal ("K0_SOD_IMPORT_30","GLOBAL",2)~ GOTO 36
END

EXTEND_BOTTOM TRGENI01 39

IF ~Global("BD_HAVE_SOD","GLOBAL",1)
    Global("K0_SOD_IMPORT_30","GLOBAL",1)~

THEN DO ~TakePartyItem("misc8k")
         GiveItemCreate("bdsw1h08",LastTalkedToBy,0,0,0)
         SetGlobal ("K0_SOD_IMPORT_30","GLOBAL",2)~ GOTO 36
END
