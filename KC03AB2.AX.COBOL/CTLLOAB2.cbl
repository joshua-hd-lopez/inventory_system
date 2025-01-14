       IDENTIFICATION DIVISION.
       PROGRAM-ID. CTLLOAB2.
       AUTHOR. JOSHUA LOPEZ.
       DATE-WRITTEN. 17/03/2021.
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
           SELECT CMINPUT ASSIGN TO CMDATA
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-INFILE-SW.

           SELECT CMFILE ASSIGN TO OUTFILE
               RECORD KEY IS CM-KEY
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-OUTFILE-SW.
      *
       DATA DIVISION.
       FILE SECTION.
       FD CMINPUT
           RECORD CONTAINS 7 CHARACTERS
           DATA RECORD IS CMINPUT-RECORD.

       01  CMINPUT-RECORD.
      *
      *   01  INVCTL-RECORD.
      *
           05  INVCTL-RECORD-KEYGRP.
               10  INVCTL-RECORD-KEY           PIC 9(01).
           05  INVCTL-NEXT-INVOICE-NUMBER      PIC 9(06).
      *
      *
      *01 CMINPUT-RECORD.
      *    05  CM-KEY-IN.
      *        10  CM-CUSTOMER-NUMBER        PIC X(6).
      *    05  CM-FIRST-NAME                 PIC X(20).
      *    05  CM-LAST-NAME                  PIC X(30).
      *    05  CM-ADDRESS                    PIC X(30).
      *    05  CM-CITY                       PIC X(20).
      *    05  CM-STATE                      PIC X(2).
      *    05  CM-ZIP-CODE                   PIC X(10).

       FD CMFILE
           RECORD CONTAINS 7 CHARACTERS
           DATA RECORD IS CMFILE-RECORD.


       01  CMFILE-RECORD.
      *
      *   01  INVCTL-RECORD.
      *
           05  INVCTL-RECORD-KEYGRP.
      *        10  INVCTL-RECORD-KEY
               10  CM-KEY           PIC 9(01).
           05  INVCTL-NEXT-INVOICE-NUMBER      PIC 9(06).
      *
      *
      *01 CMFILE-RECORD.
      *    05  CM-KEY.
      *        10  CM-CUSTOMER-NUMBER        PIC X(6).
      *    05  CM-FIRST-NAME                 PIC X(20).
      *    05  CM-LAST-NAME                  PIC X(30).
      *    05  CM-ADDRESS                    PIC X(30).
      *    05  CM-CITY                       PIC X(20).
      *    05  CM-STATE                      PIC X(2).
      *    05  CM-ZIP-CODE                   PIC X(10).
      *
       WORKING-STORAGE SECTION.
       01 WS-INFILE-SW                       PIC X(02)  VALUE SPACES.
           88  WS-INFILE-SUCCESS                 VALUE '00'.
           88  WS-INFILE-EOF                     VALUE '10'.
       01 WS-OUTFILE-SW                      PIC X(02)  VALUE SPACES.
           88  WS-OUTFILE-SUCCESS                VALUE '00'.
           88  WS-OUTFILE-EOF                    VALUE '10'.
       01 WS-CM-REC                          PIC X(118).
       01 WS-EOF-SW-IN                       PIC X(01)  VALUE 'N'.
           88  WS-EOF-IN-NO                      VALUE 'N'.
           88  WS-EOF-IN-YES                     VALUE 'Y'.
       01 WS-EOF-SW-OUT                      PIC X(01)  VALUE 'N'.
           88  WS-EOF-OUT-NO                     VALUE 'N'.
           88  WS-EOF-OUT-YES                    VALUE 'Y'.

       PROCEDURE DIVISION.
       000-MAIN-PARA.
           MOVE SPACE TO WS-INFILE-SW
                         WS-OUTFILE-SW
                         WS-CM-REC.
      *
           OPEN INPUT CMINPUT.
           IF WS-INFILE-SUCCESS
               DISPLAY "CMINPUT OPEN SUCCESSFUL"
           ELSE
               DISPLAY "WS-INFILE-SW=" WS-INFILE-SW
               DISPLAY "CMINPUT OPEN ERROR"
               GO TO 999-DONE
           END-IF.
      *
           OPEN OUTPUT CMFILE.
           IF WS-OUTFILE-SUCCESS
               DISPLAY "CMFILE OPEN SUCCESSFUL"
           ELSE
               DISPLAY "WS-OUTFILE-SW=" WS-OUTFILE-SW
               DISPLAY "CMFILE OPENING ERROR"
               GO TO 999-DONE
           END-IF.
      *
           READ CMINPUT
               AT END MOVE 'Y' TO WS-EOF-SW-IN.
      *
           IF WS-EOF-IN-NO THEN
               DISPLAY "1ST READ CMIREC=" CMINPUT-RECORD
      *
               PERFORM 100-LOAD-PARA
                   UNTIL WS-EOF-IN-YES
           ELSE
               DISPLAY "NO DATA IN CMINPUT"
           END-IF.
      *
       999-DONE.
           DISPLAY "DONE".
           STOP RUN.
      *
       100-LOAD-PARA.
      *
           WRITE CMFILE-RECORD FROM CMINPUT-RECORD.
           DISPLAY "WRITE TO CMFILE".
      *
           READ CMINPUT
               AT END MOVE 'Y' TO WS-EOF-SW-IN.
      *
           IF WS-EOF-IN-NO THEN
               DISPLAY "NTH READ CMIREC=" CMINPUT-RECORD
           ELSE
               DISPLAY "EOF CMINPUT"
           END-IF.
      *
