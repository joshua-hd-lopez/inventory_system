       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  CMINQAB2.
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
           05  VALID-DATA-SW               PIC X(01)  VALUE 'Y'.
               88  VALID-DATA                         VALUE 'Y'.
           05  CUSTOMER-FOUND-SW           PIC X(01)  VALUE 'Y'.
               88  CUSTOMER-FOUND                     VALUE 'Y'.
      *
       01  FLAGS.
      *
           05  DISPLAY-FLAG                PIC X(01).
               88  DISPLAY-NEW-CUSTOMER               VALUE '1'.
               88  DISPLAY-SPACES                     VALUE '2'.
               88  DISPLAY-LOW-VALUES                 VALUE '3'.
           05  SEND-FLAG                   PIC X(01).
               88  SEND-ERASE                         VALUE '1'.
               88  SEND-DATAONLY                      VALUE '2'.
               88  SEND-DATAONLY-ALARM                VALUE '3'.
      *
       01  COMMUNICATION-AREA.
      *
           05  CA-CUSTOMER-NUMBER          PIC X(06).
      *
       01  RESPONSE-CODE                   PIC S9(08) COMP.
      *
       COPY CUSTMAS.
      *
       COPY INQSAB2.
      *
       COPY DFHAID.
      *
       COPY ERRPARM.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA                     PIC X(06).
      *
       PROCEDURE DIVISION.
      *
       0000-PROCESS-CUSTOMER-INQUIRY.
      *
           IF EIBCALEN > ZERO
               MOVE DFHCOMMAREA TO COMMUNICATION-AREA
           END-IF.
      *
           EVALUATE TRUE
      *
               WHEN EIBCALEN = ZERO
                   MOVE LOW-VALUE TO CA-CUSTOMER-NUMBER
                   MOVE LOW-VALUE TO INQMAP2O
                   SET SEND-ERASE TO TRUE
                   PERFORM 1500-SEND-INQUIRY-MAP
      *
               WHEN EIBAID = DFHCLEAR
                   MOVE LOW-VALUE TO CA-CUSTOMER-NUMBER
                   MOVE LOW-VALUE TO INQMAP2O
                   SET SEND-ERASE TO TRUE
                   PERFORM 1500-SEND-INQUIRY-MAP
      *
               WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
                   CONTINUE
      *
               WHEN EIBAID = DFHPF3 OR DFHPF12
                   EXEC CICS
                       XCTL PROGRAM('UUMENAB2')
                   END-EXEC
      *
               WHEN EIBAID = DFHENTER
                   PERFORM 1000-DISPLAY-SELECTED-CUSTOMER
      *
               WHEN EIBAID = DFHPF5
                   PERFORM 2000-DISPLAY-FIRST-CUSTOMER
      *
               WHEN EIBAID = DFHPF6
                   PERFORM 3000-DISPLAY-LAST-CUSTOMER
      *
               WHEN EIBAID = DFHPF7
                   PERFORM 4000-DISPLAY-PREV-CUSTOMER
      *
               WHEN EIBAID = DFHPF8
                   PERFORM 5000-DISPLAY-NEXT-CUSTOMER
      *
               WHEN OTHER
                   MOVE LOW-VALUE TO INQMAP2O
                   MOVE 'Invalid key pressed.' TO MESSAGEO
                   SET SEND-DATAONLY-ALARM TO TRUE
                   PERFORM 1500-SEND-INQUIRY-MAP
      *
           END-EVALUATE.
      *
           EXEC CICS
               RETURN TRANSID('IAB2')
                      COMMAREA(COMMUNICATION-AREA)
           END-EXEC.
      *
       1000-DISPLAY-SELECTED-CUSTOMER.
      *
           PERFORM 1100-RECEIVE-INQUIRY-MAP.
           PERFORM 1200-EDIT-CUSTOMER-NUMBER.
           IF VALID-DATA
               PERFORM 1300-READ-CUSTOMER-RECORD
               IF CUSTOMER-FOUND
                   SET DISPLAY-NEW-CUSTOMER TO TRUE
                   PERFORM 1400-DISPLAY-INQUIRY-RESULTS
                   MOVE CM-CUSTOMER-NUMBER TO CA-CUSTOMER-NUMBER
               ELSE
                   SET DISPLAY-SPACES TO TRUE
                   PERFORM 1400-DISPLAY-INQUIRY-RESULTS
               END-IF
           ELSE
               SET DISPLAY-LOW-VALUES TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
           END-IF.
      *
       1100-RECEIVE-INQUIRY-MAP.
      *
           EXEC CICS
               RECEIVE MAP('INQMAB2')
                       MAPSET('INQSAB2')
                       INTO(INQMAP2I)
           END-EXEC.
      *
           INSPECT INQMAP2I
               REPLACING ALL '_' BY SPACE.
      *
       1200-EDIT-CUSTOMER-NUMBER.
      *
           IF       CUSTNOL = ZERO
                 OR CUSTNOI = SPACE
               MOVE 'N' TO VALID-DATA-SW
               MOVE 'You must enter a customer number.' TO MESSAGEO
           END-IF.
      *
       1300-READ-CUSTOMER-RECORD.

           PERFORM 6000-OPEN-CUST-FILE.                                 JOSH
      *
           EXEC CICS
               READ FILE('CMFAB2')
                    INTO(CUSTOMER-MASTER-RECORD)
                    RIDFLD(CUSTNOI)
                    RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE = DFHRESP(NOTFND)
               MOVE 'N' TO CUSTOMER-FOUND-SW
               MOVE 'That customer does not exist.' TO MESSAGEO
           ELSE
               IF RESPONSE-CODE NOT = DFHRESP(NORMAL)
                   PERFORM 9999-TERMINATE-PROGRAM
               END-IF
           END-IF.
      *



       1400-DISPLAY-INQUIRY-RESULTS.
      *
           IF DISPLAY-NEW-CUSTOMER
               MOVE CM-CUSTOMER-NUMBER TO CUSTNOO
               MOVE CM-LAST-NAME       TO LNAMEO
               MOVE CM-FIRST-NAME      TO FNAMEO
               MOVE CM-ADDRESS         TO ADDRO
               MOVE CM-CITY            TO CITYO
               MOVE CM-STATE           TO STATEO
               MOVE CM-ZIP-CODE        TO ZIPCODEO
               MOVE SPACE              TO MESSAGEO
               SET SEND-DATAONLY       TO TRUE
           ELSE
               IF DISPLAY-SPACES
                   MOVE LOW-VALUE TO CUSTNOO
                   MOVE SPACE     TO LNAMEO
                                     FNAMEO
                                     ADDRO
                                     CITYO
                                     STATEO
                                     ZIPCODEO
                   SET SEND-DATAONLY-ALARM TO TRUE
               ELSE
                   IF DISPLAY-LOW-VALUES
                       SET SEND-DATAONLY-ALARM TO TRUE
                   END-IF
               END-IF
           END-IF.
      *
           PERFORM 1500-SEND-INQUIRY-MAP.
      *
       1500-SEND-INQUIRY-MAP.
      *
           MOVE 'IAB2' TO TRANIDO.
      *
           EVALUATE TRUE
               WHEN SEND-ERASE
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAP2O)
                            ERASE
                   END-EXEC
               WHEN SEND-DATAONLY
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAP2O)
                            DATAONLY
                   END-EXEC
               WHEN SEND-DATAONLY-ALARM
                   EXEC CICS
                       SEND MAP('INQMAB2')
                            MAPSET('INQSAB2')
                            FROM(INQMAP2O)
                            DATAONLY
                            ALARM
                   END-EXEC
           END-EVALUATE.
      *
       2000-DISPLAY-FIRST-CUSTOMER.
      *
           MOVE LOW-VALUE TO CM-CUSTOMER-NUMBER
                             INQMAP2O.
           PERFORM 2100-START-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               PERFORM 2200-READ-NEXT-CUSTOMER
           END-IF.
           PERFORM 2300-END-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               SET DISPLAY-NEW-CUSTOMER TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
               MOVE CM-CUSTOMER-NUMBER TO CA-CUSTOMER-NUMBER
           ELSE
               SET DISPLAY-SPACES TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
           END-IF.
      *
       2100-START-CUSTOMER-BROWSE.
      *
           EXEC CICS
               STARTBR FILE('CMFAB2')
                       RIDFLD(CM-CUSTOMER-NUMBER)
                       RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE = DFHRESP(NORMAL)
               MOVE 'Y' TO CUSTOMER-FOUND-SW
               MOVE SPACE TO MESSAGEO
           ELSE
               IF RESPONSE-CODE = DFHRESP(NOTFND)
                   MOVE 'N' TO CUSTOMER-FOUND-SW
                   MOVE 'There are no customers in the file.'
                       TO MESSAGEO
               ELSE
                   PERFORM 9999-TERMINATE-PROGRAM
               END-IF
           END-IF.
      *
       2200-READ-NEXT-CUSTOMER.
      *
           EXEC CICS
               READNEXT FILE('CMFAB2')
                        INTO(CUSTOMER-MASTER-RECORD)
                        RIDFLD(CM-CUSTOMER-NUMBER)
                        RESP(RESPONSE-CODE)
           END-EXEC.
      *
           EVALUATE RESPONSE-CODE
               WHEN DFHRESP(NORMAL)
                   MOVE 'Y' TO CUSTOMER-FOUND-SW
               WHEN DFHRESP(ENDFILE)
                   MOVE 'N' TO CUSTOMER-FOUND-SW
                   MOVE 'There are no more records in the file.'
                       TO MESSAGEO
               WHEN OTHER
                   PERFORM 9999-TERMINATE-PROGRAM
           END-EVALUATE.
      *
       2300-END-CUSTOMER-BROWSE.
      *
           EXEC CICS
               ENDBR FILE('CMFAB2')
                     RESP(RESPONSE-CODE)
           END-EXEC.
      *
           IF RESPONSE-CODE NOT = DFHRESP(NORMAL)
               PERFORM 9999-TERMINATE-PROGRAM
           END-IF.
      *
       3000-DISPLAY-LAST-CUSTOMER.
      *
           MOVE HIGH-VALUE TO CM-CUSTOMER-NUMBER.
           MOVE LOW-VALUE  TO INQMAP2O.
           PERFORM 2100-START-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               PERFORM 3100-READ-PREV-CUSTOMER
           END-IF.
           PERFORM 2300-END-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               SET DISPLAY-NEW-CUSTOMER TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
               MOVE CM-CUSTOMER-NUMBER TO CA-CUSTOMER-NUMBER
           ELSE
               SET DISPLAY-SPACES TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
           END-IF.
      *
       3100-READ-PREV-CUSTOMER.
      *
           EXEC CICS
               READPREV FILE('CMFAB2')
                        INTO(CUSTOMER-MASTER-RECORD)
                        RIDFLD(CM-CUSTOMER-NUMBER)
                        RESP(RESPONSE-CODE)
           END-EXEC.
      *
           EVALUATE RESPONSE-CODE
               WHEN DFHRESP(NORMAL)
                   MOVE 'Y' TO CUSTOMER-FOUND-SW
               WHEN DFHRESP(ENDFILE)
                   MOVE 'N' TO CUSTOMER-FOUND-SW
                   MOVE 'There are no more records in the file.'
                       TO MESSAGEO
               WHEN OTHER
                   PERFORM 9999-TERMINATE-PROGRAM
           END-EVALUATE.
      *
       4000-DISPLAY-PREV-CUSTOMER.
      *
           MOVE CA-CUSTOMER-NUMBER TO CM-CUSTOMER-NUMBER.
           MOVE LOW-VALUE          TO INQMAP2O.
           PERFORM 2100-START-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               PERFORM 2200-READ-NEXT-CUSTOMER
               PERFORM 3100-READ-PREV-CUSTOMER
               PERFORM 3100-READ-PREV-CUSTOMER
           END-IF.
           PERFORM 2300-END-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               SET DISPLAY-NEW-CUSTOMER TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
               MOVE CM-CUSTOMER-NUMBER TO CA-CUSTOMER-NUMBER
           ELSE
               SET DISPLAY-LOW-VALUES TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
           END-IF.
      *
       5000-DISPLAY-NEXT-CUSTOMER.
      *
           MOVE CA-CUSTOMER-NUMBER TO CM-CUSTOMER-NUMBER.
           MOVE LOW-VALUE          TO INQMAP2O.
           PERFORM 2100-START-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               PERFORM 2200-READ-NEXT-CUSTOMER
               PERFORM 2200-READ-NEXT-CUSTOMER
           END-IF.
           PERFORM 2300-END-CUSTOMER-BROWSE.
           IF CUSTOMER-FOUND
               SET DISPLAY-NEW-CUSTOMER TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
               MOVE CM-CUSTOMER-NUMBER TO CA-CUSTOMER-NUMBER
           ELSE
               SET DISPLAY-LOW-VALUES TO TRUE
               PERFORM 1400-DISPLAY-INQUIRY-RESULTS
           END-IF.
      *

       6000-OPEN-CUST-FILE.                                             josh

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
           END-IF.                                                      josh




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
