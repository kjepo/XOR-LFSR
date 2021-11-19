# Fast random numbers for ARM using XOR LFSR

## Abstract
<p>
  A <i>LFSR</i> (linear feedback shift register) is a shift register
  where the input is a linear function of two or more bits (taps).
  An <i>XOR LFSR</i> is a linear feedback shift register which
  is implemented using XOR and shift operations which (not surprisingly)
  can execute very fast on modern processors, roughly a picosecond.
</p>
<p>
  An application of LFSR is pseudo random number generators.
  The included code shows both a 16-bit and a 64-bit
  random number generator written in ARM assembly,
  intended for a FORTH system where time and space is at a premium.
</p>

## Theory
<p>
  Starting with a non-zero initial value (the so-called <i>seed</i>)
  in the register, the XOR LFSR operation can produce a seemingly
  random (although obviously determinstic) sequence of values.
</p>

### 16-bit version

<pre>
lfsr = 0xACE1;
for (;;) {  
    lfsr ^= lfsr >> 7;
    lfsr ^= lfsr << 9;
    lfsr ^= lfsr >> 13;
    printf("%04X\n", lfsr);
}    
</pre>

<p>
  The 16-bit sequence will be 
</p>
<pre>
 DDBE D603 89AB F8BF 654D 6B84 CD55 52CD 826C 536A CBCA 705E 0CBE ...
</pre>
<p>
  The length of the cycle is actually 65535, i.e., all 16-bit integer values
  except 0 are generated exactly once.
</p>

### 64-bit version

<pre>
lfsr = 0xACE1;
for (;;) {  
    lfsr ^= lfsr << 13;
    lfsr ^= lfsr >> 7;
    lfsr ^= lfsr << 17;
    printf("%04X\n", lfsr);
}    
</pre>
<p>
  The 64-bit sequence will be 
</p>
<pre>
00002B6F7E47B5F8 3B3A90FC4ECF4493 CFD88934D0A59EDA 014FA87665762367 ...
</pre>

## Implementation
<p>
  Included is ARM assembly code for the above XOR LFSR operations, the
  central subroutines being <tt>RND16B</tt> and <tt>RND64B</tt>
  (see <tt>rnd16.s</tt> and <tt>rnd64.s</tt>, respectively.)
</p>
<pre>
RND16B:
        EOR   W0, W0, W0, ASR #7        ; W0 ^= W0 >> 7
        EOR   W0, W0, W0, LSL #9        ; W0 ^= W0 << 9;
        AND   X0, X0, #0xffff           ; clear upper 32 bits
        EOR   W0, W0, W0, ASR #13       ; W0 ^= W0 >> 13
        RET

RND64B:
	EOR   X0, X0, X0, LSL #13 ; X0 ^= X0 << 13
	EOR   X0, X0, X0, LSR #7  ; X0 ^= X0 >> 7
	EOR   X0, X0, X0, LSL #17 ; X0 ^= X0 << 17

</pre>
<p>
  That's it &mdash; only three (or four) instructions!
  (The syntax is for Mac OS X, you may have to change it for other platforms.)
</p>
<p>
  Both <tt>RND16B</tt> and <tt>RND64B</tt> assume that the previous
  state (or the initial seed) is stored in register <tt>X0</tt>.
  If you want, you can instead call <tt>RND16</tt>/<tt>RND64</tt>
  which stores the current state in memory between calls.
  (It will also return the next random number in <tt>X0</tt>.)
</p>
<p>
  The main program <tt>demo16</tt> generates 65535 random numbers.
  You can verify the cycle length and the number of unique numbers by
</p>
<pre>
  $ ./demo16 | sort -u | wc -l
  65535
</pre>

<p align="center">
  <img alt="Scatter plot" 
       src="https://github.com/kjepo/XOR-LFSR/blob/main/rnd-scatterplot.png">
  <br>
  <em>Scatter plot with the first 100 16-bit random values on the y-axis and x = 1 &hellip; 100</em>
</p>



## References

Wikipedia on LFSR
<br>
https://en.m.wikipedia.org/wiki/Linear-feedback_shift_register

Wikipedia on Xorshift
<br>
https://en.wikipedia.org/wiki/Xorshift

