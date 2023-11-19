# Farid_Najm_Projects
### MATLAB Implementation of the computer project of "Circuit Simulation" book by Farid Najm  
<details>
  <summary> 

### Chapter 1 Project: Parser
  </summary>
  
* Write a parser that can read a circuit specification in terms of a simple “language”: 
  * Voltage Source: V[int] [node.+] [node.-] [[value]]   <br />
  * Current Source: I[int] [node.+] [node.-] [value] [[G2]]  <br />
  * Resistor: R[int] [node.+] [node.-] [value] [[G2]]  <br />
  * Capacitor: C[int] [node.+] [node.-] [value] [[G2]]  <br />
  * Inductor: L[int] [node.+] [node.-] [value]  <br />
  * Diode:  D[int] [node.+] [node.-] [[value]]  <br />
  * NPN BJT QN[int] [node.C] [node.B] [node.E] [[value]]  <br />
  * PNP BJT  QP[int] [node.C] [node.B] [node.E] [[value]]  <br />
  * NCH-MOSFET MN[int] [node.D] [node.G] [node.S] [[value]]  <br />
  * PCH-MOSFET MP[int] [node.D] [node.G] [node.S] [[value]]  <br />
* Notes:  <br />
  * Inputs between double square brackets are optional.  <br />
  * Nodes must be consecutive numbers 0,1,...,n.  <br />
  * Node 0 is ground.  <br />
* Implementation: function parser.m  <br />
  * Input: netlist file  <br />
  * Output: MATLAB struct that contains all the circuit records.  <br />
  * How to run: parser(netlist_file)  <br />
  * Example: Circuit = parser('parser_test.txt');
</details>
<details>
  <summary> 
    
  ### Chapter 2 & 3 Projects: Build MNA Matrix and Solve MNA Linear System
  </summary>

* Implement a program to solve linear resistive circuits  <br />
  1. Use the parser -implemented in Ch1 project- to parse the netlist   <br />
  2. Build the MNA matrix using the stamps of the circuit elements  <br />
  3. Solve the MNA system  <br />
* Implementation: function linear_solver_tb.m  <br />
  * Input: netlist file  <br />
  * Output: Vector of values of the unknown vector of MNA system  <br />
  * How to run: linear_solver_tb(netlist_file)  <br />
  * Example: x = linear_solver_tb('parser_test.txt');  <br />
* Test:  <br />
  * Test circuit diagram:  <br />
      <picture>
         <img alt="Linear Circuit Diagram" src="pics/linear_test_circuit_diagram.PNG?raw=true">
      </picture> <br />
  * Test circuit netlist:  <br />
        <picture>
           <img alt="Linear Circuit Netlist" src="pics/linear_test_circuit_netlist.PNG?raw=true">
        </picture> <br />
  * Results: <br />
  
      | Unknown       | Reference from book     | Result       |
      | ------------- |:-----------------------:|:------------:|
      | V(1)          | 1.88527 V               | 1.885272   V |
      | V(2)          | 1.80879 V               | 1.808787   V |
      | V(3)          | 2.00879 V               | 2.008787   V |
      | V(4)          | 1.9888  V               | 1.988799   V |
      | V(5)          | 2       V               | 2.000000   V |
      | V(6)          | 1.98814 V               | 1.988143   V |
      | V(7)          | 3.98814 V               | 3.988143   V |
      | V(8)          | 1       V               | 1.000000   V |
      | I(V1)         | -198.88 mA              | -0.1988799 A |
      | I(V2)         | -199.88 mA              | -0.1998799 A |
      | I(V3)         | 0       A               | 6.6613e-16 A |
      | I(R3)         | 3.82    mA              | 0.00382426 A |
      | I(R8)         | 198.88  mA              | 0.19887992 A |
</details>
<details>
  <summary> 
    
  ### Chapter 4 Project: DC Solver of Non-linear Circuits
  </summary>

* Implement a DC Solver for non-linear circuit
  * Use the existing parser
  * Use the existing linear solver
  * Use simple quadratic model for MOSFETs
  * Use Ebres-Moll model for BJTs
  * Use standard exponential law for diodes
  * Use Newton's method
  * Use damping technique to improve the chances of convergence
* Implementation: function DCSolver.m 
  * Input: Circuit struct (parser's ouput) 
  * Output: Vector of values of the unknown vector of MNA system
  * How to run:
    * Circuit = parser(netlist_file);
    * x = DCSolver(Circuit); 
* Test: To do the DC sweep on the test circuit in the book, use the script DCSolver_sweep.m
  * Test circuit diagram:   <br />
      <picture>
         <img alt="Non-Linear Circuit Diagram" src="pics/nonlinear_test_circuit_diagram.PNG?raw=true">
      </picture> 
  * Reference Solution:   <br />
        <picture>
           <img alt="DC Reference Solution" src="pics/nonlinear_test_circuit_solution.PNG?raw=true">
        </picture>
  * Results:   <br />
        <picture>
           <img alt="DC Result" src="pics/DC_Solution.png?raw=true">
        </picture>
</details>
<details>
  <summary> 
    
  ### Chapter 5 Project: Time-domain Circuit Simulator
  </summary>

* Implement a transient solver for non-linear circuit
  * Use the existing parser
  * Use the existing DC solver
  * Use trapezoidal method for discretization
  * Implement time step control by estimating the LTE
* Implementation: Script transient_solve.m
  * Input: netlist file 
  * Output: Plot the transient waveforms for the desired outputs
* Test: 
  * Test circuit diagram:   <br />
      <picture>
         <img alt="Transient Circuit Diagram" src="pics/tran_test_circuit_diagram.PNG?raw=true">
      </picture> 
  * Reference Solution:   <br />
        <picture>
           <img alt="Transient Reference Solution" src="pics/tran_test_circuit_solution.PNG?raw=true">
        </picture>
  * Results:   <br />
        <picture>
           <img alt="Transient Result" src="pics/TRAN_Solution.PNG?raw=true">
        </picture>
</details>
