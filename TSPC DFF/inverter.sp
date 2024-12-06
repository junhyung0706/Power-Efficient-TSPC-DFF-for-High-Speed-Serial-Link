******************************************************************************
**inverter.sp
**draw vout-vin graph in tsmc018 cmos inverter
******************************************************************************

**The first line should be the comment line
**No differences between Capital letter or not


.LIB '/home/lib/tsmc018.prm' TT 	$ Typical: normal vth in nmos, pmos
*.lib '/home/lib/tsmc018.prm' FF	$ Fast: low vth in nmos, pmos
*.lib '/home/lib/tsmc018.prm' SS	$ slow: high vth in nmos, pmos
.TEMP 25				$ room temperature Celsius scale
.PARAM vdd = 1.8			$ parameter


.OPTION POST NODE LIST 			$ to use AVANWAVE after simulation


VDD		n_vdd	0	'vdd'		$ dc voltage source
VSS		n_vss	0	0		
*Vdummy 	n_1	n_2	0		$ a dummy voltage source which the value is 0 to check the current at node
*IIN		n_1	n_2	10u		$ dc current source
VIN		n_in 	0 	0		
*VIN		n_in	0	PULSE	(0 'vdd' 49n 1n 1n 50n 100n)
*'0v to vdd' is peak to peak pulse voltage's amplitude
*'49n' is delay time to be vdd from 0V
*'1n 1n' is rising time and falling time respectively
*'50n' is stay time when the signal is vdd
*'100n' is the time of period


MN	n_vss	n_in	n_out	n_vss	nch	L=0.18u	W=0.36u			 
MP	n_vdd	n_in	n_out	n_vdd	pch	L=0.18u	W=0.54u			
*m1	drain	gate	source	body	nch	l=0.18u	w=0.36u	nf=1 m=1 	
*m2	drain	gate 	source	body	pch	l=0.18u w=0.54u nf=1 m=1 
*'nf': number of finger (total width = W)
*'m' : multiplier       (total width = W*m)


*r_example 	n_1		n_2		1k  $ 1 kilo ohm of resistance
*c_example 	n_1		n_2		1n  $ 1 nano farrad of capacitance
*l_example 	n_1		n_2		1n  $ 1 nano henry of inductor


.DC 	VIN  	0 	'vdd' 	0.001 		    $ dc sweep 0V to 'vdd' at 0.001V step
*.AC 	DEC 	10 	100 	1g		    $ ac sweep 100Hz to 1GHz at 10Hz step 
*.TRAN 	1p 	100n 				    $ transient sweep until 100u at 1ps step


*.ic v(n_out)=0	 				$ initial conditioni


*To check the simulation file, there are 3 method. '.print', '.probe', '.option post'
*'.print' : Show the result as ASCII form log file in .chi after simulation
*'.option post' and '.probe' : Show the result the binary format file in .cou which can check in AVANWAVE after simulation


*.measure tran OUTPUT_NAME0 avg p(v_vdd) from 90u to 91u *Average of v_vdd 'power' from 90u to 91u. The output context 'OUTPUT_NAME0' is on .mt file after simulation.
*.measure tran OUTPUT_NAME0 avg v(v_vdd) from 90u to 91u *Average of v_vdd 'voltage' from 90u to 91u. The output context 'OUTPUT_NAME0' is on .mt file after simulation.
*.measure tran OUTPUT_NAME0 avg i(v_vdd) from 90u to 91u *Average of v_vdd 'current' from 90u to 91u. The output context 'OUTPUT_NAME0' is on .mt file after simulation.


.END


*In LINUX terminal you type the command to simulate the hspice file
*hspice inverter.sp -o -d
*hspice : simulte operate command
*inverter.sp : target file
*-o : make output file
*-d : show the transient procedure on display




