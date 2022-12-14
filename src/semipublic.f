      SUBROUTINE SEMIPUBLIC (PRFT,PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE) 

      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION W(3000), IACT(51)
      INCLUDE 'param.inc' 

      NMAX = 50
      EPS  = 1.0D-6

      DO 10, I=1,NMAX
      
      USCT0 = USCT
      UCET0 = UCET
      USET0 = USET

C     PRINT '(9F8.3)', USCT, UCET,USET, TAUSC, TAUCE, TAUSE,PSC,PCE,BB

      CALL PRFROAD (PRFR,TC,USCT,UCET,USET,FSC,FCE,AA,
     1     PSC,PCE,BB,TAUSC,TAUCE,TAUSE) 

      ID = 10
      CALL DECENTRALIZE (FSC,FCE,AA,PSC,PCE,BB,
     1     TAUSC,TAUCE,TAUSE,USCT,UCET,USET,TC,ID) 

      DU = (USCT-USCT0)**2+(UCET-UCET0)**2+(USET-USET0)**2
      
      IF (DU.LT.EPS) GOTO 15

 10   CONTINUE

      PRINT *, 'No convergence after ', NMAX, ' iterations'

 15   CONTINUE

      RETURN
      END


