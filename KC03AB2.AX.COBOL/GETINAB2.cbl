       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  GETINAB2.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  FILE-STATUS-INFO.
           02  INVCTL-OPEN                PIC X VALUE 'N'.
           02  INVCTL-OPEN-STATUS         PIC S9(8) COMP.
           02  INVCTL-ENABLE-STATUS       PIC S9(8) COMP.


       COPY INVCTL.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA   PIC 9(06).
      *
       PROCEDURE DIVISION.
      *
       0000-GET-INVOICE-NUMBER.


           EXEC CICS                                                    JOSH
               INQUIRE FILE('CTLAB2')
                   OPENSTATUS(INVCTL-OPEN-STATUS)
                   ENABLESTATUS(INVCTL-ENABLE-STATUS)
           END-EXEC.

           IF INVCTL-OPEN-STATUS = DFHVALUE(CLOSED)
               EXEC CICS
                   SET FILE('CTLAB2') OPEN
               END-EXEC
               MOVE 'Y' TO INVCTL-OPEN
           ELSE IF INVCTL-OPEN-STATUS = DFHVALUE(OPEN)
               NEXT SENTENCE
           ELSE
               EXEC CICS
                   ABEND ABCODE (115)
               END-EXEC
           END-IF.                                                      JOSH
      *
           MOVE ZERO TO INVCTL-RECORD-KEY.
           EXEC CICS
               READ FILE('CTLAB2')
                    INTO(INVCTL-RECORD)
                    RIDFLD(INVCTL-RECORD-KEY)
                    UPDATE
           END-EXEC.
           MOVE INVCTL-NEXT-INVOICE-NUMBER TO DFHCOMMAREA.
           ADD 1 TO INVCTL-NEXT-INVOICE-NUMBER.
           EXEC CICS
               REWRITE FILE('CTLAB2')
                       FROM(INVCTL-RECORD)
           END-EXEC.
           EXEC CICS
               RETURN
           END-EXEC.


