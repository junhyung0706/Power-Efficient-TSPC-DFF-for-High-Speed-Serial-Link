*************************************************
**myDFF.sp 
**2024/11/05 Kim Junhyung
*************************************************
.lib '/home/lib/tsmc018.prm' TT

**Set the constant variables like vdd, vss, tstep
.param vdd = 1.8
.param trf = 10p
.param pmos_w = 0.22u
.param pmos_l = 0.18u
.param nmos_w = 0.22u
.param nmos_l = 0.18u
.TEMP UnknownVariable

**Set the voltage node from voltage source, vdd, vss, current source
v_vdd		n_vdd		0		vdd
v_vss		n_vss		0		0
v_in		n_in		n_vss		pulse(0v	vdd	0p	    trf	trf	5n	10n) $ a=50%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p 1n) $ fclk=1GHz


** TSPC DFF with Adaptive Body Bias
* P-C2MOS stage
mp_A1	n_vdd	n_clk	n_a12	    n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mp_A2   n_a12   n_in    n_x1        n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1
mn_A3	n_vss	n_in	n_x1 	    n_vss   nch	l=nmos_l w=nmos_w nf=1 m=1

* N-precharge stage
mp_B2   n_a12   n_x1    n_x2        n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1
mn_B3	n_b34	n_x1 	n_x2	    n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1
mn_B4	n_vss	n_clk	n_b34	    n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1

* X1 inverter
mn_inv1	n_vss   n_x1    n_x1bar		n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1
mp_inv1	n_vdd	n_x1 	n_x1bar		n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1

* N-C2MOS stage
mp_C1	n_vdd	n_x2    n_qbar	    n_vdd	pch	l=0.18u  w=0.22u nf=1 m=1
mn_C2	n_c23	n_x1bar	n_qbar	    n_vss	nch	l=0.18u  w=0.22u nf=1 m=1
mn_C3   n_b34   n_x2    n_c23       n_vss   nch l=0.18u  w=0.22u nf=1 m=1

* Qbar inverter
mn_inv2	n_vss   n_qbar  n_q		n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1
mp_inv2	n_vdd	n_qbar 	n_q		n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1

.option post node list	

.tran	0.01p	100n sweep UnknownVariable -100 200 20

* measure power
.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

.END
