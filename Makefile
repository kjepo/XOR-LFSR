SRC=RND
$(SRC): $(SRC).s  kprint.s pushpop.s kload.s printhexword.s sysexit.s
	cc -arch arm64 -o $@ $<
clean:
	rm $(SRC)
