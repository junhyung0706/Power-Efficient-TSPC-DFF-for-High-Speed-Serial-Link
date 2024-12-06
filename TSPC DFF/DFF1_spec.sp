*************************************************
**DFF1.sp
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
.param nmos_clk_l = 0.18u*2

**Set the voltage node from voltage source, vdd, vss, current source
v_vdd		n_vdd		0		vdd
v_vss		n_vss		0		0
v_in		n_in		n_vss		pulse(0v	vdd	'-tsu'	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	0	trf	trf	500p	1n) $ fclk=1GHz


** TSPC DFF
*1st line of main DFF
MP11    n_vdd   n_in    nodeA  n_vdd   pch     L=pmos_l     W=pmos_w
MN12	nodeB   n_clk   nodeA  n_vss   nch     L=nmos_l     W=nmos_w
MN13    n_vss   n_in    nodeB  n_vss   nch     L=nmos_l     W=nmos_w
*2nd line of main DFF
MP21    n_vdd   nodeA   out1    n_vdd   pch    L=pmos_l     W=pmos_w
MN22    n_vss   nodeB   out1    n_vss   nch    L=nmos_l     W=nmos_w 
*3rd line of main DFF
x_i1    out1    out2    n_vdd   n_vss   inverter
x_i2    out2    n_q     n_vdd   n_vss   inverter

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

