      SUBROUTINE DECENTRALIZE (FSC,FCE,AA,PSC,PCE,BB,
     1             TAUSC,TAUCE,TAUSE,USCT,UCET,USET,TC,ID)
C 
C Compute optimal tolls or optimal fares (optimal means that
C we seek to reduce total cost)
C 
      IMPLICIT REAL*8 (A-H,O-Z) 
      DIMENSION Z(14), X(9), W(3000), IACT(51), CON(18)
      INCLUDE "param.inc"
      COMMON /PB/ NPROB
      COMMON /VARS/ Z 
C
C Set type of the problem 
C  ID = 10, find optimal fares (tolls given)
C  ID = 11, find optimal tolls (fares given)
C
      NPROB = ID

C Some useful constants
      ZERO=0.0D0
      ONE=1.0D0
      TWO=2.0D0

C The number of variables (N) and constraints (M)
      N = 9
      M = 18

C set parameters and vector block Z
      Z(4)  = TAUSC
      Z(5)  = TAUCE
      Z(6)  = TAUSE
      Z(7)  = PSC
      Z(8)  = PCE
      Z(14) = BB
      Z(10) = FSC
      Z(11) = FCE
      Z(13) = AA 

C set initial solutions
      X(1) = USCT 
      X(2) = USCE
      X(3) = USSE 
      X(4) = TAUSC
      X(5) = TAUCE
      X(6) = TAUSE
      X(7) = PSC
      X(8) = PCE
      X(9) = PSE 

C Set parameters for cobyla
      RHOBEG=3.5D0
      RHOEND=1.0D-9
      IPRINT=0
      MAXFUN=2000 

C Call cobyla routine
      CALL COBYLA(N,M,X,RHOBEG,RHOEND,IPRINT,MAXFUN,W,IACT,IERR) 

C     PRINT '(9F9.2)', X(1:9)
C     PRINT '(9F9.2)', Z(1:9)
      
      USCT  = X(1)
      UCET  = X(2)
      USET  = X(3)
      TAUSC = X(4)
      TAUCE = X(5)
      TAUSE = X(6)
      PSC   = X(7)
      PCE   = X(8)
      PSE   = X(9)
      BB    = PSE / ( PSC + PCE )

      CALL CALCFC(N,M,X,TC,CON)
C     PRINT '(9F9.2)', CON(1:9)
C     PRINT '(9F9.2)', CON(10:18)
C     CALL EQUILUSERS(X(1),X(2),X(3),Z(1),Z(2),Z(3),USCT,UCET,USET)
C     WRITE (*,'(4F9.4)') TC, USCT,UCET,USET 
C     WRITE (*,'(6F8.3)') TAUSC,TAUCE,TAUSE,PSC,PCE,BB 

      RETURN
      END



