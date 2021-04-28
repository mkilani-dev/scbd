# general setting
FC = gfortran
FFLAGS = -O

# Subdirectories where to look for source files
VPATH = src cobyla bobyqa

# Main programs
all: scbd f_scbd

scbd: main.o calfun.o calcfc.o param.o equilibrium.o optimum.o prfroad.o \
	    prftrain.o semipublic.o duopoly.o decentralize.o betafixed.o \
	    prelim.o rescue.o trsbox.o update.o altmov.o bobyqa.o bobyqb.o \
      trstlp.o cobylb.o cobyla.o
	$(FC) $(FFLAGS) -o scbd main.o calcfc.o calfun.o param.o equilibrium.o \
		optimum.o prfroad.o prftrain.o semipublic.o duopoly.o decentralize.o betafixed.o \
	  prelim.o rescue.o trsbox.o update.o altmov.o bobyqa.o bobyqb.o \
  	trstlp.o cobylb.o cobyla.o 

f_scbd: f_main.o calfun.o calcfc.o param.o equilibrium.o optimum.o prfroad.o \
	    prftrain.o semipublic.o duopoly.o decentralize.o betafixed.o \
	    prelim.o rescue.o trsbox.o update.o altmov.o bobyqa.o bobyqb.o \
      trstlp.o cobylb.o cobyla.o
	$(FC) $(FFLAGS) -o f_scbd f_main.o calcfc.o calfun.o param.o equilibrium.o \
		optimum.o prfroad.o prftrain.o semipublic.o duopoly.o decentralize.o betafixed.o \
	  prelim.o rescue.o trsbox.o update.o altmov.o bobyqa.o bobyqb.o \
  	trstlp.o cobylb.o cobyla.o 

# Compile main routines
main.o: main.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

f_main.o: f_main.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

calfun.o: calfun.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

calcfc.o: calcfc.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

param.o: param.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

equilibrium.o: equilibrium.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

optimum.o: optimum.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

prfroad.o: prfroad.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

prftrain.o: prftrain.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $<

semipublic.o: semipublic.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $< 

duopoly.o: duopoly.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $< 

decentralize.o: decentralize.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $< 

betafixed.o: betafixed.f param.inc
	$(FC) $(FFLAGS) -o $@ -c $< 
 
# Compile BOBYQA optimization library
altmov.o: altmov.f
	$(FC) $(FFLAGS) -o $@ -c $<

bobyqa.o: bobyqa.f
	$(FC) $(FFLAGS) -o $@ -c $< 

bobyqb.o: bobyqb.f
	$(FC) $(FFLAGS) -o $@ -c $<

prelim.o: prelim.f
	$(FC) $(FFLAGS) -o $@ -c $<

rescue.o: rescue.f
	$(FC) $(FFLAGS) -o $@ -c $<

trsbox.o: trsbox.f
	$(FC) $(FFLAGS) -o $@ -c $<

update.o: update.f
	$(FC) $(FFLAGS) -o $@ -c $<

# Compile COBYLA optimization library
cobyla.o: cobyla.f
	$(FC) $(FFLAGS) -o $@ -c $<

cobylb.o: cobylb.f
	$(FC) $(FFLAGS) -o $@ -c $< 

trstlp.o: trstlp.f
	$(FC) $(FFLAGS) -o $@ -c $<


# clean files
clean:
	rm -f *.o



