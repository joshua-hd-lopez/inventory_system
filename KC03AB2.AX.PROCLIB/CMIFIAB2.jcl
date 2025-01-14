//******************************************************************
//*      This procedure, CICSCOBL, contains 4 steps
//*      1.   Exec the Cics translator
//*      2.   Exec the AD/Cycle VS COBOL II compiler
//*      3.   Reblock SDFHCOB(&STUB) for use by the linkedit step
//*      4.   Linkedit the output
//******************************************************************
//CMIFIAB2 PROC SUFFIX=1$,           Suffix for translator module
//       INDEX='DFH540.CICS',        QUALIFIER(S) FOR CICS LIBRARIES
//       NEWINDEX='DFH540.CICS',   QUALIFIER(S) FOR CICS LIBRARIES
//       STUDLIB='KC03AB2.AX.COBOL', NAME OF STUDENT SOURCE
//       MEMBER='INSUMAB2',
//       LOADLIB='TSOECCC.CICSTS12.STUDENT.LOADLIB', CICS LOADLIB
//       LE370HLQ='CEE',             Qualifier(s) for LE/370 libraries
//       OUTC='*',                   Class for print output
//       REG='0M',                     REGION SIZE FOR ALL STEPS
//       LNKPARM='LIST,XREF,MAP',    Link edit parameters
//       STUB='DFHEILIC',            Linkedit INCLUDE for DFHELII
//       WORK='SYSDA'                  Unit for work datasets
//******************************************************************
//*    TRANSLATE THE COBOL/CICS PROGRAM
//******************************************************************
//TRN    EXEC PGM=DFHECP&SUFFIX,
//            PARM=('APOST,DEBUG,COBOL3,FLAGW,NOSEQ',
//            'NONUM,LIST,NOXREF,SPACE1,CICS,SP'),
//            REGION=&REG
//STEPLIB  DD DSN=&NEWINDEX..SDFHLOAD,DISP=SHR
//SYSPRINT DD SYSOUT=&OUTC
//SYSIN    DD DSN=&STUDLIB(&MEMBER),DISP=SHR
//SYSPUNCH DD DSN=&&SYSCIN,
//            DISP=(,PASS),UNIT=&WORK,
//            DCB=BLKSIZE=400,
//            SPACE=(400,(400,100))
//******************************************************************
//*    COMPILE THE COBOL/CICS PROGRAM
//******************************************************************
//*
//*
//*  07/23/15 REMOVED THE LIB PARM
//COB    EXEC PGM=IGYCRCTL,REGION=&REG,
//*       PARM='NODYNAM,OBJECT,RENT,APOST,MAP,XREF,VBREF,OFFSET'
//*       PARM='RENT,APOST,OBJECT,NODYNAM,SIZE(1048376)'
//        PARM='NOXREF,NODBCS,APOST,OBJECT,NODYNAM'
//*STEPLIB  DD DSN=IGY.SIGYCOMP,DISP=SHR
//SYSLIB   DD DSN=&STUDLIB,DISP=SHR
//*         DD DSN=&STUDLIB..SOURCE,DISP=SHR
//*         DD DSN=&STUDLIB..SHARED.COPYBLKS,DISP=SHR
//         DD DSN=&INDEX..SDFHCOB,DISP=SHR
//        DD DSN=&INDEX..SDFHMAC,DISP=SHR
//         DD DSN=&INDEX..SDFHSAMP,DISP=SHR
//SYSPRINT DD SYSOUT=&OUTC
//SYSIN    DD DSN=&&SYSCIN,DISP=(OLD,DELETE)
//*  07/23/15 NEW SYSLIN & ADDED SYSMDECK & ADDITIONAL SYSUT DDS
//SYSLIN   DD DSN=&&LOADSET,DISP=(MOD,PASS),
//            UNIT=&WORK,SPACE=(CYL,(1,1))
//SYSMDECK DD SPACE=(1024,(5,5)), AVGREC=K
//            DCB=(LRECL=80,RECFM=F)
//SYSUT1   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT2   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT3   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT4   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT5   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT6   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT7   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT8   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT9   DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT10  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT11  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT12  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT13  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT14  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//SYSUT15  DD UNIT=&WORK,SPACE=(1024,(5,5)),AVGREC=K
//*
//******************************************************************
//*    COPY THE COBOL/CICS PROGRAM BEFORE LINK EDIT
//******************************************************************
//COPYLINK EXEC PGM=IEBGENER,COND=(7,LT,COB)
//SYSUT1   DD DSN=&INDEX..SDFHCOB(&STUB),DISP=SHR
//SYSUT2   DD DSN=&&COPYLINK,DISP=(NEW,PASS),
//            DCB=(LRECL=80,BLKSIZE=400,RECFM=FB),
//            UNIT=&WORK,SPACE=(400,(20,20))
//SYSPRINT DD SYSOUT=&OUTC
//SYSIN    DD DUMMY
//*
//******************************************************************
//*    LINK EDIT THE COBOL/CICS PROGRAM
//******************************************************************
//LKED   EXEC PGM=IEWL,REGION=&REG,
//            PARM='&LNKPARM',COND=(5,LT,COB)
//SYSLIB   DD DSN=&LOADLIB,DISP=SHR
//*         DD DSN=&STUDLIB..SUBPLIB,DISP=SHR
//*         DD DSN=&STUDLIB..SHARED.LOADLIB,DISP=SHR
//         DD DSN=&LOADLIB(INTEDIT),DISP=SHR
//         DD DSN=&LOADLIB(NUMEDIT),DISP=SHR
//         DD DSN=&NEWINDEX..SDFHLOAD,DISP=SHR
//         DD DSN=&LE370HLQ..SCEELKED,DISP=SHR
//SYSLMOD  DD DSN=&LOADLIB.(&MEMBER),DISP=SHR
//SYSUT1   DD UNIT=&WORK,DCB=BLKSIZE=1024,
//            SPACE=(1024,(200,20))
//SYSPRINT DD SYSOUT=&OUTC
//SYSLIN   DD DSN=&&COPYLINK,DISP=(OLD,DELETE)
//         DD DSN=&&LOADSET,DISP=(OLD,DELETE)
//*        DD DDNAME=SYSIN
//*  07/23/15  removed the sysin dd