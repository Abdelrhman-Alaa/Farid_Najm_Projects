# Farid_Najm_Projects
### MATLAB Implementation of the computer project of "Circuit Simulation" book by Farid Najm  
<details>
  <summary> 
    Chapter 1 Project: Parser
  </summary>
&nbsp;&nbsp;&nbsp;&nbsp;Write a parser that can read a circuit specification in terms of a simple “language”:  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; V[int] [node.+] [node.-] [[value]]   <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; I[int] [node.+] [node.-] [value] [[G2]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; R[int] [node.+] [node.-] [value] [[G2]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; C[int] [node.+] [node.-] [value] [[G2]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; L[int] [node.+] [node.-] [value]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; D[int] [node.+] [node.-] [[value]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; QN[int] [node.C] [node.B] [node.E] [[value]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; QP[int] [node.C] [node.B] [node.E] [[value]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; MN[int] [node.D] [node.G] [node.S] [[value]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; MP[int] [node.D] [node.G] [node.S] [[value]]  <br />
&nbsp;&nbsp;&nbsp;&nbsp;Notes:  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Inputs between double square brackets are optional.  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Nodes must be consecutive numbers 0,1,...,n.  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Node 0 is ground.  <br />
&nbsp;&nbsp;&nbsp;&nbsp;Implementation: function parser.m  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Input: netlist file  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Output: MATLAB struct that contains all the circuit records.  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How to run: parser(netlist_file)  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Example: Circuit = parser('parser_test.txt');  <br />
</details>

<details>
  <summary> 
    Chapter 2 & 3 Projects: Build MNA matrix and solve MNA system
  </summary>
&nbsp;&nbsp;&nbsp;&nbsp;Implement a program to solve linear resistive circuits  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 1. Use the parser -implemented in Ch1 project- to parse the netlist   <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 2. Build the MNA matrix using the stamps of the circuit elements  <br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 3. Solve the MNA system  <br />
&nbsp;&nbsp;&nbsp;&nbsp;Implementation: function linear_solver_tb.m  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Input: netlist file  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Output: Vector of values of the unknown vector of MNA system  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How to run: linear_solver_tb(netlist_file)  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Example: x = parser('parser_test.txt');  <br />
&nbsp;&nbsp;&nbsp;&nbsp;Test:  <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test circuit diagram:  <br />
  ![Alt text](linear_test_circuit_diagram.PNG?raw=true "Test circuit diagram")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Test circuit netlist:  <br />
</details>
