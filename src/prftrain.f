      SUBROUTINE PRFTRAIN (PRFT,TC,USCT,UCET,USET,FSC,FCE,AA,
     1                     PSC,PCE,BB,TAUSC,TAUCE,TAUSE)
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION Z(14), X(3), XL(3), XU(3)
      DIMENSION W(3000), IACT(51)
      INCLUDE 'param.inc'
      COMMON /PB/ NPROB
      COMMON /VARS/ Z


      ZERO = 0.0D0
      ONE  = 1.0D0
      TWO  = 2.0D0
      
C Indicate that the objective is to maximize
C the profit of the train operator
      NPROB=4

      Z(4) = TAUSC
      Z(5) = TAUCE
      Z(6) = TAUSE
      Z(10) = FSC
      Z(11) = FCE
      Z(13) = AA 
      
C INITIAL CONDITION
      X(1)=POPSC/TWO
      X(2)=POPCE/TWO
      X(3)=POPSE/TWO

C SET BOUNDS FOR VARIABLES
      XL(1)=ZERO
      XL(2)=ZERO
      XL(3)=ZERO
      XU(1)=POPSC
      XU(2)=POPCE
      XU(3)=POPSE

C SET PARAMETERS FOR BOBYQA
      N=3
      NPT=N+2
      RHOBEG=5.D0
      RHOEND=1.0D-6
      IPRINT=0
      MAXFUN=2000

      CALL BOBYQA (N,NPT,X,XL,XU,RHOBEG,RHOEND,IPRINT,MAXFUN,W,IACT) 

      USCT = X(1)
      UCET = X(2)
      USET = X(3)

      PSC = Z(7)
      PCE = Z(8)
      BB  = Z(14)

      CALL CALFUN(N,X,F)
      PRFT = -F

      NPROB = 1
      CALL CALFUN(N,X,F)
      TC = F 
      
      RETURN
      END

      
