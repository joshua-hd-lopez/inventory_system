       IDENTIFICATION  DIVISION.
      *
       PROGRAM-ID.  UUMENAB2.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCHES.
      *
           05  VALID-DATA-SW               PIC X(01) VALUE 'Y'.
               88  VALID-DATA              VALUE 'Y'.
      *
       01  FLAGS.
      *
           05  SEND-FLAG                   PIC X(01).
               88  SEND-ERASE              VALUE '1'.
               88  SEND-DATAONLY           VALUE '2'.
               88  SEND-DATAONLY-ALARM     VALUE '3'.
      *
       01  PROGRAM-TABLE.
      *
           05  PROGRAM-LIST.
               10  PROGRAM-1               PIC X(08) VALUE 'CMINQAB2'.
               10  PROGRAM-2               PIC X(08) VALUE 'CMMNTAB2'.
               10  PROGRAM-3               PIC X(08) VALUE 'ORDERAB2'.
               10  PROGRAM-4               PIC X(08) VALUE 'INSUMAB2'.  A5
           05  PROGRAM-NAME                REDEFINES PROGRAM-LIST
                                           OCCURS 4 TIMES
                                           PIC X(08).
      *
       01  SUBSCRIPTS.
           05  ACTION-SUB              PIC 9(01).
      *
       01  END-OF-SESSION-MESSAGE      PIC X(13) VALUE 'Session ended'.
      *
       01  RESPONSE-CODE               PIC S9(08) COMP.
      *
       01  COMMUNICATION-AREA          PIC X(01).
      *
       COPY MENSAB2.
      *
       COPY DFHAID.
      *
       COPY ATTR.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA                 PIC X(01).
      *
       PROCEDURE DIVISION.
      *
       0000-PROCESS-MASTER-MENU.
      *
           EVALUATE TRUE
      *
               WHEN EIBCALEN = ZERO
                   MOVE LOW-VALUE TO MENMAB2O
                   SET SEND-ERASE TO TRUE
                   PERFORM 1400-SEND-MENU-MAP
      *
               WHEN EIBAID = DFHCLEAR
                   MOVE LOW-VALUE TO MENMAB2O
                   SET SEND-ERASE TO TRUE
                   PERFORM 1400-SEND-MENU-MAP
      *
               WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
                   CONTINUE
      *
               WHEN EIBAID = DFHPF3 OR DFHPF12
                   PERFORM 2000-SEND-TERMINATION-MESSAGE
                   EXEC CICS
                       RETURN
                   END-EXEC
      *
               WHEN EIBAID = DFHENTER
                   PERFORM 1000-PROCESS-MENU-MAP
      *
               WHEN OTHER
                   MOVE 'Invalid key pressed.' TO MESSAGEO
                   SET SEND-DATAONLY-ALARM TO TRUE
                   PERFORM 1400-SEND-MENU-MAP
      *
           END-EVALUATE.
      *
           EXEC CICS
               RETURN TRANSID('UAB2')
                      COMMAREA(COMMUNICATION-AREA)
           END-EXEC.
      *
       1000-PROCESS-MENU-MAP.
      *
           PERFORM 1100-RECEIVE-MENU-MAP.
           PERFORM 1200-EDIT-MENU-DATA.
           IF VALID-DATA
               MOVE ACTIONI TO ACTION-SUB
               PERFORM 1300-BRANCH-TO-PROGRAM
           END-IF.
           SET SEND-DATAONLY-ALARM TO TRUE.
           PERFORM 1400-SEND-MENU-MAP.
      *
       1100-RECEIVE-MENU-MAP.
      *
           EXEC CICS
               RECEIVE MAP('MENMAB2')
                       MAPSET('MENSAB2')
                       INTO(MENMAB2I)
           END-EXEC.
      *
       1200-EDIT-MENU-DATA.
      *
           IF ACTIONI NOT = '1' AND '2' AND '3' AND '4'                 a5
               MOVE ATTR-REVERSE TO ACTIONH
      *        MOVE 'You must enter 1, 2, or 3.' TO MESSAGEO
               MOVE 'You must enter 1, 2, 3 or 4.' TO MESSAGEO          a5
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
       1300-BRANCH-TO-PROGRAM.
      *
           EXEC CICS
               XCTL PROGRAM(PROGRAM-NAME(ACTION-SUB))
               RESP(RESPONSE-CODE)
           END-EXEC.
      *
           MOVE 'That program is not available.' TO MESSAGEO.
      *
       1400-SEND-MENU-MAP.
      *
           MOVE 'UAB2' TO TRANIDO.
           EVALUATE TRUE
               WHEN SEND-ERASE
                   EXEC CICS
                       SEND MAP('MENMAB2')
                            MAPSET('MENSAB2')
                            FROM(MENMAB2O)
                            ERASE
                   END-EXEC
               WHEN SEND-DATAONLY
                   EXEC CICS
                       SEND MAP('MENMAB2')
                            MAPSET('MENSAB2')
                            FROM(MENMAB2O)
                            DATAONLY
                   END-EXEC
               WHEN SEND-DATAONLY-ALARM
                   EXEC CICS
                       SEND MAP('MENMAB2')
                            MAPSET('MENSAB2')
                            FROM(MENMAB2O)
                            DATAONLY
                            ALARM
                   END-EXEC
           END-EVALUATE.
      *
       2000-SEND-TERMINATION-MESSAGE.
      *
           EXEC CICS
               SEND TEXT FROM(END-OF-SESSION-MESSAGE)
                         ERASE
                         FREEKB
           END-EXEC.
