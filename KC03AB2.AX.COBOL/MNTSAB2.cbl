       01  MNT1AB2I.
           02  FILLER PIC X(12).
           02  TRANID1L    COMP  PIC  S9(4).
           02  TRANID1F    PICTURE X.
           02  FILLER REDEFINES TRANID1F.
             03 TRANID1A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  TRANID1I  PIC X(4).
           02  CUSTNO1L    COMP  PIC  S9(4).
           02  CUSTNO1F    PICTURE X.
           02  FILLER REDEFINES CUSTNO1F.
             03 CUSTNO1A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  CUSTNO1I  PIC X(6).
           02  ACTIONL    COMP  PIC  S9(4).
           02  ACTIONF    PICTURE X.
           02  FILLER REDEFINES ACTIONF.
             03 ACTIONA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  ACTIONI  PIC X(1).
           02  MSG1L    COMP  PIC  S9(4).
           02  MSG1F    PICTURE X.
           02  FILLER REDEFINES MSG1F.
             03 MSG1A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  MSG1I  PIC X(79).
           02  DUMMY1L    COMP  PIC  S9(4).
           02  DUMMY1F    PICTURE X.
           02  FILLER REDEFINES DUMMY1F.
             03 DUMMY1A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  DUMMY1I  PIC X(1).
       01  MNT1AB2O REDEFINES MNT1AB2I.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  TRANID1C    PICTURE X.
           02  TRANID1H    PICTURE X.
           02  TRANID1O  PIC X(4).
           02  FILLER PICTURE X(3).
           02  CUSTNO1C    PICTURE X.
           02  CUSTNO1H    PICTURE X.
           02  CUSTNO1O  PIC X(6).
           02  FILLER PICTURE X(3).
           02  ACTIONC    PICTURE X.
           02  ACTIONH    PICTURE X.
           02  ACTIONO  PIC X(1).
           02  FILLER PICTURE X(3).
           02  MSG1C    PICTURE X.
           02  MSG1H    PICTURE X.
           02  MSG1O  PIC X(79).
           02  FILLER PICTURE X(3).
           02  DUMMY1C    PICTURE X.
           02  DUMMY1H    PICTURE X.
           02  DUMMY1O  PIC X(1).
       01  MNT2AB2I.
           02  FILLER PIC X(12).
           02  TRANID2L    COMP  PIC  S9(4).
           02  TRANID2F    PICTURE X.
           02  FILLER REDEFINES TRANID2F.
             03 TRANID2A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  TRANID2I  PIC X(4).
           02  INSTR2L    COMP  PIC  S9(4).
           02  INSTR2F    PICTURE X.
           02  FILLER REDEFINES INSTR2F.
             03 INSTR2A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  INSTR2I  PIC X(79).
           02  CUSTNO2L    COMP  PIC  S9(4).
           02  CUSTNO2F    PICTURE X.
           02  FILLER REDEFINES CUSTNO2F.
             03 CUSTNO2A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  CUSTNO2I  PIC X(6).
           02  LNAMEL    COMP  PIC  S9(4).
           02  LNAMEF    PICTURE X.
           02  FILLER REDEFINES LNAMEF.
             03 LNAMEA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  LNAMEI  PIC X(30).
           02  FNAMEL    COMP  PIC  S9(4).
           02  FNAMEF    PICTURE X.
           02  FILLER REDEFINES FNAMEF.
             03 FNAMEA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  FNAMEI  PIC X(20).
           02  ADDRL    COMP  PIC  S9(4).
           02  ADDRF    PICTURE X.
           02  FILLER REDEFINES ADDRF.
             03 ADDRA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  ADDRI  PIC X(30).
           02  CITYL    COMP  PIC  S9(4).
           02  CITYF    PICTURE X.
           02  FILLER REDEFINES CITYF.
             03 CITYA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  CITYI  PIC X(20).
           02  STATEL    COMP  PIC  S9(4).
           02  STATEF    PICTURE X.
           02  FILLER REDEFINES STATEF.
             03 STATEA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  STATEI  PIC X(2).
           02  ZIPCODEL    COMP  PIC  S9(4).
           02  ZIPCODEF    PICTURE X.
           02  FILLER REDEFINES ZIPCODEF.
             03 ZIPCODEA    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  ZIPCODEI  PIC X(10).
           02  MSG2L    COMP  PIC  S9(4).
           02  MSG2F    PICTURE X.
           02  FILLER REDEFINES MSG2F.
             03 MSG2A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  MSG2I  PIC X(79).
           02  DUMMY2L    COMP  PIC  S9(4).
           02  DUMMY2F    PICTURE X.
           02  FILLER REDEFINES DUMMY2F.
             03 DUMMY2A    PICTURE X.
           02  FILLER   PICTURE X(2).
           02  DUMMY2I  PIC X(1).
       01  MNT2AB2O REDEFINES MNT2AB2I.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  TRANID2C    PICTURE X.
           02  TRANID2H    PICTURE X.
           02  TRANID2O  PIC X(4).
           02  FILLER PICTURE X(3).
           02  INSTR2C    PICTURE X.
           02  INSTR2H    PICTURE X.
           02  INSTR2O  PIC X(79).
           02  FILLER PICTURE X(3).
           02  CUSTNO2C    PICTURE X.
           02  CUSTNO2H    PICTURE X.
           02  CUSTNO2O  PIC X(6).
           02  FILLER PICTURE X(3).
           02  LNAMEC    PICTURE X.
           02  LNAMEH    PICTURE X.
           02  LNAMEO  PIC X(30).
           02  FILLER PICTURE X(3).
           02  FNAMEC    PICTURE X.
           02  FNAMEH    PICTURE X.
           02  FNAMEO  PIC X(20).
           02  FILLER PICTURE X(3).
           02  ADDRC    PICTURE X.
           02  ADDRH    PICTURE X.
           02  ADDRO  PIC X(30).
           02  FILLER PICTURE X(3).
           02  CITYC    PICTURE X.
           02  CITYH    PICTURE X.
           02  CITYO  PIC X(20).
           02  FILLER PICTURE X(3).
           02  STATEC    PICTURE X.
           02  STATEH    PICTURE X.
           02  STATEO  PIC X(2).
           02  FILLER PICTURE X(3).
           02  ZIPCODEC    PICTURE X.
           02  ZIPCODEH    PICTURE X.
           02  ZIPCODEO  PIC X(10).
           02  FILLER PICTURE X(3).
           02  MSG2C    PICTURE X.
           02  MSG2H    PICTURE X.
           02  MSG2O  PIC X(79).
           02  FILLER PICTURE X(3).
           02  DUMMY2C    PICTURE X.
           02  DUMMY2H    PICTURE X.
           02  DUMMY2O  PIC X(1).