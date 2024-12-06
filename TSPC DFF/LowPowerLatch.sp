*************************************************
**DFF4.sp
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

**Set the voltage node from voltage source, vdd, vss, current source
v_vdd		n_vdd		0		vdd
v_vss		n_vss		0		0
v_in		n_in		n_vss		pulse(0v	vdd	0	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p	1n) $ fclk=1GHz


** TSPC DFF
MP12    n_vdd   n_in   q_bar   n_vdd   pch L=pmos_l    W=pmos_w
MN12    nodeB   n_clk   q_bar   n_vss   nch L=nmos_l    W=nmos_w
MN13    n_vss   n_in   nodeB   n_vss   nch L=nmos_l    W=nmos_w

MP13    n_vdd   q_bar   n_q     n_vdd   pch L=pmos_l    W=pmos_w    
MN14    n_vss   q_bar   n_q     n_vss   nch L=nmos_l    W=nmos_w



.option post node list	

.tran	0.01p	100n 

* measure power
.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

.END
