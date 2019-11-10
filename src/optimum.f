      SUBROUTINE OPTIMUM (TC,USCT,UCET,USET,FSC,FCE,FSE,AA,
     1              PSC,PCE,BB,TAUSC,TAUCE,TAUSE,ID)

C  ID = 1,  withour direct SE train
C  ID = 10, with    direct SE train
      IMPLICIT REAL*8 (A-H,O-Z)

      DIMENSION Z(13), X(3), W(3000), IACT(51)
      DIMENSION XL(3), XU(3)
      INCLUDE "param.inc"
      COMMON /PB/ NPROB
      COMMON /VARS/ Z

      ZERO=0.0D0
      ONE=1.0D0
      TWO=2.0D0

      NPROB=ID 

      N=3
      NPT=N+2

      Z(10) = FSC
      Z(11) = FCE
      Z(12) = FSE
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
      RHOBEG=5.0D-1
      RHOEND=1.0D-6
      IPRINT=0
      MAXFUN=2000

C Call BOBYQA routine
      CALL BOBYQA (N,NPT,X,XL,XU,RHOBEG,RHOEND,IPRINT,MAXFUN,W,IACT)
      USCT = X(1)
      UCET = X(2)
      USET = X(3)

      TAUSC=FSCT+CW/(TWO*Z(10))+ASCT*(X(1)+X(3))/Z(10)-
     1      FSCR-ASCR*(POPSC-X(1))
      TAUCE=FCET+CW/(TWO*Z(11))+ACET*(X(2)+X(3))/Z(11)-
     1      FCER-ACER*(POPCE-X(2))
      TAUSE=FSCT+CW/(TWO*Z(10))+ASCT*(X(1)+X(3))/Z(10)+
     1      FCET+CW/(TWO*Z(11))+ACET*(X(2)+X(3))/Z(11)-
     2      Z(13)*CW/(TWO*Z(11))+(ONE-Z(13))*SC-
     3      FSER-ASER*(POPSE-X(3))
      PSC=-TAUSC
      PCE=-TAUCE
      IF(ID.EQ.1) THEN 
      BB=(FSER+ASER*(POPSE-X(3))-(
     1              FSCT+CW/(TWO*Z(10))+ASCT*(X(1)+X(3))/Z(10)+
     2              FCET+CW/(TWO*Z(11))+ACET*(X(2)+X(3))/Z(11)-
     3              Z(13)*CW/(TWO*Z(11))+(ONE-Z(13))*SC))/(PSC+PCE)
      ELSEIF(ID.EQ.10) THEN
      TAUSC=FSCT+CW/(TWO*Z(10))+ASCT*(X(1))/Z(10)-
     1      FSCR-ASCR*(POPSC-X(1))
      TAUCE=FCET+CW/(TWO*Z(11))+ACET*(X(2))/Z(11)-
     1      FCER-ACER*(POPCE-X(2))
      TAUSE=FSET+CW/(TWO*Z(12))+ASET*(X(3))/Z(12)-
     1      FSER-ASER*(POPSE-X(3))
      PSC=-TAUSC
      PCE=-TAUCE 
      BB =-TAUSE
      ENDIF
      CALL CALFUN(N,X,F)
      TC = F 

      RETURN
      END
