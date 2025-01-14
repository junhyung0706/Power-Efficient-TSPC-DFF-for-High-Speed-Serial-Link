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
v_in		n_in		n_vss		pulse(0v	vdd	0	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p	1n) $ fclk=1GHz

** TSPC DFF with Keepers
*x_i8    n_clk   n_clk1  n_vdd n_vss inverter
*x_i9    n_clk1  n_clk2  n_vdd   n_vss   inverter

* ?λ¦¬μ°¨μ§? PMOS (?΄?­?΄ '0'?Ό ? ?λ¦¬μ°¨μ§?)
MP_pre	n_vdd	n_clk	nodeA	n_vdd	pch	L=pmos_l	W=pmos_w

* ?°?΄?° ?? ₯ NMOS (?΄?­?΄ '0'?Ό ? ??±?)
MN_data	n_vss	n_in	nodeA	n_vss	nch	L=nmos_l	W=nmos_w

* ?κ°? NMOS (?΄?­?΄ '1'?Ό ? ??±?)
MN_eval	nodeB	n_clk	nodeA	n_vss	nch	L=nmos_l	W=nmos_clk_w

* μΆλ ₯ λ²νΌ (?Έλ²ν° μ²΄μΈ)
x_i1	nodeB	    out1	n_vdd	n_vss	inverter
x_i2	out1	    n_qbar	    n_vdd	n_vss	inverter
x_i3	n_qbar	    n_q	    n_vdd	n_vss	inverter

.option post node list	

.tran	0.01p	100n 

.END
