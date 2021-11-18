# Fast randoms for ARM assembler using XOR LFSR

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
  The included code shows a 16-bit random number generator written
  in ARM assembly, intended for a FORTH system where time and
  space is at a premium.
</p>

## Theory
<p>
  Starting with a non-zero initial value (the so-called <i>seed</i>)
  in the register, the XOR LFSR operation can produce a seemingly
  random (although obviously determinstic) sequence of values.
</p>
<pre>
lfsr = 0xACE1;
lfsr ^= lfsr >> 7;
lfsr ^= lfsr << 9;
lfsr ^= lfsr >> 13;
</pre>
<p>
  With the above numbers (7, 9, 13) the sequence will be
</p>
<pre>
ACE1 DDBE D603 90AB F8BF 654D 6B84 ...
</pre>
<p>
  The length of the cycle is actually 65535, i.e., all 16-bit integer values
  are generated exactly once.
</p>

## Implementation
<p>
  Included is ARM assembly code for the above XOR LFSR operation, the
  central subroutine being <tt>RND16B</tt>
</p>
<pre>
RND16B:
        EOR   W0, W0, W0, ASR #7        ; W0 ^= W0 >> 7
        EOR   W0, W0, W0, LSL #9        ; W0 ^= W0 << 9;
        AND   X0, X0, #0xffff           ; clear upper 32 bits
        EOR   W0, W0, W0, ASR #13       ; W0 ^= W0 >> 13
        RET
</pre>
<p>
  That's it &mdash; only four instructions!
  (The syntax is for Mac OS X, you may have to change it for other platforms.)
</p>
<p>
  <tt>RND16B</tt> assumes that the previous state (or the initial seed)
  is stored in register <tt>W0</tt>.
  If you want, you can instead call <tt>RND16</tt> which stores the current
  state in memory between calls.  (It will also return the next random number
  in <tt>W0</tt>.)
</p>
<p>
  The main program generates 65535 random numbers. You can verify the cycle length
  and the number of unique numbers by
</p>
<pre>
  $ ./RND | sort -u | wc -l
  65535
</pre>

## References

Wikipedia on LFSR
<br>
https://en.m.wikipedia.org/wiki/Linear-feedback_shift_register
