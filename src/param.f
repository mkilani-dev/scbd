
      subroutine param(filen,psc,pce,pse,bb,tausc,tauce,tause,
     1   fsc,fce,fse,aa)
C     implicit none
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE "param.inc"

      character(len=8) filen
C     double precision psc,pce,tausc,tauce,tause,theta,val,dRsc
C     double precision dRce,dRse,dTsc,dTce,dTse,fsc,fce,fse,Nsc,Nce
C     double precision sRsc,sRce,sRse,sTsc,sTce
C     double precision Nse,asct,acet,aset,ascr,acer,aser,cw,phi
C     double precision alpha,beta,sc,gama
      integer i,N
      character(len=30) line,ln,varname
C     double precision var,varvalue

      PRINT *, filen

      open(unit=1,file=filen)
1     read(1,'(a30)',end=3) LINE
      n=scan(line,'#',.false.) 
      if(n.GT.0) goto 1
      n=scan(line,'=',.false.)
      if(n.eq.0) goto 1
      read(line(1:n-1),'(a5)') varname
      read(line(n+1:40),*) varvalue

      if(varname.eq."psc") then
        psc=varvalue
      elseif(varname.eq."pce") then
        pce=varvalue
      elseif(varname.eq."tausc") then
        tausc=varvalue
      elseif(varname.eq."tauce") then
        tauce=varvalue
      elseif(varname.eq."tause") then
        tause=varvalue
      elseif(varname.eq."theta") then
        theta=varvalue
      elseif(varname.eq."val") then
        val=varvalue
      elseif(varname.eq."dRsc") then
        dRsc=varvalue
      elseif(varname.eq."dRce") then
        dRce=varvalue
      elseif(varname.eq."dRse") then
        dRse=varvalue
      elseif(varname.eq."dTsc") then
        dTsc=varvalue
      elseif(varname.eq."dTce") then
        dTce=varvalue
      elseif(varname.eq."dTse") then
        dTse=varvalue
      elseif(varname.eq."sRsc") then
        sRsc=varvalue
      elseif(varname.eq."sRce") then
        sRce=varvalue
      elseif(varname.eq."sRse") then
        sRse=varvalue
      elseif(varname.eq."sTsc") then
        sTsc=varvalue
      elseif(varname.eq."sTce") then
        sTce=varvalue
      elseif(varname.eq."sTse") then
        sTse=varvalue
      elseif(varname.eq."fsc") then
        fsc=varvalue
      elseif(varname.eq."fce") then
        fce=varvalue
      elseif(varname.eq."fse") then
        fse=varvalue
      elseif(varname.eq."Nsc") then
        POPSC=varvalue
      elseif(varname.eq."Nce") then
        POPCE=varvalue
      elseif(varname.eq."Nse") then
        POPSE=varvalue
      elseif(varname.eq."asct") then
        asct=varvalue
      elseif(varname.eq."acet") then
        acet=varvalue
      elseif(varname.eq."aset") then
        aset=varvalue
      elseif(varname.eq."ascr") then
        ascr=varvalue
      elseif(varname.eq."acer") then
        acer=varvalue
      elseif(varname.eq."aser") then
        aser=varvalue
      elseif(varname.eq."cw") then
        cw=varvalue
      elseif(varname.eq."phi") then
        phi=varvalue
      elseif(varname.eq."alpha") then
        aa=varvalue
      elseif(varname.eq."beta") then
        bb=varvalue
      elseif(varname.eq."sc") then
        sc=varvalue
      elseif(varname.eq."gama") then
        gg=varvalue
      elseif(varname.eq."ef") then
        ef=varvalue
      endif 

      goto 1
      
3     continue
      

      return
      end
