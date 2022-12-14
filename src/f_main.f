      PROGRAM SCBD
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /PB/ NPROB

      INCLUDE "param.inc"
      DIMENSION X(10), W(3000), IACT(51)
      DIMENSION XL(10), XU(10)
      CHARACTER LINE0,LINE1,LINE2,LINE3
      DIMENSION LINE0(90),LINE1(90),LINE2(90),LINE3(90)
    
      ZERO=0.0D0
      ONE=1.0D0
      TWO=2.0D0

      EPS = 1.0D-9
      NMAX = 25

      CALL  PARAM("scbd.dat",PSC,PCE,PSE,BB,TAUSC,TAUCE,TAUSE,
     1  FSC,FCE,FSE,AA) 

      CW   = VAL * CW
      SC   = VAL * SC
      ASCR = VAL * ASCR
      ACER = VAL * ACER
      ASER = VAL * ASER

      DO 1, I=1,90
      LINE0(I)='-'
      LINE1(I)='='
      LINE2(I)='='
      LINE3(I)='='
  1   CONTINUE
      LINE2(20)='N'
      LINE2(21)='0'

      LINE2(23)='T'
      LINE2(24)='R'
      LINE2(25)='A'
      LINE2(26)='I'
      LINE2(27)='N'

      LINE2(29)='S'
      LINE2(30)='E'

      LINE3(18)='W'
      LINE3(19)='I'
      LINE3(20)='T'
      LINE3(21)='H'

      LINE3(23)='T'
      LINE3(24)='R'
      LINE3(25)='A'
      LINE3(26)='I'
      LINE3(27)='N'

      LINE3(29)='S'
      LINE3(30)='E'


C     (* fixed costs, free-flow travel times *)
      dTse=DSQRT(dTsc*dTsc+dTce*dTce-2*dTsc*dTce*DCOS(theta))
      dRse=DSQRT(dRsc*dRsc+dRce*dRce-2*dRsc*dRce*DCOS(theta))
      Fsct=dTsc/sTsc*val
      Fcet=dTce/sTce*val
      Fset=dTse/sTse*val
      Fscr=dRsc/sRsc*val
      Fcer=dRce/sRce*val
      Fser=dRse/sRse*val
C     Fser=(theta*dRsc)/sRse*val
      POP = POPSC+POPCE+POPSE
      PRINT '(6F9.2)', FSCT, FCET, FSET, FSCR, FCER, FSER 

C  ------------------------
C  Head of the output table
C  ------------------------

      PRINT '(90A)', LINE1
      WRITE (*, '(3X,A10,9X,A15,22X,A15)') 'ADM REGIME','TRAIN','ROADS'
      PRINT '(90A)', LINE0
      WRITE (*, '(16X,4A8,5X,4A8)') 'SC','CE','SE','AGR', 
     &                              'SC','CE','SE','AGR' 
      PRINT '(90A)', LINE2

C  ------------------------
C  1 -- COMPUTE THE OPTIMUM
C  ------------------------

      ID=1

      DO 10, I = 1,NMAX
      CALL OPTIMUM (TC,USCT,UCET,USET,FSC,FCE,FSE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE,ID) 
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 11
      FSC = TMP1
      FCE = TMP2 
10    CONTINUE

11    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'

      WRITE (*, '(A12,35X,F8.4)' ) 'Optimum', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB*(PSC+PCE),
     &     PSC*USCT+PCE*UCET+PSE*USET
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,
     &  (POPSC-USCT)*TAUSC+(POPCE-UCET)*TAUCE+(POPSE-USET)*TAUSE
      PRINT '(90A)', LINE0

C  ------------------------
C  2 -- BETA LIMITED: BETA <= BETA_MAX
C  ------------------------

      TAUSC=ZERO
      TAUCE=ZERO
      TAUSE=ZERO
      PSC  =ZERO
      PCE  =ZERO
      BB = 1.0D0

      DO 20, I=1, NMAX
      CALL BETAFIXED (FSC,FCE,AA,PSC,PCE,BB,TAUSC,TAUCE,TAUSE,
     1         USCT,UCET,USET,TC)
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 21
      FSC = TMP1
      FCE = TMP2 
20    CONTINUE

