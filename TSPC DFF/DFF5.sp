*************************************************
**DFF5.sp
**DFF4?�� 첫번�? ?��?�� �??��?�� ?��?���??��?�� ?��?��. 
**?��버터?�� ?��?���? ?��?��?��?��?��,
**10% ?��?��?�� ?��?��즈�?? ?��?��?��?�� ?��질적?�� 문제�? ?��?��?���? ?��?��?���?, 
**?��?�� ?��?��?�� ?��?��?��?���? 고려?��?�� 것이 ?��리적?�� ?�� ?��?��?��?��.
*************************************************
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


** TSPC DFF
MP_1	n_vdd	n_in	nodeA	n_vdd	pch	L=pmos_l	W=pmos_w
MN_2    n_vss   n_in    nodeA   n_vss   nch L=nmos_l    W=nmos_w

MN_3	nodeB	n_clk	nodeA	n_vss	nch	L=nmos_l	W=nmos_clk_w

* 출력 버퍼 (?��버터 체인)
MN_i1	n_vss	nodeB	n_q	n_vss	nch	L=0.18u	W=0.36u			 
MP_i1	n_vdd	nodeB	n_q	n_vdd	pch	L=0.18u	W=0.54u	


.option post node list	

.tran	0.01p	100n 

* measure power
.MEASURE TRAN dff_power AVG P(v_vdd) from=50n to=100n

.END
