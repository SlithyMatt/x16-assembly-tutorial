10 REM -- SET RTC TIME & DATE
20 PRINT "ENTER YEAR: "
30 INPUT A
40 IF A > 99 THEN GOTO 60
50 A = A + 2000
60 A = A - 1900
70 POKE $02,A
80 PRINT "ENTER MONTH: "
90 INPUT A
100 POKE $03,A
110 PRINT "ENTER DAY: "
120 INPUT A
130 POKE $04,A
140 PRINT "ENTER HOUR (0-23):"
150 INPUT A
160 POKE $05,A
170 PRINT "ENTER MINUTE:"
180 INPUT A
190 POKE $06,A
200 POKE $07,0
210 POKE $08,0
220 SYS $FF4D: REM CLOCK_SET_DATE_TIME
