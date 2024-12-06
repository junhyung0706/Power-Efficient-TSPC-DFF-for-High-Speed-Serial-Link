*******************************************************
**conventional_TSPC_DFF_spec.sp
**measure power, setup time, hold time... 
**2024/06/25 LEE SUNA
*******************************************************

.lib '/home/lib/tsmc018.prm' TT

**Set the constant variables like vdd, vss, tstep
.param vdd = 1.8 
.param trf = 10p
.param pmos_w = 0.54u
.param pmos_l = 0.18u
.param nmos_w = 0.36u
.param nmos_l = 0.18u
.param nmos_clk_l = 0.18u*2
.param tsu = 0p
**Set the voltage node from voltage source, vdd, vss, current source
v_vdd		n_vdd		0		vdd
v_vss		n_vss		0		0
v_in		n_in		n_vss		pulse(0v	vdd	'-tsu'	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p	1n) $ fclk=1GHz


** TSPC DFF
* P-C2MOS stage
mp_A1	n_vdd	n_in	n_a12	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mp_A2	n_a12	n_clk	n_a23	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mn_A3	n_vss	n_in	n_a23	n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1

* N-precharge stage
mp_B1	n_vdd	n_clk	n_b12	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mn_B2	n_b12	n_a23	n_b23	n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1
mn_B3	n_vss	n_clk	n_b23	n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1

* N-C2MOS stage
mp_C1	n_vdd	n_b12	n_c12	n_vdd	pch	l=pmos_l w=pmos_w nf=1 m=1
mn_C2	n_c23	n_clk	n_c12	n_vss	nch	l=nmos_clk_l w=nmos_w nf=1 m=1
mn_C3	n_vss	n_b12	n_c23	n_vss	nch	l=nmos_l w=nmos_w nf=1 m=1

* inverter
mn_inv1	n_vss		n_c12		n_q		n_vss	 	nch	l=nmos_l w=nmos_w nf=1 m=1
mp_inv1	n_vdd		n_c12		n_q		n_vdd		pch	l=pmos_l w=pmos_w nf=1 m=1

mn_inv2	n_vss		n_q		n_qb		n_vss	 	nch	l=nmos_l w=nmos_w nf=1 m=1
mp_inv2	n_vdd		n_q		n_qb		n_vdd		pch	l=pmos_l w=pmos_w nf=1 m=1

.option post node list	

.tran	0.01p	100n sweep tsu 0p 1n 0.01n

* measure power
.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

* measure tsu
.MEAUSRE TRAN tsu_value
+ TRIG v(n_in)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_clk)=0.9 rise=10 $ you have to modify 'rise=?' value

* measure clk to q delay
.MEASURE TRAN clk_to_q_delay
+ TRIG v(n_clk)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_out)=0.9 rise=10 $ you have to modify 'rise=?' value

* measure d to q delay
.MEASURE TRAN d_to_q_delay
+ TRIG v(n_in)=0.9 rise=5 $ you have to modify 'rise=?' value
+ TARG v(n_out)=0.9 rise=10 $ you have to modify 'rise=?' value


.END

