       IDENTIFICATION DIVISION.
       PROGRAM-ID. CMINAB2.
       AUTHOR. JOSHUA LOPEZ.
       DATE-WRITTEN. 26/02/2021.
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
           SELECT CMFILE ASSIGN TO OUTFILE
           ORGANIZATION IS INDEXED
           ACCESS MODE IS SEQUENTIAL
           RECORD KEY IS CM-KEY
           FILE STATUS IS WS-OUTFILE-SW.
      *
       DATA DIVISION.
       FILE SECTION.
       FD CMFILE
           RECORD CONTAINS 118 CHARACTERS
           DATA RECORD IS CMFILE-RECORD.
       01 CMFILE-RECORD.
           05  CM-KEY.
               10  CM-CUSTOMER-NUMBER        PIC X(6).
           05  CM-FIRST-NAME                 PIC X(20).
           05  CM-LAST-NAME                  PIC X(30).
           05  CM-ADDRESS                    PIC X(30).
           05  CM-CITY                       PIC X(20).
           05  CM-STATE                      PIC X(2).
           05  CM-ZIP-CODE                   PIC X(10).
      *
       WORKING-STORAGE SECTION.
       01 WS-OUTFILE-SW                      PIC X(02)  VALUE SPACES.
           88  WS-OUTFILE-SUCCESS                VALUE '00'.
           88  WS-OUTFILE-EOF                    VALUE '10'.
       01 WS-CM-REC                          PIC X(118).
       01 WS-EOF-SW                          PIC X(01)  VALUE 'N'.
           88  WS-EOF-NO                         VALUE 'N'.
           88  WS-EOF-YES                        VALUE 'Y'.
      *
       PROCEDURE DIVISION.
       000-MAIN-PARA.
           INITIALIZE WS-OUTFILE-SW
                      WS-CM-REC
                      WS-EOF-SW.
           OPEN OUTPUT CMFILE.
           DISPLAY "WS-OUTFILE-SW=" WS-OUTFILE-SW.
           IF WS-OUTFILE-SUCCESS
               DISPLAY "CMFILE OPEN SUCCESSFUL"
               MOVE LOW-VALUES     TO   WS-CM-REC
               WRITE CMFILE-RECORD FROM WS-CM-REC
               CLOSE CMFILE
           ELSE
               DISPLAY "CMFILE OPENING ERROR"
           END-IF.
           STOP RUN.