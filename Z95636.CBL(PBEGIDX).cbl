       IDENTIFICATION DIVISION.
      *--------------------------------
       PROGRAM-ID.    PBEGIDX.
       AUTHOR.        YASAR OKTEN.
      *--------------------------------
       ENVIRONMENT DIVISION.
      *--------------------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE ASSIGN TO IDXFILE
                           ORGANIZATION INDEXED
                           ACCESS RANDOM
                           RECORD KEY IDX-KEY
                           STATUS IDX-ST.
      *--------------------------------
       DATA DIVISION.
      *--------------------------------
       FILE SECTION.
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
              10 IDX-ID            PIC S9(5) COMP-3.
              10 IDX-CURR          PIC S9(3) COMP.
           05 IDX-NAME             PIC X(15).
           05 IDX-SURNAME          PIC X(15).
           05 IDX-DATE             PIC S9(7) COMP-3.
           05 IDX-BALANCE          PIC S9(15) COMP-3.
      *--------------------------------
       WORKING-STORAGE SECTION.
       01  WS-AREA.
           05 I                       PIC 99      VALUE 01.
           05 J                       PIC 99      VALUE 01.
           05 FLAG                    PIC 9       VALUE 0.
           05 IDX-ST                  PIC 99.
              88 IDX-SUCCESS                      VALUE 00 97.
              88 IDX-EOF                          VALUE 10.
           05 WS-FUNC                       PIC 9.
                 88 WS-FUNC-OPEN                  VALUE 1.
                 88 WS-FUNC-WRITE                 VALUE 2.
                 88 WS-FUNC-UPDATE                VALUE 3.
                 88 WS-FUNC-DELETE                VALUE 4.
                 88 WS-FUNC-READ                  VALUE 5.
                 88 WS-FUNC-CLOSE                 VALUE 9.
      *--------------------------------
       LINKAGE SECTION.
       01  LS-SUB-AREA.
           05 LS-FUNC                PIC 9.
           05 LS-ID                  PIC 9(5).
           05 LS-CURR                PIC 9(3).
           05 LS-RC                  PIC 9(2).
           05 LS-DATA.
              10 LS-WRONG-EXP        PIC X(30).
              10 LS-NAME-FROM        PIC X(15).
              10 LS-SURNAME-FROM     PIC X(15).
              10 LS-NAME-TO          PIC X(15).
              10 LS-SURNAME-TO       PIC X(15).
      *--------------------------------
       PROCEDURE DIVISION USING LS-SUB-AREA.
      *--------------------------------
       0000-MAIN.
           MOVE SPACES TO LS-DATA.
           MOVE LS-FUNC TO WS-FUNC
           EVALUATE TRUE
              WHEN WS-FUNC-OPEN
                 PERFORM H100-OPEN-FILES
              WHEN WS-FUNC-WRITE
                 PERFORM H200-WRITE-RECORD
              WHEN WS-FUNC-UPDATE
                 PERFORM H300-UPDATE-RECORD
              WHEN WS-FUNC-DELETE
                 PERFORM H400-DELETE-RECORD
              WHEN WS-FUNC-READ
                 PERFORM H500-READ-RECORD
              WHEN WS-FUNC-CLOSE
                 PERFORM H999-CLOSE-FILES
              WHEN OTHER
                 MOVE 'WRONG PROCESS TYPE' TO LS-WRONG-EXP
                 GOBACK
           END-EVALUATE.
       0000-END. EXIT.
      *--------------------------------
       H100-OPEN-FILES.
           OPEN I-O IDX-FILE.
           IF (IDX-ST NOT = 0) AND (IDX-ST NOT = 97)
              DISPLAY 'UNABLE TO OPEN INDEX FILE: ' IDX-ST
              MOVE IDX-ST TO RETURN-CODE
              STOP RUN
           END-IF.
           GOBACK.
       H100-END.
      *--------------------------------
       H200-WRITE-RECORD.
           PERFORM H500-READ-RECORD
           IF FLAG = 0
              MOVE 'THIS RECORD ALREADY EXIST' TO LS-WRONG-EXP
              WRITE IDX-REC
              MOVE IDX-ST TO LS-RC
           ELSE
              MOVE 'RECORD WRITTED SUCCESSFULLY' TO LS-WRONG-EXP
              MOVE 'YASAR' TO IDX-NAME
              MOVE 'OKTEN' TO IDX-SURNAME
              MOVE ZEROES TO IDX-DATE
              MOVE ZEROES TO IDX-BALANCE
              WRITE IDX-REC
              MOVE IDX-NAME TO LS-NAME-TO
              MOVE IDX-SURNAME TO LS-SURNAME-TO
              MOVE IDX-ST TO LS-RC
              MOVE 0 TO FLAG
           END-IF.
           GOBACK.
       H200-END. EXIT.
      *--------------------------------
       H300-UPDATE-RECORD.
           PERFORM H500-READ-RECORD.
           MOVE IDX-NAME TO LS-NAME-FROM.
           MOVE IDX-SURNAME TO LS-SURNAME-FROM.
           PERFORM UNTIL I > LENGTH OF IDX-NAME
              IF IDX-NAME(I:1) NOT = SPACE
                 MOVE IDX-NAME(I:1) TO LS-NAME-TO(J:1)
                 ADD 1 TO J
              END-IF
              ADD 1 TO I
           END-PERFORM.
           MOVE 1 TO I.
           MOVE 1 TO J.
           IF LS-NAME-FROM = LS-NAME-TO
              MOVE 'SPACE NOT FOUND' TO LS-WRONG-EXP
           ELSE
              MOVE 'FILE UPDATED SUCCESSFULLY' TO LS-WRONG-EXP
           END-IF.
           MOVE LS-NAME-TO  TO IDX-NAME.
           INSPECT IDX-SURNAME REPLACING ALL 'E' BY 'I'.
           INSPECT IDX-SURNAME REPLACING ALL 'A' BY 'E'.
           MOVE IDX-SURNAME TO LS-SURNAME-TO.
           REWRITE IDX-REC.
           GOBACK.
       H300-END. EXIT.
      *--------------------------------
       H400-DELETE-RECORD.
           PERFORM H500-READ-RECORD.
           DELETE IDX-FILE.
           MOVE 'RECORD DELETED SUCCESSFULLY' TO LS-WRONG-EXP.
           GOBACK.
       H400-END. EXIT.
      *--------------------------------
       H500-READ-RECORD.
           MOVE LS-ID TO IDX-ID.
           MOVE LS-CURR TO IDX-CURR.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
           MOVE IDX-ST TO LS-RC
           IF WS-FUNC-WRITE
              MOVE 1 TO FLAG
           ELSE
              STRING
              'WRONG RECORD RC : '
              IDX-ST
              DELIMITED BY SIZE INTO LS-WRONG-EXP
              GOBACK
           END-IF
           END-READ.
           MOVE IDX-ST TO LS-RC
           IF WS-FUNC-READ
              STRING
              'RECORD IS READ RC : '
              LS-RC
              DELIMITED BY SIZE INTO LS-WRONG-EXP
              MOVE IDX-NAME TO LS-NAME-FROM
              MOVE IDX-SURNAME TO LS-SURNAME-FROM
              GOBACK
           END-IF.
       H500-END. EXIT.
      *--------------------------------
       H999-CLOSE-FILES.
           CLOSE IDX-FILE.
           GOBACK.
       H999-END. EXIT.
      *--------------------------------
