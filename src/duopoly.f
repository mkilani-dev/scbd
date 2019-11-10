      SUBROUTINE DUOPOLY (PRFT,PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE)

      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION W(3000), IACT(51)
      INCLUDE 'param.inc'
      COMMON /PB/ NPROB
      COMMON /VARS/ Z
      
      NMAX = 50
      EPS  = 1.0D-6

      DO 10, I=1, NMAX 
      
      USCT0 = USCT
      UCET0 = UCET
      USET0 = USET

C     PRINT '(I5,3F8.3)', I, USCT, UCET,USET

      CALL PRFROAD (PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1     PSC,PCE,BB,TAUSC,TAUCE,TAUSE) 

      CALL PRFTRAIN (PRFT,TC,USCT,UCET,USET,FSC,FCE,AA,
     1     PSC,PCE,BB,TAUSC,TAUCE,TAUSE) 

      DU = (USCT-USCT0)**2+(UCET-UCET0)**2+(USET-USET0)**2
      
      IF (DU.LT.EPS) GOTO 15

 10   CONTINUE

      PRINT *, 'No convergence after ', NMAX, ' iterations'

 15   CONTINUE

      RETURN
      END





