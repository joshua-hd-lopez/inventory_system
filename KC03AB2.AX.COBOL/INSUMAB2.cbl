       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. INSUMAB2.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.

       01  END-OF-SESSION-MESSAGE      PIC X(13) VALUE 'Session ended'. josh

       01  FILE-STATUS-INFO.
           02  CMF-OPEN                PIC X VALUE 'N'.
           02  CMF-OPEN-STATUS         PIC S9(8) COMP.
           02  CMF-ENABLE-STATUS       PIC S9(8) COMP.                  josh


      *
       01  SWITCHES.
      *
           05  INVOICE-EOF-SW          PIC X(01)    VALUE 'N'.
               88  INVOICE-EOF                      VALUE 'Y'.
           05  FIRST-RECORD-SW         PIC X(01)    VALUE 'Y'.
               88  FIRST-RECORD                     VALUE 'Y'.
      *
       01  WORK-FIELDS.
      *
           05  INVOICE-COUNT           PIC S9(05)    COMP-3  VALUE ZERO.
           05  INVOICE-TOTAL           PIC S9(07)V99 COMP-3  VALUE ZERO.
      *
       01  RESPONSE-CODE               PIC S9(08)    COMP.
      *
       COPY SUMSAB2.
      *
       COPY INVOICE.
      *
       COPY ERRPARM.
      *
       PROCEDURE DIVISION.
      *
       0000-PREPARE-INVOICE-SUMMARY.

            PERFORM 6000-OPEN-INV-FILE.


      *
           MOVE LOW-VALUE TO SUMMAP1O.
           PERFORM 1000-START-INVOICE-BROWSE.
           PERFORM 2000-READ-NEXT-INVOICE
               UNTIL INVOICE-EOF.
           PERFORM 3000-END-INVOICE-BROWSE.
           PERFORM 4000-SEND-SUMMARY-MAP.
      *
           EXEC CICS
               RETURN TRANSID('UAB2')
           END-EXEC.
      *
       1000-START-INVOICE-BROWSE.


      *
           MOVE 0 TO INV-INVOICE-NUMBER
      *
           EXEC CICS
               STARTBR FILE('INVAB2')
                       RIDFLD(INV-INVOICE-NUMBER)
                       RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE = DFHRESP(NOTFND)
               MOVE 'Y' TO INVOICE-EOF-SW
           ELSE
               IF RESPONSE-CODE NOT = DFHRESP(NORMAL)
                   PERFORM 9999-TERMINATE-PROGRAM
               END-IF
           END-IF.
      *
       2000-READ-NEXT-INVOICE.
      *
           EXEC CICS
               READNEXT FILE('INVAB2')
                        INTO(INVOICE-RECORD)
                        RIDFLD(INV-INVOICE-NUMBER)
                        RESP(RESPONSE-CODE)
           END-EXEC.
      *
           EVALUATE RESPONSE-CODE
               WHEN DFHRESP(NORMAL)
                   MOVE INV-INVOICE-NUMBER TO LASTO
                   ADD 1 TO INVOICE-COUNT
                   ADD INV-INVOICE-TOTAL TO INVOICE-TOTAL
                   IF FIRST-RECORD
                       MOVE INV-INVOICE-NUMBER TO FIRSTO
                       MOVE 'N' TO FIRST-RECORD-SW
                   END-IF
               WHEN DFHRESP(ENDFILE)
                   MOVE 'Y' TO INVOICE-EOF-SW
               WHEN OTHER
                   PERFORM 9999-TERMINATE-PROGRAM
           END-EVALUATE.
      *
       3000-END-INVOICE-BROWSE.
      *
           EXEC CICS
               ENDBR FILE('INVAB2')
                     RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE NOT = DFHRESP(NORMAL)
               PERFORM 9999-TERMINATE-PROGRAM
           END-IF.
      *
       4000-SEND-SUMMARY-MAP.


      *
           MOVE 'SAB2'        TO TRANIDO.
           MOVE INVOICE-COUNT TO COUNTO.
           MOVE INVOICE-TOTAL TO TOTALO.
      *
           EXEC CICS
               SEND MAP('SUMMAB2')
                    MAPSET('SUMSAB2')
                    FROM(SUMMAP1O)
                    ERASE
           END-EXEC.
      *

       6000-OPEN-INV-FILE.                                              josh

           EXEC CICS
               INQUIRE FILE('INVAB2')
                   OPENSTATUS(CMF-OPEN-STATUS)
                   ENABLESTATUS(CMF-ENABLE-STATUS)
           END-EXEC.

           IF CMF-OPEN-STATUS = DFHVALUE(CLOSED)
               EXEC CICS
                   SET FILE('INVAB2') OPEN
               END-EXEC
               MOVE 'Y' TO CMF-OPEN
           ELSE IF CMF-OPEN-STATUS = DFHVALUE(OPEN)
               NEXT SENTENCE
           ELSE
               EXEC CICS
                   ABEND ABCODE ('005')
               END-EXEC
           END-IF.

       9999-TERMINATE-PROGRAM.
      *
           MOVE EIBRESP  TO ERR-RESP.
           MOVE EIBRESP2 TO ERR-RESP2.
           MOVE EIBTRNID TO ERR-TRNID.
           MOVE EIBRSRCE TO ERR-RSRCE.
      *
           EXEC CICS
               XCTL PROGRAM('SYSERR')
                    COMMAREA(ERROR-PARAMETERS)
           END-EXEC.
