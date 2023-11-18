# Farid_Najm_Projects
MATLAB Implementation of the computer project of "Circuit Simulation" book by Farid Najm  
Chapter 1 Project:  
&nbsp;&nbsp;&nbsp;&nbsp;Write a parser that can read a circuit specification in terms of a simple “language”:  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; V<int> <node.+> <node.-> <value>  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; I<int> <node.+> <node.-> <value> [G2]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; R<int> <node.+> <node.-> <value> [G2]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; C<int> <node.+> <node.-> <value> [G2]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; L<int> <node.+> <node.-> <value>  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; D<int> <node.+> <node.-> [\<value\>]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; QN<int> <node.C> <node.B> <node.E> [\<value\>]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; QP<int> <node.C> <node.B> <node.E> [\<value\>]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; MN<int> <node.D> <node.G> <node.S> [\<value\>]  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; MP<int> <node.D> <node.G> <node.S> [\<value\>]  
&nbsp;&nbsp;&nbsp;&nbsp;Notes:  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Inputs between square brackets are optional.  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Nodes must be consecutive numbers 0,1,...,n.  
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Node 0 is ground.  
&nbsp;&nbsp;&nbsp;&nbsp;Implementation: function parser.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Input: netlist file  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Output: MATLAB struct that contains all the circuit records.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;How to run: parser(netlist_name)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Example: Circuit = parser('parser_test.txt');  
