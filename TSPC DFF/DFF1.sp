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
v_in		n_in		n_vss		pulse(0v	vdd	0	trf	trf	5n	10n) $ a=10%
v_clk		n_clk		n_vss		pulse(0v	vdd	250p	trf	trf	500p	1n) $ fclk=1GHz


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

.tran	0.01p	100n 

.END

