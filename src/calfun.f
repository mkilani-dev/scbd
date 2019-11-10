      SUBROUTINE CALFUN (N,X,F)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE "param.inc"
      DIMENSION Z(14)
      DIMENSION X(*)
      COMMON /PB/ NPROB 
      COMMON /VARS/ Z
      
C Some constants in double precision
      ZERO = 0.0D0
      ONE  = 1.0D0
      TWO  = 2.0D0

C
C The variables passed in X and Z vectors

C -------------------------------------------------------------------
C  Z (14) is a container for parameters passed between subroutines
C
C  Z(1:3)        NSC,   NCE,   NSE
C  Z(4:6)      TAUSC, TAUCE, TAUSE
C  Z(7:9)        PSC,   PCE,   PSE
C  Z(10:12)      FSC,   FCE,   FSE
C  Z(13:14)       AA,    BB
C
C   AA : ALPHA
C   BB : BETA
C -------------------------------------------------------------------



      IF (NPROB.EQ.1) THEN
C
C     COMPUTE THE AVERAGE TOTAL COST (THE OPTIMUM)
C
      A=CW/(TWO*Z(10))+FSCT+ASCT*(X(1)+X(3))/Z(10)
      B=CW/(TWO*Z(11))+FCET+ACET*(X(2)+X(3))/Z(11)

      F=X(1)*A+(POPSC-X(1))*(FSCR+ASCR*(POPSC-X(1)))+
     1  X(2)*B+(POPCE-X(2))*(FCER+ACER*(POPCE-X(2)))+
     2  X(3)*(A+B-Z(13)*(CW/(TWO*Z(11)))+(ONE-Z(13))*SC)+
     3  (POPSE-X(3))*(FSER+ASER*(POPSE-X(3)))+
     4  PHI*(Z(10)+Z(11))+EF*Z(13)*Z(13)
      F=F/(POPSC+POPCE+POPSE) 


      ELSE IF (NPROB.EQ.2) THEN
C
C  COMPUTE THE BECKMAN FUNCTION - THE EQUILIBROIUM
C  IS THE MINIMUM OF THIS FUNCTION
C 
      F = ZERO
      F = F + BECKMAN ( Z(4) + FSCR, ASCR, POPSC - X(1) )
      F = F + BECKMAN ( Z(5) + FCER, ACER, POPCE - X(2) )
      F = F + BECKMAN ( Z(6) + FSER, ASER, POPSE - X(3) )
      F = F + BECKMAN ( Z(7) + FSCT + CW / ( TWO * Z(10) ), 
     +                  ASCT / Z(10), X(1) + X(3) )
      F = F + BECKMAN ( Z(8) + FCET + CW / ( TWO * Z(11) ), 
     +                  ACET / Z(11), X(2) + X(3) )
      F = F - BECKMAN ( Z(13) * CW / ( TWO * Z(11) )-(ONE-Z(13) ) * SC +
     +                  (ONE - Z(14)) * (Z(7)+Z(8)), ZERO, X(3) )
      F=F/(POPSC+POPCE+POPSE) 


      ELSE IF (NPROB.EQ.3) THEN
C
C  PROFIT OF THE MANAGER OF THE ROADS
C
      Z(4) = Z(7)+CW/(TWO*Z(10))+FSCT+ASCT*(X(1)+X(3))/Z(10)-
     1         FSCR-ASCR*(POPSC-X(1))
      Z(5) = Z(8)+CW/(TWO*Z(11))+FCET+ACET*(X(2)+X(3))/Z(11)-
     1         FCER-ACER*(POPCE-X(2))
      Z(6) = CW/(TWO*Z(10))+FSCT+ASCT*(X(1)+X(3))/Z(10)+
     1       CW/(TWO*Z(11))+FCET+ACET*(X(2)+X(3))/Z(11)+
     2       Z(14)*(Z(7)+Z(8))-Z(13)*CW/(TWO*Z(11))+(ONE-Z(13))*SC-
     3       FSER-ASER*(POPSE-X(3))

      F=-(Z(4)*(POPSC-X(1))+Z(5)*(POPCE-X(2))+Z(6)*(POPSE-X(3)))

      ELSE IF (NPROB.EQ.4) THEN 
C
C  PROFIT OF THE MANAGER OF PUBLIC TRANSPORT
C     

      Z(7 ) = -CW/(TWO*Z(10))-FSCT-ASCT*(X(1)+X(3))/Z(10)+
     1         FSCR+ASCR*(POPSC-X(1))+Z(4)
      Z(8 ) = -CW/(TWO*Z(11))-FCET-ACET*(X(2)+X(3))/Z(11)+
     1         FCER+ACER*(POPCE-X(2))+Z(5)
      Z(14) =(-CW/(TWO*Z(10))-FSCT-ASCT*(X(1)+X(3))/Z(10)-
     1         CW/(TWO*Z(11))-FCET-ACET*(X(2)+X(3))/Z(11)+
     2         Z(13)*CW/(TWO*Z(11))-(ONE-Z(13))*SC+
     3         Z(6)+FSER+ASER*(POPSE-X(3)))/(Z(7)+Z(8)) 

C To add : - AA * EF - (FSC+FCE) * PHI
      F=-(Z(7)*X(1)+Z(8)*X(2)+Z(14)*(Z(7)+Z(8))*X(3))

      ELSEIF (NPROB.EQ.10) THEN
C
C     COMPUTE THE AVERAGE TOTAL COST (THE OPTIMUM)
C
      A=CW/(TWO*Z(10))+FSCT+ASCT*X(1)/Z(10)
      B=CW/(TWO*Z(11))+FCET+ACET*X(2)/Z(11)
      C=CW/(TWO*Z(12))+FSET+ASET*X(3)/Z(12)

      F=X(1)*A+(POPSC-X(1))*(FSCR+ASCR*(POPSC-X(1)))+
     1  X(2)*B+(POPCE-X(2))*(FCER+ACER*(POPCE-X(2)))+
     2  X(3)*C+(POPSE-X(3))*(FSER+ASER*(POPSE-X(3)))+
     4  PHI*(Z(10)+Z(11)+Z(12))
      F=F/(POPSC+POPCE+POPSE) 

      ELSE IF (NPROB.EQ.11) THEN
C
C  COMPUTE THE BECKMAN FUNCTION - THE EQUILIBROIUM
C  IS THE MINIMUM OF THIS FUNCTION
C 
      F = ZERO
      F = F + BECKMAN ( Z(4) + FSCR, ASCR, POPSC - X(1) )
      F = F + BECKMAN ( Z(5) + FCER, ACER, POPCE - X(2) )
      F = F + BECKMAN ( Z(6) + FSER, ASER, POPSE - X(3) )
      F = F + BECKMAN ( Z(7) + FSCT+CW/(TWO*Z(10)), ASCT / Z(10), X(1) )
      F = F + BECKMAN ( Z(8) + FCET+CW/(TWO*Z(11)), ACET / Z(11), X(2) )
      F = F + BECKMAN ( Z(9) + FSET+CW/(TWO*Z(12)), ASET / Z(12), X(3) )
      F=F/(POPSC+POPCE+POPSE) 

      ENDIF 

      RETURN
      END
 


      FUNCTION BECKMAN (F,A,X)
      IMPLICIT REAL*8 (A-H,O-Z)
      
      BECKMAN = X * ( F + A * X / 2.0D0 )

      RETURN
      END
      
      
      