21    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'

      WRITE (*, '(A12,35X,F8.4)' ) 'Beta bounded',TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB*(PSC+PCE),
     &     PSC*USCT+PCE*UCET+PSE*USET
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,
     &  (POPSC-USCT)*TAUSC+(POPCE-UCET)*TAUCE+(POPSE-USET)*TAUSE
      PRINT '(90A)', LINE0

CC  -------------------------
CC  2 -- UNPRICED EQUILIBRIUM
CC  -------------------------

      ID = 2
      DO 30, I=1, NMAX
      CALL EQUILIBRIUM (TC,USCT,UCET,USET,FSC,FCE,FSE,AA,
     1     ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,ID) 
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 31
      FSC = TMP1
      FCE = TMP2 
30    CONTINUE

31    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'

      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(A12,35X,F8.4)' ) 'Unpriced', TC
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      PRINT '(90A)', LINE0

CC  -----------------------
CC  2 -- PRICED EQUILIBRIUM
CC  -----------------------

C     TAUSC= ZERO
C     TAUCE= ZERO
C     TAUSE= ZERO
C     PSC  = -0.97D0
C     PCE  = -0.97D0
C     BB   =  0.74D0
C     PRINT*, '---------PRICED EQUIL'
C     CALL EQUILIBRIUM (TC,USCT,UCET,USET,FSC,FCE,AA,
C    1     PSC,PCE,BB,TAUSC,TAUCE,TAUSE) 
C     WRITE (*,'(4F9.4)') TC, USCT,UCET,USET 

CC  -----------------------
CC  2 -- ROAD PROFIT
CC  -----------------------

      DO 40, I=1, NMAX
      CALL PRFROAD (PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1     ZERO,ZERO,ZERO,TAUSC,TAUCE,TAUSE) 
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 41
      FSC = TMP1
      FCE = TMP2 
40    CONTINUE

41    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'
C     WRITE (*,'(8F9.4)') TC, USCT,UCET,USET,PRFR,TAUSC,TAUCE,TAUSE 
      WRITE (*, '(A12,35X,F8.4)' ) 'Road prf', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,PRFR
      PRINT '(90A)', LINE0

CC  --------------------
CC  2 -- TRAIN PROFIT
CC  --------------------

      DO 50, I=1, NMAX
      CALL PRFTRAIN (PRFT,TC,USCT,UCET,USET,FSC,FCE,AA,
     1     PSC,PCE,BB,ZERO,ZERO,ZERO) 
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 51
      FSC = TMP1
      FCE = TMP2 
50    CONTINUE

51    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'


      WRITE (*, '(A12,35X,F8.4)' ) 'Train prf', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB*(PSC+PCE),PRFT
      PRINT '(90A)', LINE0 

CC  --------------------
CC  2 -- SEMI-PUBLIC
CC  --------------------
      PSC = ZERO
      PCE = ZERO
      PSE = ZERO
      DO 60, I=1, NMAX
      CALL SEMIPUBLIC (PRFT,PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1                 PSC,PCE,BB,TAUSC,TAUCE,TAUSE)
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 61
      FSC = TMP1
      FCE = TMP2 
60    CONTINUE

61    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'


      WRITE (*, '(A12,35X,F8.4)' ) 'Semi-pub', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB*(PSC+PCE),PRFT
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,PRFR
      PRINT '(90A)', LINE0

CC  --------------------
CC  2 -- DUOPOLY
CC  --------------------

      DO 70, I=1, NMAX
      CALL DUOPOLY (PRFT,PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE)
      TMP1 = DSQRT(CW*(USCT+USET)/(TWO*PHI))
      TMP2 = DSQRT(CW*(UCET+USET)/(TWO*PHI))
      TMP3 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP3.LT.EPS) GOTO 71
      FSC = TMP1
      FCE = TMP2 
70    CONTINUE

71    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations'



      WRITE (*, '(A12,35X,F8.4)' ) 'Duopoly', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*(USCT+USET)/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*(UCET+USET)/FCE 
      C3T=C1T+C2T-AA*CW/(TWO*FSC)+(ONE-AA)*SC
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,2F8.2)') 'Freq.',FSC,FCE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB*(PSC+PCE),PRFT
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,PRFR

      PRINT '(90A)', LINE3 
      WRITE (*, '(16X,4A8,5X,4A8)') 'SC','CE','SE','AGR', 
     &                              'SC','CE','SE','AGR' 
      PRINT '(90A)', LINE0
