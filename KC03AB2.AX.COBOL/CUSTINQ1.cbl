       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  CMINQAB2.
       AUTHOR. JOSHUA LOPEZ.
       DATE-WRITTEN. 26/02/2021.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.

       01  END-OF-SESSION-MESSAGE      PIC X(13) VALUE 'Session ended'.

       01  FILE-STATUS-INFO.
           02  CMF-OPEN                PIC X VALUE 'N'.
           02  CMF-OPEN-STATUS         PIC S9(8) COMP.
           02  CMF-ENABLE-STATUS       PIC S9(8) COMP.

      *
       01  SWITCHES.
      *
           05  VALID-DATA-SW               PIC X    VALUE 'Y'.
               88 VALID-DATA                        VALUE 'Y'.
      *
       01  FLAGS.
      *
           05  SEND-FLAG                   PIC X.
               88  SEND-ERASE                       VALUE '1'.
               88  SEND-DATAONLY                    VALUE '2'.
               88  SEND-DATAONLY-ALARM              VALUE '3'.
      *
       01  COMMUNICATION-AREA              PIC X.
      *
       01  RESPONSE-CODE                   PIC S9(8)  COMP.
      *
       01  CUSTOMER-MASTER-RECORD.
      *
           05  CM-CUSTOMER-NUMBER            PIC X(6).
           05  CM-FIRST-NAME                 PIC X(20).
           05  CM-LAST-NAME                  PIC X(30).
           05  CM-ADDRESS                    PIC X(30).
           05  CM-CITY                       PIC X(20).
           05  CM-STATE                      PIC X(2).
           05  CM-ZIP-CODE                   PIC X(10).
      *
       COPY INQSAB2.
      *
       COPY DFHAID.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA                     PIC X.
      *
       PROCEDURE DIVISION.
      *
       0000-PROCESS-CUSTOMER-INQUIRY.
      *
           EVALUATE TRUE
      *
               WHEN EIBCALEN = ZERO
                   MOVE LOW-VALUE TO INQMAB2O
                   MOVE 'IAB2'    TO TRANIDO
                   SET SEND-ERASE TO TRUE
                   PERFORM 1400-SEND-CUSTOMER-MAP
      *
               WHEN EIBAID = DFHCLEAR
                   MOVE LOW-VALUE TO INQMAB2O
                   MOVE 'IAB2'    TO TRANIDO
                   SET SEND-ERASE TO TRUE
                   PERFORM 1400-SEND-CUSTOMER-MAP
      *
               WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
                   CONTINUE
      *
               WHEN EIBAID = DFHPF3 OR DFHPF12
      *             EXEC CICS
      *                    INQUIRE FILE('CMFAB2')
      *                        OPENSTATUS(CMF-OPEN-STATUS)
      *                        ENABLESTATUS(CMF-ENABLE-STATUS)
      *                END-EXEC
      *                IF CMF-OPEN-STATUS = DFHVALUE(OPEN)
      *                    EXEC CICS
      *                        SET FILE('CMFAB2') CLOSED
      *                    END-EXEC
      *                    MOVE 'N' TO CMF-OPEN
      *                END-IF
      *                PERFORM 2000-SEND-TERMINATION-MESSAGE
      *                EXEC CICS
      *                    RETURN
      *                END-EXEC
               WHEN EIBAID = DFHPF3 OR DFHPF12
                       EXEC CICS
                           XCTL PROGRAM('UUMENAB2')
                       END-EXEC
      *
               WHEN EIBAID = DFHENTER
                   PERFORM 1000-PROCESS-CUSTOMER-MAP
      *
               WHEN OTHER
                   MOVE LOW-VALUE TO INQMAB2O
                   MOVE 'Invalid key pressed.' TO MESSAGEO
                   SET SEND-DATAONLY-ALARM TO TRUE
                   PERFORM 1400-SEND-CUSTOMER-MAP
      *
           END-EVALUATE.
      *
           EXEC CICS
               RETURN TRANSID('IAB2')
                      COMMAREA(COMMUNICATION-AREA)
           END-EXEC.
      *
       1000-PROCESS-CUSTOMER-MAP.
      *
           PERFORM 1100-RECEIVE-CUSTOMER-MAP.
           PERFORM 1200-EDIT-CUSTOMER-DATA.
           IF VALID-DATA
               PERFORM 1300-GET-CUSTOMER-RECORD
           END-IF.
           IF VALID-DATA
               SET SEND-DATAONLY TO TRUE
               PERFORM 1400-SEND-CUSTOMER-MAP
           ELSE
               SET SEND-DATAONLY-ALARM TO TRUE
               PERFORM 1400-SEND-CUSTOMER-MAP
           END-IF.
      *
       1100-RECEIVE-CUSTOMER-MAP.
      *
           EXEC CICS
               RECEIVE MAP('INQMAB2')
                       MAPSET('INQSAB2')
                       INTO(INQMAB2I)
           END-EXEC.
      *
       1200-EDIT-CUSTOMER-DATA.
      *
           IF       CUSTNOL = ZERO
                 OR CUSTNOI = SPACE
               MOVE 'N' TO VALID-DATA-SW
               MOVE 'You must enter a customer number.' TO MESSAGEO
           END-IF.
      *
       1300-GET-CUSTOMER-RECORD.
      *
           PERFORM 1310-OPEN-CUST-FILE.

           EXEC CICS
               READ FILE('CMFAB2')
                    INTO(CUSTOMER-MASTER-RECORD)
                    RIDFLD(CUSTNOI)
                    RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE = DFHRESP(NORMAL)
               MOVE SPACE         TO MESSAGEO
               MOVE CM-LAST-NAME  TO LNAMEO
               MOVE CM-FIRST-NAME TO FNAMEO
               MOVE CM-ADDRESS    TO ADDRO
               MOVE CM-CITY       TO CITYO
               MOVE CM-STATE      TO STATEO
               MOVE CM-ZIP-CODE   TO ZIPCODEO
           ELSE IF RESPONSE-CODE = DFHRESP(NOTFND)
               MOVE 'N' TO VALID-DATA-SW
               MOVE 'That customer does not exist.' TO MESSAGEO
               MOVE SPACE TO LNAMEO
                             FNAMEO
                             ADDRO
                             CITYO
                             STATEO
                             ZIPCODEO
           ELSE
               EXEC CICS
                   ABEND ABCODE ('004')
               END-EXEC
           END-IF.
      *

       1310-OPEN-CUST-FILE.

           EXEC CICS
               INQUIRE FILE('CMFAB2')
                   OPENSTATUS(CMF-OPEN-STATUS)
                   ENABLESTATUS(CMF-ENABLE-STATUS)
           END-EXEC.

           IF CMF-OPEN-STATUS = DFHVALUE(CLOSED)
               EXEC CICS
                   SET FILE('CMFAB2') OPEN
               END-EXEC
               MOVE 'Y' TO CMF-OPEN
           ELSE IF CMF-OPEN-STATUS = DFHVALUE(OPEN)
               NEXT SENTENCE
           ELSE
               EXEC CICS
                   ABEND ABCODE ('005')
               END-EXEC
           END-IF.



       1400-SEND-CUSTOMER-MAP.
      *
           EVALUATE TRUE
               WHEN SEND-ERASE
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAB2O)
                            ERASE
                       END-EXEC
               WHEN SEND-DATAONLY
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAB2O)
                            DATAONLY
                       END-EXEC
               WHEN SEND-DATAONLY-ALARM
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAB2O)
                            DATAONLY
                            ALARM
                       END-EXEC
           END-EVALUATE.

       2000-SEND-TERMINATION-MESSAGE.
      *
              EXEC CICS
                  SEND TEXT FROM(END-OF-SESSION-MESSAGE)
                         ERASE
                         FREEKB
              END-EXEC.
      *

