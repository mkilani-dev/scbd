      SUBROUTINE CALCFC (N,M,X,F,CON)
C Used by COBYLA routine
C Computes aggregate cost and evaluate constraints
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE "param.inc"
      DIMENSION Z(14)
      DIMENSION X(*),CON(*)
      COMMON /PB/ NPROB 
      COMMON /VARS/ Z
      
C Some useful constants
      ZERO = 0.0D0
      ONE  = 1.0D0
      TWO  = 2.0D0 
C -------------------------------------------------------------------
C  Z (1:14) is a container for parameters passed between subroutines
C
C  Z(1:3)        NSC,   NCE,   NSE
C  Z(4:6)      TAUSC, TAUCE, TAUSE
C  Z(7:9)        PSC,   PCE,   PSE
C  Z(10:12)      FSC,   FCE,   FSE
C  Z(13;14)       AA,    BB
C
C   AA : ALPHA
C   BB : BETA
C ------------------------------------------------------------------- 
C  X(1) X(2) X(3) number of users
C  X(4) X(5) X(6) tolls
C  X(7) X(8) X(9) fares
C ------------------------------------------------------------------- 

      A1 = FSCR + ASCR * (POPSC - X(1))
      A2 = FCER + ACER * (POPCE - X(2))
      A3 = FSER + ASER * (POPSE - X(3))
      A4 = FSCT + CW / (TWO * Z(10)) + ASCT * (X(1) + X(3)) / Z(10)
      A5 = FCET + CW / (TWO * Z(11)) + ACET * (X(2) + X(3)) / Z(11)
      A6 = A4 + A5 - Z(13) * CW / (TWO * Z(11)) + (ONE - Z(13)) * SC 

      F = (POPSC - X(1)) * A1 + X(1) * A4 +
     1    (POPCE - X(2)) * A2 + X(2) * A5 +
     2    (POPSE - X(3)) * A3 + X(3) * A6 +
     3    PHI*(Z(10)+Z(11))+EF*Z(13)*Z(13)
      F = F / ( POPSC + POPCE + POPSE ) 

C The following constraints are always met

C  0 <= X(1) <= Nsc
      CON(1)  =  X(1)
      CON(2)  =  POPSC - X(1)
C  0 <= X(2) <= Nce
      CON(3)  =  X(2)
      CON(4)  =  POPCE - X(2)
C  0 <= X(3) <= Nse
      CON(5)  =  X(3)
      CON(6)  =  POPSE - X(3)
C  Equal costs for users sc
      CON(7)  =  X(4) + A1 - X(7) - A4
      CON(8)  = -X(4) - A1 + X(7) + A4
C  Equal costs for users ce
      CON(9)  =  X(5) + A2 - X(8) - A5
      CON(10) = -X(5) - A2 + X(8) + A5
C  Equal costs for users se
      CON(11) =  X(6) + A3 - X(9)  - A6
      CON(12) = -X(6) - A3 + X(9)  + A6 

      IF (NPROB.EQ.10) THEN
C Tolls are fixed
        CON(13) =   X(4) - Z(4)
        CON(14) = - X(4) + Z(4)
        CON(15) =   X(5) - Z(5)
        CON(16) = - X(5) + Z(5)
        CON(17) =   X(6) - Z(6)
        CON(18) = - X(6) + Z(6)
      ELSEIF (NPROB.EQ.11) THEN
C Fares are fixed
        CON(13) =   X(7) - Z(7)
        CON(14) = - X(7) + Z(7)
        CON(15) =   X(8) - Z(8)
        CON(16) = - X(8) + Z(8)
        CON(17) =   X(9) - Z(9)
        CON(18) = - X(9) + Z(9)
      ELSEIF (NPROB.EQ.12) THEN
C Tolls are fixed
        CON(13) =   X(4) - Z(4)
        CON(14) = - X(4) + Z(4)
        CON(15) =   X(5) - Z(5)
        CON(16) = - X(5) + Z(5)
        CON(17) =   X(6) - Z(6)
        CON(18) = - X(6) + Z(6)
        CON(19) = - DABS(X(9)) + DABS(Z(14) * ( X(7) + X(8) ))
      ENDIF 

      RETURN
      END

