       IDENTIFICATION DIVISION.
      *--------------------------------
       PROGRAM-ID.    FINALEX.
       AUTHOR.        YASAR OKTEN.
      *--------------------------------
       ENVIRONMENT DIVISION.
      *--------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE ASSIGN TO INPFILE
                           STATUS INP-ST.
           SELECT OUT-FILE ASSIGN TO OUTFILE
                           STATUS OUT-ST.
      *--------------------------------
       DATA DIVISION.
      *--------------------------------
       FILE SECTION.
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-REC.
           05 OREC-PROCESS-TYPE    PIC 9.
           05 FILLER               PIC X(2)   VALUE SPACES.
           05 OUT-ID-O             PIC 9(5).
           05 FILLER               PIC X(2)   VALUE SPACES.
           05 OUT-CURR-O           PIC 9(3).
           05 FILLER               PIC X(2)   VALUE SPACES.
           05 OUT-RC-O             PIC 9(2).
           05 FILLER               PIC X(2)   VALUE SPACES.
           05 OUT-DATA-O.
              10 OUT-WRONG-EXP     PIC X(30).
              10 OUT-NAME-FROM     PIC X(15).
              10 OUT-SURNAME-FROM  PIC X(15).
              10 OUT-NAME-TO       PIC X(15).
              10 OUT-SURNAME-TO    PIC X(15).
      *--------------------------------
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 PROCESS-TYPE    PIC X.
           05 INP-ID          PIC X(5).
           05 INP-CURR        PIC X(3).
      *--------------------------------
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05 WS-PBEGIDX                    PIC X(8) VALUE 'PBEGIDX'.
           05 INP-ST                        PIC 99.
              88 INP-SUCCESS                         VALUE 00 97.
              88 INP-EOF                             VALUE 10.
           05 OUT-ST                        PIC 99.
              88 OUT-SUCCESS                         VALUE 00 97.
           05 WS-SUB-AREA.
              10 WS-SUB-FUNC                PIC 9.
                 88 WS-FUNC-OPEN                     VALUE 1.
                 88 WS-FUNC-WRITE                    VALUE 2.
                 88 WS-FUNC-UPDATE                   VALUE 3.
                 88 WS-FUNC-DELETE                   VALUE 4.
                 88 WS-FUNC-READ                     VALUE 5.
                 88 WS-FUNC-CLOSE                    VALUE 9.
              10 WS-SUB-ID                  PIC 9(5).
              10 WS-SUB-CURR                PIC 9(3).
              10 WS-SUB-RC                  PIC 9(2).
              10 WS-SUB-DATA                PIC X(90).
        01  HEADER-1.
           05  FILLER         PIC X(13)           VALUE 'FINAL PROJECT'.
           05  FILLER         PIC X(04)           VALUE SPACES.
           05  FILLER         PIC X(09)           VALUE 'AUTHOR : '.
           05  FILLER         PIC X(11)           VALUE 'YASAR OKTEN'.
           05  FILLER         PIC X(72)           VALUE SPACES.
      *--------------------------------
       01  HEADER-2.
           05 FILLER        PIC X(12) VALUE 'PROCESS TYPE'.
           05 FILLER        PIC X(03) VALUE SPACES.
           05 FILLER        PIC X(02) VALUE 'RC'.
           05 FILLER        PIC X(02) VALUE SPACES.
           05 FILLER        PIC X(11) VALUE 'EXPLANATION'.
           05 FILLER        PIC X(19) VALUE SPACES.
           05 FILLER        PIC X(17) VALUE 'NAME-SURNAME FROM'.
           05 FILLER        PIC X(13) VALUE SPACES.
           05 FILLER        PIC X(15) VALUE 'NAME-SURNAME TO'.
           05 FILLER        PIC X(15) VALUE SPACES.
      *--------------------------------
       01  HEADER-3.
           05 FILLER        PIC X(13) VALUE '_____________'.
           05 FILLER        PIC X(02) VALUE SPACES.
           05 FILLER        PIC X(02) VALUE '__'.
           05 FILLER        PIC X(02) VALUE SPACES.
           05 FILLER        PIC X(25) VALUE '_________________________'.
           05 FILLER        PIC X(05) VALUE SPACES.
           05 FILLER        PIC X(25) VALUE '_________________________'.
           05 FILLER        PIC X(05) VALUE SPACES.
           05 FILLER        PIC X(25) VALUE '_________________________'.
           05 FILLER        PIC X(05) VALUE SPACES.
      *--------------------------------
       PROCEDURE DIVISION.
      *--------------------------------
       0000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-WRITE-HEADERS.
           PERFORM H300-READ-CONTROL-MOVE UNTIL INP-EOF.
           PERFORM H999-PROGRAM-EXIT.
       MAIN-END. EXIT.
      *--------------------------------
       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN OUTPUT OUT-FILE.
           PERFORM H110-OPEN-CONTROL.
           SET WS-FUNC-OPEN TO TRUE.
           CALL WS-PBEGIDX USING WS-SUB-AREA.
           READ INP-FILE.
       H100-END. EXIT.
      *--------------------------------
       H110-OPEN-CONTROL.
           IF (INP-ST NOT = 0) AND (INP-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPUT FILE: ' INP-ST
           MOVE INP-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
      *--------------------------------
           IF (OUT-ST NOT = 0) AND (OUT-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTPUT FILE: ' OUT-ST
           MOVE OUT-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H110-END. EXIT.
      *--------------------------------
       H200-WRITE-HEADERS.
           WRITE OUT-REC FROM HEADER-1.
           MOVE SPACES TO OUT-REC.
           WRITE OUT-REC AFTER ADVANCING 1 LINES.
           WRITE OUT-REC FROM HEADER-2.
           WRITE OUT-REC FROM HEADER-3.
           WRITE OUT-REC AFTER ADVANCING 1 LINES.
           MOVE SPACES TO OUT-REC.
       H200-WRITE-END. EXIT.
      *--------------------------------
      *WS-PBEGIDX adlı bir alt program WS-SUB-AREA parametresiyle 
      *çağrılır. Bu çağrı ile işlem verileri hazırlanır.
      *Daha sonra, WS-SUB-FUNC değeri OREC-PROCESS-TYPE değişkenine, 
      *WS-SUB-ID değeri OUT-ID-O değişkenine, WS-SUB-CURR değeri 
      *OUT-CURR-O değişkenine, WS-SUB-RC değeri OUT-RC-O değişkenine, 
      *WS-SUB-DATA değeri de OUT-DATA-O değişkenine atanır.
       H300-READ-CONTROL-MOVE.
           IF (INP-ST NOT = 0) AND (INP-ST NOT = 97)
           DISPLAY 'UNABLE TO READ INPUT FILE: ' INP-ST
           MOVE INP-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           MOVE PROCESS-TYPE TO WS-SUB-FUNC
           MOVE INP-ID TO WS-SUB-ID
           MOVE INP-CURR TO WS-SUB-CURR
           MOVE SPACES      TO OUT-REC
           CALL WS-PBEGIDX USING WS-SUB-AREA.
           MOVE WS-SUB-FUNC TO OREC-PROCESS-TYPE.
           MOVE WS-SUB-ID   TO OUT-ID-O.
           MOVE WS-SUB-CURR TO OUT-CURR-O.
           MOVE WS-SUB-RC   TO OUT-RC-O.
           MOVE WS-SUB-DATA TO OUT-DATA-O.
           WRITE OUT-REC.
           READ INP-FILE.
       H300-END. EXIT.
      *--------------------------------
       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
           SET WS-FUNC-CLOSE TO TRUE.
           CALL WS-PBEGIDX USING WS-SUB-AREA.
           STOP RUN.
       H999-END. EXIT.
      *--------------------------------
