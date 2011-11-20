# explicit wildcard expansion suppresses errors when no files are found

LIBRARY=chaos_toy.scad

TARGETS=$(shell ls *.scad | grep -v ${LIBRARY} | sed 's/\.scad/\.stl/')

all:	${TARGETS}

clean:
	rm -f *.stl *.deps

include $(wildcard *.deps)

%.stl:	%.scad
	openscad -m make -o $@ -d $@.deps $<
