 *************************************************
**conventional_TSPC_DFF.sp
**conventional TSPC DFF code for REU 
**2024/06/25 LEE SUNA
*************************************************
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
v_in		n_in		n_vss		pulse(0v	vdd	0	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p	1n) $ fclk=1GHz


** TSPC DFF with Adaptive Body Bias
* P-C2MOS stage
mp_A1	n_vdd	n_in	n_a12	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mp_A2   n_a12   n_clk   n_x1    n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1
mn_A3	n_vss	n_in	n_x1 	0.5	    nch	l=nmos_l w=nmos_w nf=1 m=1

* N-precharge stage
mp_B0   n_vdd   n_x1    n_b01   n_vdd   pch l=pmos_l w=pmos_w nf=1 m=1
mp_B1	n_b01	n_clk	n_b12	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mp_B2   n_b12   n_x1    n_x2   n_vdd    pch	l=pmos_l w=pmos_w nf=1 m=1
mn_B3	n_b34	n_x1 	n_x2	0.5	    nch	l=nmos_l w=nmos_w nf=1 m=1
mn_B4	n_vss	n_clk	n_b34	0.5	    nch	l=nmos_l w=nmos_w nf=1 m=1

* X2 inverter
mn_inv4	n_vss		n_x2 		n_x2bar		0.5	    nch	l=nmos_l w=nmos_w nf=1 m=1
mp_inv4	n_vdd		n_x2 		n_x2bar		n_vdd   pch	l=pmos_l w=pmos_w nf=1 m=1

* N-C2MOS stage
mp_C1	n_vdd	n_x2bar	n_q	    n_vdd	pch	    l=pmos_l        w=pmos_w nf=1 m=1
mn_C2	n_c23	n_clk	n_q	    0.5	    nch	    l=nmos_clk_l    w=nmos_w nf=1 m=1
mn_C3   n_c34   n_x1    n_c23   0.5     nch     l=nmos_l        w=nmos_w nf=1 m=1
mn_C4   n_vss   n_x2bar n_c34   0.5     nch     l=nmos_l        w=nmos_w nf=1 m=1


.option post node list	

.tran	0.01p	100n 

.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

.END

