*************************************************
**DFF2.sp
*************************************************
.include "/home/under_design6/hspice/mysource/inverter.sp"
.lib '/home/lib/tsmc018.prm' TT

**Set the constant variables like vdd, vss, tstep
.param vdd = 1.8 
.param trf = 10p
.param pmos_w = 0.54u
.param pmos_l = 0.18u
.param nmos_w = 0.36u
.param nmos_l = 0.18u
.param nmos_clk_w = 0.36u

**Set the voltage node from voltage source, vdd, vss, current source
v_vdd		n_vdd		0		vdd
v_vss		n_vss		0		0
v_in		n_in		n_vss		pulse(0v	vdd	'-tsu'	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	0	trf	trf	500p	1n) $ fclk=1GHz


** TSPC DFF
* ?îÑÎ¶¨Ï∞®Ïß? PMOS (?Å¥?ü≠?ù¥ '0'?ùº ?ïå ?îÑÎ¶¨Ï∞®Ïß?)
MP_pre	n_vdd	n_clk	nodeA	n_vdd	pch	L=pmos_l	W=pmos_w

* ?ç∞?ù¥?Ñ∞ ?ûÖ?†• NMOS (?Å¥?ü≠?ù¥ '0'?ùº ?ïå ?ôú?Ñ±?ôî)
MN_data	n_vss	n_in	nodeA	n_vss	nch	L=nmos_l	W=nmos_w

* ?èâÍ∞? NMOS (?Å¥?ü≠?ù¥ '1'?ùº ?ïå ?ôú?Ñ±?ôî)
MN_eval	nodeB	n_clk	nodeA	n_vss	nch	L=nmos_l		W=nmos_clk_w

* Ï∂úÎ†• Î≤ÑÌçº (?ù∏Î≤ÑÌÑ∞ Ï≤¥Ïù∏)
x_i1	nodeB	    out1	n_vdd	n_vss	inverter
x_i2	out1	    n_qbar	    n_vdd	n_vss	inverter
x_i3	n_qbar	    n_q	    n_vdd	n_vss	inverter

.option post node list	

.tran	0.01p	100n sweep tsu 0p 1n 0.01n

* measure power
.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

* measure tsu
.MEAUSRE TRAN tsu_value
+ TRIG v(n_in)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_clk)=0.9 rise=2 $ you have to modify 'rise=?' value

* measure clk to q delay
.MEASURE TRAN clk_to_q_delay
+ TRIG v(n_clk)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_out)=0.9 rise=2 $ you have to modify 'rise=?' value

* measure d to q delay
.MEASURE TRAN d_to_q_delay
+ TRIG v(n_in)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_out)=0.9 rise=2 $ you have to modify 'rise=?' value


.END

