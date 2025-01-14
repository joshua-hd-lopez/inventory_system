//CMFLOAB2         JOB
/* COMPILE/LKED/EX VSAM DATA LOAD
//COBOL            EXEC PROC=IGYWCL,REGION=50M,
//    PARM.COBOL='TEST,RENT,APOST,OBJECT,NODYNAM,LIB,SIZE(2097152)'
//COBOL.STEPLIB DD DSN=IGY420.SIGYCOMP,
//    DISP=SHR
/* DECLARE DATASET THAT CONTAINS SOURCE CODE
//COBOL.SYSIN DD DSN=KC03AB2.AX.COBOL(CMFLOAB2),DISP=SHR
/*
/* DECLARE PDS MEMBER TO STORE LOAD MODULE
//LKED.SYSLMOD DD DSN=KC03AB2.COBOL.LOADLIB(CMFLOAB2),
//    DISP=OLD
/*
//CMFLOAD  EXEC PGM=CMFLOAB2
/*
//STEPLIB  DD DSN=KC03AB2.COBOL.LOADLIB,DISP=SHR
//CMDATA   DD DSN=KC03AB2.AX.CUSTMAS.DATA,DISP=SHR
//OUTFILE  DD DSN=KC03AB2.AX.CICS.CMFAB2,DISP=SHR