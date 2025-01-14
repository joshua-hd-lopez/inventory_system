//INVCLAB2  JOB
/*
/* FIX NAME, DATA NAME, AND INDEX NAME TO MATCH NAMING CONVENTIONS
/* FIX KEYS, AND RECSZ TO MATCH RECORD LAYOUT REQUIRED
/* FIX KC03YYY TO YOUR USERID KC03ABC
/* FIX CMFYYY TO YOUR USERID PATTERN I.E. CMFABC
/*
//DEFCLST EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
   DEFINE CLUSTER ( -
   NAME(KC03AB2.AX.CICS.INVAB2)  -
   INDEXED                                 -
   KEYS(6 0)                             -
   RECSZ(389 389)                            -
   TRACKS(1,1)                             -
   CISZ(4096)                              -
   FREESPACE(3 3) )                        -
   DATA (NAME(KC03AB2.AX.CICS.INVAB2.DATA))      -
   INDEX (NAME(KC03AB2.AX.CICS.INVAB2.INDEX))
/*