LIBS=kprint.s pushpop.s kload.s printhex.s sysexit.s rnd16.s rnd64.s
demo64: demo64.s $(LIBS)
	cc -arch arm64 -o $@ $<
demo16: demo16.s $(LIBS)
	cc -arch arm64 -o $@ $<
clean:
	rm -f demo64 demo16 *~