C  ---------------------------------------------
C  1 -- COMPUTE THE OPTIMUM WITH DIRECT TRAIN SE
C  ---------------------------------------------

      ID=10
      DO 100, I=1, NMAX
      CALL OPTIMUM (TC,USCT,UCET,USET,FSC,FCE,FSE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE,ID)
      TMP1 = DSQRT(CW*USCT/(TWO*PHI))
      TMP2 = DSQRT(CW*UCET/(TWO*PHI))
      TMP3 = DSQRT(CW*USET/(TWO*PHI))
      TMP4 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP4.LT.EPS) GOTO 101
      FSC = TMP1
      FCE = TMP2 
      FSE = TMP3 
100    CONTINUE

101    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations' 


      WRITE (*, '(A12,35X,F8.4)' ) 'Optimum', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*USCT/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*UCET/FCE 
      C3T=FSET+CW/(TWO*FSE)+ASET*USET/FCE 
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,3F8.2)') 'Freq.',FSC,FCE,FSE
      WRITE (*, '(11X,A5,4F8.2)') 'Fares',PSC,PCE,BB,
     &     PSC*USCT+PCE*UCET+PSE*USET
      WRITE (*, '(11X,A5,37X,4F8.2)') 'Tolls',TAUSC,TAUCE,TAUSE,
     &  (POPSC-USCT)*TAUSC+(POPCE-UCET)*TAUCE+(POPSE-USET)*TAUSE
      PRINT '(90A)', LINE0

CC  ----------------------------------------------
CC  2 -- UNPRICED EQUILIBRIUM WITH DIRECT TRAIN SE
CC  ----------------------------------------------

      ID = 11
      DO 110, I=1, NMAX
      CALL EQUILIBRIUM (TC,USCT,UCET,USET,FSC,FCE,FSE,AA,
     1     ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,ID) 
      TMP1 = DSQRT(CW*USCT/(TWO*PHI))
      TMP2 = DSQRT(CW*UCET/(TWO*PHI))
      TMP3 = DSQRT(CW*USET/(TWO*PHI))
      TMP4 = (TMP1-FSC)**2+(TMP2-FCE)**2
      IF(TMP4.LT.EPS) GOTO 111
      FSC = TMP1
      FCE = TMP2 
      FSE = TMP3 
110    CONTINUE

111    CONTINUE
      IF(I.EQ.NMAX+1) PRINT*,'No convergence after ',NMAX,' iterations' 


      WRITE (*, '(A12,35X,F8.4)' ) 'Unpriced', TC
      POPTRAIN = USCT+UCET+USET
      POPCAR = POP-POPTRAIN
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2)')  'Users', 
     &   USCT,UCET,USET,POPTRAIN,
     &   POPSC-USCT,POPCE-UCET,POPSE-USET,POPCAR 

      C1T=FSCT+CW/(TWO*FSC)+ASCT*USCT/FSC
      C2T=FCET+CW/(TWO*FCE)+ACET*UCET/FCE 
      C3T=FSET+CW/(TWO*FSE)+ASET*USET/FCE 
      CT =(USCT*C1T+UCET*C2T+USET*C3T)/(USCT+UCET+USET)
      C1R=FSCR+ASCR*(POPSC-USCT)
      C2R=FCER+ACER*(POPCE-UCET)
      C3R=FSER+ASER*(POPSE-USET)
      CR =((POPSC-USCT)*C1R+(POPCE-UCET)*C2R+(POPSE-USET)*C3R)/
     &    (POPSC+POPCE+POPSE-USCT-UCET-USET) 
      WRITE (*, '(11X,A5,4F8.2,5X,4F8.2,5X)')  'Costs', 
     &   C1T,C2T,C3T,CT,C1R,C2R,C3R,CR
      WRITE (*, '(11X,A5,3F8.2)') 'Freq.',FSC,FCE,FSE
      PRINT '(90A)', LINE1


      END







